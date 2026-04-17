-- Replace community SELECT policy to also cover anon role with proper conditions
DROP POLICY IF EXISTS "entrees_select_communaute" ON public.entrees;
CREATE POLICY "entrees_select_communaute"
  ON public.entrees
  FOR SELECT
  TO anon, authenticated
  USING (
    latitude IS NOT NULL
    AND longitude IS NOT NULL
    AND is_restricted = false
  );
