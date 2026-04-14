-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — Système de signalement
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── Colonne is_restricted sur entrees ───────────────────────────────────────

ALTER TABLE public.entrees
  ADD COLUMN is_restricted BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN public.entrees.is_restricted IS
  'true si l''entrée a été signalée 3 fois ou plus — masquée de la vue communautaire.';

-- Index partiel pour filtrer rapidement les entrées non-restreintes
CREATE INDEX entrees_is_restricted_idx ON public.entrees (is_restricted)
  WHERE is_restricted = false;

-- ─── Politique RLS communautaire sur entrees ─────────────────────────────────
-- Permet aux utilisateurs authentifiés de lire les entrées non-restreintes
-- (carte communautaire). Combinée en OR avec la politique existante "entrees_select_own",
-- un utilisateur voit : ses propres entrées (y compris restreintes) + toutes
-- les entrées non-restreintes des autres.

CREATE POLICY "entrees_select_communaute" ON public.entrees
  FOR SELECT TO authenticated
  USING (is_restricted = false);

-- ─── Table signalements ───────────────────────────────────────────────────────

CREATE TABLE public.signalements (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  entree_id    UUID        NOT NULL REFERENCES public.entrees(id)  ON DELETE CASCADE,
  reporter_id  UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  -- Raison du signalement : 'inapproprie' | 'offensant' | 'spam' | 'autre'
  raison       TEXT        NOT NULL,
  -- Précisions optionnelles laissées par le signalant (max 150 chars côté Flutter)
  details      TEXT,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Un utilisateur ne peut signaler une entrée qu'une seule fois
  UNIQUE (entree_id, reporter_id)
);

COMMENT ON TABLE public.signalements IS
  'Signalements de lucioles par les utilisateurs. 3 signalements distincts → is_restricted = true.';

-- Index pour compter rapidement les signalements d'une entrée (utilisé par l'edge function)
CREATE INDEX signalements_entree_id_idx ON public.signalements (entree_id);

-- ─── RLS sur signalements ─────────────────────────────────────────────────────

ALTER TABLE public.signalements ENABLE ROW LEVEL SECURITY;

-- Tout utilisateur authentifié peut insérer un signalement en son nom
CREATE POLICY "signalements_insert_auth" ON public.signalements
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = reporter_id);

-- Chaque utilisateur ne voit que ses propres signalements
-- (permet de vérifier côté app si l'utilisateur a déjà signalé une entrée)
CREATE POLICY "signalements_select_own" ON public.signalements
  FOR SELECT TO authenticated
  USING (auth.uid() = reporter_id);
