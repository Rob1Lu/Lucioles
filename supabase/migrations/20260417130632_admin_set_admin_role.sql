-- Accorder ou retirer les droits admin à un utilisateur
CREATE OR REPLACE FUNCTION public.admin_set_admin_role(
  target_user_id uuid,
  grant_admin     boolean
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

  IF target_user_id = auth.uid() THEN
    RAISE EXCEPTION 'Cannot modify your own admin role';
  END IF;

  UPDATE public.profiles
  SET is_admin = grant_admin
  WHERE id = target_user_id;
END;
$$;
