CREATE OR REPLACE FUNCTION public.admin_get_feedbacks()
RETURNS TABLE (
  id          UUID,
  user_id     UUID,
  user_email  TEXT,
  username    TEXT,
  type        TEXT,
  message     TEXT,
  created_at  TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles p
    WHERE p.id = auth.uid() AND p.is_admin = TRUE
  ) THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    f.id,
    f.user_id,
    au.email::TEXT   AS user_email,
    p.username       AS username,
    f.type,
    f.message,
    f.created_at
  FROM public.feedbacks f
  LEFT JOIN auth.users au  ON au.id  = f.user_id
  LEFT JOIN public.profiles p ON p.id = f.user_id
  ORDER BY f.created_at DESC;
END;
$$;
