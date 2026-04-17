-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — Feedbacks utilisateurs
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE public.feedbacks (
  id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     UUID        REFERENCES auth.users(id) ON DELETE SET NULL,
  type        TEXT        CHECK (type IN ('bug', 'suggestion', 'autre')),
  message     TEXT        NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.feedbacks IS
  'Retours utilisateurs envoyés depuis l''application.';

ALTER TABLE public.feedbacks ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs connectés peuvent envoyer un feedback
CREATE POLICY "feedbacks_insert" ON public.feedbacks
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

-- Seuls les admins peuvent lire les feedbacks
CREATE POLICY "feedbacks_select_admin" ON public.feedbacks
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND is_admin = true
    )
  );
