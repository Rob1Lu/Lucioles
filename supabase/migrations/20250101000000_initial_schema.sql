-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — schéma initial
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── Extensions ──────────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─── Profils utilisateur ──────────────────────────────────────────────────────
-- Étend auth.users sans modifier la table système Supabase.
CREATE TABLE public.profiles (
  id          UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username    TEXT,
  avatar_url  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.profiles IS 'Profil public de chaque utilisateur Lucioles.';

-- Mise à jour automatique de updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Création automatique du profil à l'inscription
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id)
  VALUES (NEW.id)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ─── Entrées (lucioles) ───────────────────────────────────────────────────────
CREATE TABLE public.entrees (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  texte          TEXT        NOT NULL,
  latitude       FLOAT8,
  longitude      FLOAT8,
  lieu_nom       TEXT,
  -- URL dans Supabase Storage (bucket entree-photos) — null si pas de photo
  photo_url      TEXT,
  date_creation  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Valeur de l'enum Saison côté Flutter : toutes/printemps/ete/automne/hiver
  saison         TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE public.entrees IS 'Observations positives du quartier — une par jour par utilisateur.';
COMMENT ON COLUMN public.entrees.photo_url IS 'Chemin dans le bucket entree-photos (ex: <user_id>/<entree_id>.jpg)';

-- Index pour les requêtes fréquentes
CREATE INDEX entrees_user_id_date_idx ON public.entrees (user_id, date_creation DESC);
CREATE INDEX entrees_user_id_saison_idx ON public.entrees (user_id, saison);
CREATE INDEX entrees_geodata_idx ON public.entrees (user_id, latitude, longitude)
  WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- ─── Row Level Security ───────────────────────────────────────────────────────

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.entrees  ENABLE ROW LEVEL SECURITY;

-- Profiles : chaque utilisateur ne voit et modifie que le sien
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- Entrées : CRUD restreint au propriétaire
CREATE POLICY "entrees_select_own" ON public.entrees
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "entrees_insert_own" ON public.entrees
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "entrees_update_own" ON public.entrees
  FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "entrees_delete_own" ON public.entrees
  FOR DELETE USING (auth.uid() = user_id);

-- ─── Realtime ─────────────────────────────────────────────────────────────────
-- Active le canal realtime sur la table entrees (insertions, mises à jour,
-- suppressions seront poussées en temps réel au client Flutter).
ALTER PUBLICATION supabase_realtime ADD TABLE public.entrees;

-- ─── Storage : buckets ───────────────────────────────────────────────────────

-- Photos de lucioles — privées, organisées par user_id/<entree_id>.<ext>
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'entree-photos',
  'entree-photos',
  false,
  5242880,   -- 5 Mo max par photo
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic']
) ON CONFLICT (id) DO NOTHING;

-- Photos de profil — privées, organisées par <user_id>/avatar.<ext>
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  false,
  2097152,   -- 2 Mo max
  ARRAY['image/jpeg', 'image/png', 'image/webp']
) ON CONFLICT (id) DO NOTHING;

-- ─── Storage : policies ───────────────────────────────────────────────────────

-- entree-photos : l'utilisateur accède uniquement à son propre dossier
-- Convention de nommage : entree-photos/<user_id>/<filename>

CREATE POLICY "entree_photos_insert_own" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'entree-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "entree_photos_select_own" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'entree-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "entree_photos_update_own" ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'entree-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "entree_photos_delete_own" ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'entree-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- avatars : même logique
-- Convention de nommage : avatars/<user_id>/avatar.<ext>

CREATE POLICY "avatars_insert_own" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "avatars_select_own" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "avatars_update_own" ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "avatars_delete_own" ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );
