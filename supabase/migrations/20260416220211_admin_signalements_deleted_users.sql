-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — Signalements : inclure les entrées d'utilisateurs supprimés
-- ═══════════════════════════════════════════════════════════════════════════

DROP FUNCTION IF EXISTS public.admin_get_signalements();

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
  user_reported_count  bigint,
  user_deleted         boolean
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
    )::bigint                           AS user_reported_count,
    (au.deleted_at IS NOT NULL)         AS user_deleted
  FROM public.entrees e
  INNER JOIN public.signalements s  ON s.entree_id = e.id
  LEFT JOIN  public.profiles p      ON p.id = e.user_id
  LEFT JOIN  auth.users au          ON au.id = e.user_id
  WHERE e.admin_reviewed_at IS NULL
  GROUP BY e.id, e.texte, e.photo_url, e.date_creation, e.is_restricted,
           au.id, au.email, p.username, p.avatar_url, au.deleted_at
  ORDER BY COUNT(DISTINCT s.id) DESC, e.date_creation DESC;
END;
$$;
