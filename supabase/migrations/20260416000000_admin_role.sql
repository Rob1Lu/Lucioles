-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — Rôle administrateur
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── Colonne is_admin sur profiles ───────────────────────────────────────────

ALTER TABLE public.profiles
  ADD COLUMN is_admin BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN public.profiles.is_admin IS
  'true si l''utilisateur est administrateur Lucioles.';

-- ─── Fonctions admin (SECURITY DEFINER) ──────────────────────────────────────

-- Statistiques globales : nombre d'utilisateurs et de lucioles
CREATE OR REPLACE FUNCTION public.admin_get_stats()
RETURNS json
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  caller_is_admin boolean := false;
BEGIN
  SELECT is_admin INTO caller_is_admin
  FROM public.profiles WHERE id = auth.uid();

  IF NOT COALESCE(caller_is_admin, false) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN json_build_object(
    'user_count',   (SELECT COUNT(*) FROM auth.users WHERE deleted_at IS NULL),
    'luciole_count', (SELECT COUNT(*) FROM public.entrees)
  );
END;
$$;

-- Liste de tous les utilisateurs (triée alphabétiquement)
CREATE OR REPLACE FUNCTION public.admin_get_users()
RETURNS TABLE(
  id           uuid,
  email        text,
  username     text,
  avatar_url   text,
  created_at   timestamptz,
  is_admin     boolean,
  luciole_count bigint
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  caller_is_admin boolean := false;
BEGIN
  SELECT p.is_admin INTO caller_is_admin
  FROM public.profiles p WHERE p.id = auth.uid();

  IF NOT COALESCE(caller_is_admin, false) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    au.id,
    au.email::text,
    p.username,
    p.avatar_url,
    au.created_at,
    COALESCE(p.is_admin, false) AS is_admin,
    COUNT(e.id)::bigint         AS luciole_count
  FROM auth.users au
  LEFT JOIN public.profiles p ON p.id = au.id
  LEFT JOIN public.entrees e  ON e.user_id = au.id
  WHERE au.deleted_at IS NULL
  GROUP BY au.id, au.email, p.username, p.avatar_url, au.created_at, p.is_admin
  ORDER BY LOWER(COALESCE(p.username, au.email::text));
END;
$$;

-- Suppression d'un utilisateur par un admin
CREATE OR REPLACE FUNCTION public.admin_delete_user(target_user_id uuid)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  caller_is_admin boolean := false;
BEGIN
  SELECT p.is_admin INTO caller_is_admin
  FROM public.profiles p WHERE p.id = auth.uid();

  IF NOT COALESCE(caller_is_admin, false) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF target_user_id = auth.uid() THEN
    RAISE EXCEPTION 'Cannot delete own account via admin panel';
  END IF;

  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;

-- Entrées d'un utilisateur spécifique (pour le portail admin)
CREATE OR REPLACE FUNCTION public.admin_get_user_entrees(target_user_id uuid)
RETURNS SETOF public.entrees
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  caller_is_admin boolean := false;
BEGIN
  SELECT p.is_admin INTO caller_is_admin
  FROM public.profiles p WHERE p.id = auth.uid();

  IF NOT COALESCE(caller_is_admin, false) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT * FROM public.entrees
  WHERE user_id = target_user_id
  ORDER BY date_creation DESC;
END;
$$;

-- ─── Storage : accès admin aux photos ────────────────────────────────────────

-- Permet aux admins de lire (et générer des signed URLs pour) tous les avatars
CREATE POLICY "avatars_select_admin" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'avatars'
    AND EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );

-- Permet aux admins de lire toutes les photos de lucioles
CREATE POLICY "entree_photos_select_admin" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'entree-photos'
    AND EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );
