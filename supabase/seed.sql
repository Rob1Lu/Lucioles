-- ═══════════════════════════════════════════════════════════════════════════
-- Lucioles — données de seed (développement local uniquement)
-- ═══════════════════════════════════════════════════════════════════════════
-- Ce fichier est exécuté après chaque `supabase db reset`.
-- Les UUIDs utilisateurs sont fixes pour faciliter les tests reproductibles.

-- Utilisateur de test (créé via GoTrue en local)
-- Email : test@lucioles.dev  |  Mot de passe : lucioles2024
DO $$
DECLARE
  test_user_id UUID := '00000000-0000-0000-0000-000000000001';
BEGIN
  -- Insère directement dans auth.users (bypass email confirmation en local)
  INSERT INTO auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, created_at, updated_at,
    raw_app_meta_data, raw_user_meta_data, is_super_admin
  ) VALUES (
    test_user_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'test@lucioles.dev',
    crypt('lucioles2024', gen_salt('bf')),
    NOW(), NOW(), NOW(),
    '{"provider":"email","providers":["email"]}',
    '{}',
    false
  ) ON CONFLICT (id) DO NOTHING;

  -- Le trigger handle_new_user crée le profil automatiquement,
  -- mais on le met à jour avec un username lisible
  UPDATE public.profiles
  SET username = 'Testeur Lucioles'
  WHERE id = test_user_id;

  -- Quelques entrées de test géolocalisées autour de Paris
  INSERT INTO public.entrees (user_id, texte, latitude, longitude, lieu_nom, date_creation, saison)
  VALUES
    (test_user_id,
     'Un rayon de soleil entre deux immeubles haussmanniens, juste au bon moment.',
     48.8566, 2.3522, 'Île de la Cité, Paris',
     NOW() - INTERVAL '2 days', 'printemps'),

    (test_user_id,
     'Une vieille dame arrosait ses géraniums en chantonnant. Moment suspendu.',
     48.8737, 2.3470, 'Montmartre, Paris',
     NOW() - INTERVAL '5 days', 'printemps'),

    (test_user_id,
     'Odeur de pain chaud depuis la boulangerie du coin. Le quartier s''est réveillé.',
     48.8534, 2.3488, 'Saint-Germain-des-Prés, Paris',
     NOW() - INTERVAL '10 days', 'printemps'),

    (test_user_id,
     'Des enfants jouaient aux billes sur le trottoir. Je ne savais pas que ça existait encore.',
     48.8686, 2.3432, 'Le Marais, Paris',
     NOW() - INTERVAL '30 days', 'hiver'),

    (test_user_id,
     'Premier café de la terrasse après des mois d''hiver. Le soleil était doux.',
     48.8602, 2.3477, 'Place des Vosges, Paris',
     NOW() - INTERVAL '45 days', 'hiver')
  ON CONFLICT DO NOTHING;

END $$;
