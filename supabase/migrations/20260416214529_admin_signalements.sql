-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — Gestion admin des signalements
-- ═══════════════════════════════════════════════════════════════════════════

-- ─── Colonne admin_reviewed_at sur entrees ────────────────────────────────────

ALTER TABLE public.entrees
  ADD COLUMN admin_reviewed_at TIMESTAMPTZ;

COMMENT ON COLUMN public.entrees.admin_reviewed_at IS
  'Horodatage de la décision admin sur cette entrée. NULL = en attente de modération.';

-- ─── Fonctions admin signalements ─────────────────────────────────────────────

-- Liste des lucioles signalées en attente de modération
CREATE OR REPLACE FUNCTION public.admin_get_signalements()
RETURNS TABLE(
  entree_id            uuid,
  texte                text,
  photo_url            text,
  date_creation        timestamptz,
  is_restricted        boolean,
  signalement_count    bigint,
  user_id              uuid,
  user_email           text,
  username             text,
  avatar_url           text,
  user_reported_count  bigint
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  caller_is_admin boolean := false;
BEGIN
  SELECT p.is_admin INTO caller_is_admin FROM public.profiles p WHERE p.id = auth.uid();
  IF NOT COALESCE(caller_is_admin, false) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    e.id                                AS entree_id,
    e.texte,
    e.photo_url,
    e.date_creation,
    COALESCE(e.is_restricted, false)    AS is_restricted,
    COUNT(DISTINCT s.id)::bigint        AS signalement_count,
    au.id                               AS user_id,
    au.email::text                      AS user_email,
    p.username,
    p.avatar_url,
    (
      SELECT COUNT(DISTINCT e2.id)
      FROM public.entrees e2
      INNER JOIN public.signalements s2 ON s2.entree_id = e2.id
      WHERE e2.user_id = au.id
    )::bigint                           AS user_reported_count
  FROM public.entrees e
  INNER JOIN public.signalements s  ON s.entree_id = e.id
  LEFT JOIN  public.profiles p      ON p.id = e.user_id
  LEFT JOIN  auth.users au          ON au.id = e.user_id
  WHERE e.admin_reviewed_at IS NULL
    AND au.deleted_at IS NULL
  GROUP BY e.id, e.texte, e.photo_url, e.date_creation, e.is_restricted,
           au.id, au.email, p.username, p.avatar_url
  ORDER BY COUNT(DISTINCT s.id) DESC, e.date_creation DESC;
END;
$$;

-- Décision admin sur une luciole signalée
CREATE OR REPLACE FUNCTION public.admin_review_entree(
  target_entree_id uuid,
  action           text  -- 'approved' | 'restricted'
)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  caller_is_admin boolean := false;
BEGIN
  SELECT p.is_admin INTO caller_is_admin FROM public.profiles p WHERE p.id = auth.uid();
  IF NOT COALESCE(caller_is_admin, false) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF action NOT IN ('approved', 'restricted') THEN
    RAISE EXCEPTION 'Invalid action: %', action;
  END IF;

  UPDATE public.entrees
  SET
    admin_reviewed_at = NOW(),
    is_restricted     = (action = 'restricted')
  WHERE id = target_entree_id;
END;
$$;