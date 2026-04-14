# Lucioles

Atlas émotionnel personnel — note ce qui t'a touché aujourd'hui dans ton quartier, et vois tes souvenirs s'allumer comme des lucioles sur une carte.

## Fonctionnalités

- **Saisie quotidienne** — une entrée par jour, texte libre (280 caractères), géolocalisation et photo optionnelles
- **Carte nocturne** — toutes tes lucioles géolocalisées sur un fond cartographique sombre, avec filtres par période
- **Vue communautaire** — les lucioles géolocalisées des autres utilisateurs sont visibles sur la carte
- **Signalement** — bouton discret sur chaque fiche pour signaler un contenu inapproprié ; après 3 signalements distincts, la luciole est automatiquement masquée
- **Fil du temps** — historique chronologique avec filtres par saison
- **Profil** — statistiques, photo de profil, pseudo
- **Authentification** — email/mot de passe, Google Sign-In, Apple Sign-In
- **Multilingue** — français, anglais, espagnol

## Stack

| Couche | Technologie |
|--------|-------------|
| Mobile | Flutter (Dart) |
| Backend | Supabase (PostgreSQL, Auth, Storage, Edge Functions) |
| Carte | flutter_map + OpenStreetMap (tuiles CartoCDN Dark Matter) |
| État | Provider |
| Auth OAuth | Google Sign-In, Apple Sign-In |

## Architecture

```
lib/
├── app.dart                        # Navigation principale, thème
├── core/
│   ├── constants.dart              # Constantes (zoom, couleurs…)
│   └── theme.dart                  # Palette & typographie
├── data/
│   ├── models/entree.dart          # Modèle Entree
│   ├── entree_repository.dart      # Abstraction dépôt
│   ├── supabase_entree_datasource.dart  # Requêtes Supabase
│   └── signalement_datasource.dart # Signalements + edge function
├── features/
│   ├── auth/                       # Écrans connexion / inscription
│   ├── carte/                      # Carte + marqueurs + bottom sheets
│   ├── profil/                     # Profil utilisateur
│   └── saisie/                     # Saisie quotidienne
├── l10n/                           # Fichiers de localisation (.arb)
└── shared/
    └── providers/                  # AuthProvider, EntreesProvider, LocaleProvider
supabase/
├── migrations/
│   ├── 20250101000000_initial_schema.sql   # Schéma initial
│   └── 20260412000000_signalements.sql     # Table signalements + is_restricted
└── functions/
    └── check-signalements/index.ts  # Edge function : restriction automatique
```

## Base de données

### Tables principales

| Table | Description |
|-------|-------------|
| `profiles` | Profils utilisateurs (étend `auth.users`) |
| `entrees` | Observations quotidiennes (texte, GPS, photo, saison) |
| `signalements` | Signalements de lucioles — 1 max par utilisateur par entrée |

### Modération automatique

La colonne `entrees.is_restricted` est positionnée à `true` par l'edge function `check-signalements` dès que 3 utilisateurs distincts signalent la même entrée. Les entrées restreintes disparaissent de la carte communautaire (filtrées côté client et côté RLS).

### RLS (Row Level Security)

- `entrees` : lecture restreinte à ses propres entrées **ou** aux entrées non-restreintes (`is_restricted = false`)
- `signalements` : insertion et lecture restreintes au reporter (`reporter_id = auth.uid()`)
- `profiles` : lecture et modification restreintes au propriétaire

## Développement local

### Prérequis

- Flutter ≥ 3.x
- Supabase CLI
- Docker (pour la base locale)

### Démarrer

```bash
# 1. Cloner le dépôt
git clone <repo>
cd lucioles

# 2. Créer le fichier de secrets local (jamais commité)
cp .env.example .env.local
# → renseigner FLUTTER_SUPABASE_URL et FLUTTER_SUPABASE_ANON_KEY
#   (récupérables via : supabase status  ou  supabase.com/dashboard)

# 3. Démarrer Supabase en local
supabase start

# 4. Appliquer les migrations + seed
supabase db reset

# 5. Lancer l'app en injectant les variables
flutter run --dart-define-from-file=.env.local
```

### Servir les edge functions en local

```bash
supabase functions serve check-signalements
```

## Déploiement

```bash
# Pousser les migrations
supabase db push

# Déployer l'edge function (JWT non requis — utilise le service role en interne)
supabase functions deploy check-signalements --no-verify-jwt
```

## Localisation

Les fichiers `.arb` sont dans `lib/l10n/`. Après modification, régénérer le code Dart :

```bash
flutter gen-l10n
```
