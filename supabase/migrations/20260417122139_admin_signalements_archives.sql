-- Liste des lucioles signalées déjà traitées par un admin
CREATE OR REPLACE FUNCTION public.admin_get_signalements_archives()
RETURNS TABLE(
  entree_id            uuid,
  texte                text,
  date_creation        timestamptz,
  admin_reviewed_at    timestamptz,
  is_restricted        boolean,
  signalement_count    bigint,
  user_id              uuid,
  user_email           text,
  username             text,
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
    e.id                             AS entree_id,
    e.texte,
    e.date_creation,
    e.admin_reviewed_at,
    COALESCE(e.is_restricted, false) AS is_restricted,
    COUNT(DISTINCT s.id)::bigint     AS signalement_count,
    au.id                            AS user_id,
    au.email::text                   AS user_email,
    p.username,
    (au.deleted_at IS NOT NULL)      AS user_deleted
  FROM public.entrees e
  INNER JOIN public.signalements s ON s.entree_id = e.id
  LEFT JOIN  public.profiles p     ON p.id = e.user_id
  LEFT JOIN  auth.users au         ON au.id = e.user_id
  WHERE e.admin_reviewed_at IS NOT NULL
  GROUP BY e.id, e.texte, e.date_creation, e.admin_reviewed_at, e.is_restricted,
           au.id, au.email, p.username, au.deleted_at
  ORDER BY e.admin_reviewed_at DESC;
END;
$$;
