// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Lucioles';

  @override
  String get navSaisie => 'Saisie';

  @override
  String get navCarte => 'Carte';

  @override
  String get navMoi => 'Moi';

  @override
  String get saisieAppBarTitle => 'Lucioles';

  @override
  String get saisieBadgeDuJour => 'Ta luciole du jour';

  @override
  String get saisieDejaFaite =>
      'Reviens demain pour allumer\nune nouvelle luciole.';

  @override
  String get saisieQuestion => 'Aujourd\'hui,\ndans ton quartier…';

  @override
  String get saisieSubtitle => 'Note une chose positive que tu as remarquée.';

  @override
  String get saisieHint =>
      'Un rayon de soleil entre les immeubles, une conversation inattendue, des fleurs sur un balcon…';

  @override
  String get saisieLieuLabel => 'Lieu (optionnel)';

  @override
  String get saisiePhotoLabel => 'Photo (optionnel)';

  @override
  String get saisieButtonAllumer => 'Allumer une luciole ✦';

  @override
  String get saisieConfirmation => 'Ta luciole est allumée.';

  @override
  String get saisieValidator => 'Écris quelques mots…';

  @override
  String get saisieAjouterPhoto => 'Ajouter une photo';

  @override
  String get saisieAjouterPhotoAposteriori => 'Ajouter une photo';

  @override
  String get saisieAjoutPhotoConfirmation =>
      'Photo ajoutée à ta luciole du jour ✦';

  @override
  String get lieuUtiliserPosition => 'Utiliser ma position';

  @override
  String get lieuLocalisation => 'Localisation en cours…';

  @override
  String get lieuPersonnaliserNom =>
      'Personnaliser le nom du lieu… (optionnel)';

  @override
  String get lieuNomHint => 'Donner un nom à cet endroit… (optionnel)';

  @override
  String get lieuGeolocDesactive => 'La géolocalisation est désactivée.';

  @override
  String get lieuPermissionRefusee => 'Permission de localisation refusée.';

  @override
  String get lieuPermissionDefinitive =>
      'Permission refusée définitivement. Vérifie les réglages.';

  @override
  String get lieuErreur => 'Impossible d\'obtenir la position.';

  @override
  String get carteMonAtlas => 'Mon atlas';

  @override
  String carteLucioles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lucioles',
      one: '1 luciole',
    );
    return '$_temp0';
  }

  @override
  String get carteFiltres => 'Filtres';

  @override
  String get carteFiltresPeriode => 'Période';

  @override
  String get carteFiltresReinitialiser => 'Réinitialiser';

  @override
  String get carteFiltresUniquement => 'Uniquement mes lucioles';

  @override
  String get carteFiltresCommunaute => 'Masque les lucioles de la communauté';

  @override
  String get carteFiltresChoisirDates => 'Choisir les dates…';

  @override
  String get carteDatePickerTitre => 'Choisir une période';

  @override
  String get carteDatePickerAnnuler => 'Annuler';

  @override
  String get carteDatePickerConfirmer => 'Confirmer';

  @override
  String get carteAtlasVide => 'Ton atlas est encore vide.';

  @override
  String get carteAtlasVideSub =>
      'Ajoute un lieu à ta prochaine entrée pour\nvoir ta première luciole s\'allumer ici.';

  @override
  String get carteAucunePeriode => 'Aucune luciole sur cette période.';

  @override
  String get carteAucunePeriodeSub =>
      'Essaie une autre période ou\nréinitialise les filtres.';

  @override
  String get carteReinitialiserFiltres => 'Réinitialiser les filtres';

  @override
  String get filterToday => 'Aujourd\'hui';

  @override
  String get filterWeek => 'Cette semaine';

  @override
  String get filterMonth => 'Ce mois-ci';

  @override
  String get filterYear => 'Cette année';

  @override
  String get filterCustom => 'Personnalisé';

  @override
  String get filterTodayShort => 'Auj.';

  @override
  String get filterWeekShort => 'Semaine';

  @override
  String get filterMonthShort => 'Ce mois';

  @override
  String get filterYearShort => 'Cette année';

  @override
  String get filterCustomShort => 'Perso.';

  @override
  String get saisonToutes => 'Toutes';

  @override
  String get saisonPrintemps => 'Printemps';

  @override
  String get saisonEte => 'Été';

  @override
  String get saisonAutomne => 'Automne';

  @override
  String get saisonHiver => 'Hiver';

  @override
  String get profilTitle => 'Profil';

  @override
  String get profilStatsSection => 'Mes lucioles';

  @override
  String profilLucioles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lucioles allumées',
      one: '1 luciole allumée',
      zero: 'Aucune luciole allumée',
    );
    return '$_temp0';
  }

  @override
  String profilDepuis(String date) {
    return 'Depuis le $date';
  }

  @override
  String get profilLangueSection => 'Langue';

  @override
  String get profilFilSection => 'Fil du temps';

  @override
  String get profilCompteSection => 'Compte';

  @override
  String get profilConnecteEmail => 'Connecté en tant que';

  @override
  String get profilNonConnecteTitre => 'Tu n\'es pas connecté';

  @override
  String get profilNonConnecteSousTitre =>
      'Connecte-toi pour allumer des lucioles et retrouver tous tes souvenirs.';

  @override
  String get profilNonConnecteBouton => 'Se connecter';

  @override
  String get profilPseudo => 'Pseudo';

  @override
  String get profilAjouterPseudo => 'Ajouter un pseudo';

  @override
  String get profilModifierPseudo => 'Modifier le pseudo';

  @override
  String get profilSauvegarder => 'Sauvegarder';

  @override
  String get profilPhotoAvatar => 'Photo de profil';

  @override
  String get profilZoneSensible => 'Zone sensible';

  @override
  String get profilSupprimerCompte => 'Supprimer mon compte';

  @override
  String get profilSupprimerTitre => 'Supprimer mon compte ?';

  @override
  String get profilSupprimerMessage =>
      'Ton compte sera supprimé définitivement. Tes lucioles seront conservées de façon anonyme mais ne seront plus accessibles. Cette action est irréversible.';

  @override
  String get profilSupprimerConfirmer => 'Supprimer définitivement';

  @override
  String get profilLierGoogle => 'Lier un compte Google';

  @override
  String get profilLierGoogleConfirmation => 'Compte Google lié avec succès';

  @override
  String get profilCompteLie => 'Compte lié';

  @override
  String get profilLierApple => 'Lier un compte Apple';

  @override
  String get profilAppleBientot => 'Liaison Apple bientôt disponible';

  @override
  String get profilConnexion => 'Connexion';

  @override
  String get profilParametresCompte => 'Paramètres du compte';

  @override
  String get filVide => 'Ton atlas est encore vide.';

  @override
  String get filVideSub =>
      'Commence par noter ce qui t\'a touché aujourd\'hui.';

  @override
  String filVideFiltre(String saison) {
    return 'Aucune luciole\ncet $saison.';
  }

  @override
  String get filVideFiltreSub =>
      'Change de saison pour explorer d\'autres souvenirs.';

  @override
  String get filSupprimerLabel => 'Supprimer';

  @override
  String get filSupprimerTitre => 'Supprimer cette luciole ?';

  @override
  String get filSupprimerContenu =>
      'Cette action est irréversible. Ton souvenir sera définitivement effacé.';

  @override
  String get filSupprimerAnnuler => 'Annuler';

  @override
  String get filSupprimerConfirmer => 'Supprimer';

  @override
  String get authBienvenue => 'Bienvenue dans les Lucioles';

  @override
  String get authSousTitre =>
      'Note ce qui t\'a touché aujourd\'hui.\nTes souvenirs restent toujours les tiens.';

  @override
  String get authEmail => 'Adresse e-mail';

  @override
  String get authMotDePasse => 'Mot de passe';

  @override
  String get authSeConnecter => 'Se connecter';

  @override
  String get authSInscrire => 'Créer un compte';

  @override
  String get authOu => 'ou';

  @override
  String get authContinuerGoogle => 'Continuer avec Google';

  @override
  String get authContinuerApple => 'Continuer avec Apple';

  @override
  String get authPasDeCompte => 'Pas encore de compte ?';

  @override
  String get authDejaUnCompte => 'Déjà un compte ?';

  @override
  String get authLienCreerCompte => 'Créer un compte';

  @override
  String get authLienSeConnecter => 'Se connecter';

  @override
  String get authSeDeconnecter => 'Se déconnecter';

  @override
  String get authErreurEmailVide => 'Saisis ton adresse e-mail.';

  @override
  String get authErreurEmailInvalide => 'Adresse e-mail invalide.';

  @override
  String get authErreurMotDePasseCourt => 'Au moins 6 caractères.';

  @override
  String get authErreurGenerique => 'Une erreur est survenue. Réessaie.';

  @override
  String get authAppleBientot => 'Connexion Apple bientôt disponible';

  @override
  String get authGateTitre => 'Rejoins les Lucioles';

  @override
  String get authGateSousTitre =>
      'Crée un compte pour noter ce qui t\'a touché aujourd\'hui.\nTes souvenirs restent toujours les tiens.';

  @override
  String get authGateBouton => 'Se connecter ou créer un compte';

  @override
  String get adminAccesBouton => 'Portail admin';

  @override
  String get adminPortalTitle => 'Portail admin';

  @override
  String get adminPortalStats => 'Statistiques';

  @override
  String get adminPortalGestion => 'Gestion';

  @override
  String get adminPortalUtilisateurs => 'Gestion des utilisateurs';

  @override
  String get adminPortalSignalements => 'Gestion des signalements';

  @override
  String get adminPortalBientot => 'Bientôt';

  @override
  String get adminPortalFeedbacks => 'Feedbacks utilisateurs';

  @override
  String get adminUsersTitle => 'Utilisateurs';

  @override
  String get adminUsersRecherche => 'Rechercher un utilisateur…';

  @override
  String get adminUsersVide => 'Aucun utilisateur trouvé.';

  @override
  String get adminUsersSupprimerTitre => 'Supprimer l\'utilisateur ?';

  @override
  String adminUsersSupprimerMessage(String nom) {
    return 'Le compte de $nom sera supprimé définitivement. Cette action est irréversible.';
  }

  @override
  String get adminUserDetailTitle => 'Profil utilisateur';

  @override
  String get adminUsersGrantAdminTitre => 'Accorder les droits admin ?';

  @override
  String adminUsersGrantAdminMessage(String nom) {
    return '$nom aura accès au portail admin.';
  }

  @override
  String get adminUsersRevokeAdminTitre => 'Retirer les droits admin ?';

  @override
  String adminUsersRevokeAdminMessage(String nom) {
    return '$nom n\'aura plus accès au portail admin.';
  }

  @override
  String get adminLucioleRestrictTitre => 'Restreindre cette luciole ?';

  @override
  String get adminLucioleRestrictMsg =>
      'Elle sera masquée de la communauté. Cette action est réversible.';

  @override
  String get adminLucioleApprouverTitre => 'Approuver cette luciole ?';

  @override
  String get adminLucioleApprouverMsg =>
      'Elle sera de nouveau visible dans la communauté.';

  @override
  String get adminSignalementsUserSupprimeLabel => 'Compte supprimé';

  @override
  String get adminSignalementsTitle => 'Signalements';

  @override
  String get adminSignalementsVide => 'Aucun signalement en attente.';

  @override
  String get adminSignalementsApprouver => 'Approuver';

  @override
  String get adminSignalementsRestreindre => 'Restreindre';

  @override
  String get adminSignalementsTagRestreinte => 'Restreinte';

  @override
  String get adminSignalementsTagRecidiviste => 'Récidiviste';

  @override
  String get adminSignalementsVoirProfil => 'Voir le profil';

  @override
  String adminSignalementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count signalements',
      one: '1 signalement',
    );
    return '$_temp0';
  }

  @override
  String adminSignalementsLuciolesSig(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lucioles signalées',
      one: '1 luciole signalée',
    );
    return '$_temp0';
  }

  @override
  String get adminFeedbacksTitle => 'Feedbacks';

  @override
  String get adminFeedbacksVide => 'Aucun feedback pour l\'instant.';

  @override
  String get adminArchivesTitle => 'Archives';

  @override
  String get adminArchivesVide => 'Aucun signalement archivé.';

  @override
  String get adminArchivesRecherche => 'Email, pseudo, contenu, date…';

  @override
  String get adminArchivesApprouve => 'Approuvé';

  @override
  String get adminArchivesRestreint => 'Restreint';

  @override
  String adminArchivesDecisionLe(String date) {
    return 'Décidé le $date';
  }

  @override
  String adminArchivesPublieLe(String date) {
    return 'Publié le $date';
  }

  @override
  String get feedbackBouton => 'Donner ton avis';

  @override
  String get feedbackTitre => 'Partage ton avis';

  @override
  String get feedbackTypeBug => 'Bug';

  @override
  String get feedbackTypeSuggestion => 'Suggestion';

  @override
  String get feedbackTypeAutre => 'Autre';

  @override
  String get feedbackMessage => 'Ton message';

  @override
  String get feedbackMessageHint => 'Décris le problème ou ta suggestion…';

  @override
  String get feedbackEnvoyer => 'Envoyer';

  @override
  String get feedbackConfirmation => 'Merci pour ton retour !';

  @override
  String get feedbackErreur => 'Une erreur est survenue.';

  @override
  String get feedbackMessageVide => 'Écris un message.';

  @override
  String get donAccesBouton => 'Soutenir le développeur';

  @override
  String get donSousTitre => 'Buy Me a Coffee ☕';

  @override
  String get aideAccesBouton => 'Aide';

  @override
  String get aideTitle => 'Aide';

  @override
  String get aideFeedbackTitre => 'Partage ton avis';

  @override
  String get aideFeedbackSousTitre =>
      'Une suggestion, un bug, une idée ? Dis-nous tout.';

  @override
  String get aideTutorielsSection => 'Tutoriels';

  @override
  String get aideFAQSection => 'Questions fréquentes';

  @override
  String get aideTuto1Q => 'Comment allumer une luciole ?';

  @override
  String get aideTuto1R =>
      'Va dans l\'onglet « Saisie », note une chose positive que tu as observée dans ton quartier, puis appuie sur « Allumer une luciole ». Tu peux y ajouter un lieu et une photo.';

  @override
  String get aideTuto2Q => 'Comment ajouter un lieu à une entrée ?';

  @override
  String get aideTuto2R =>
      'Dans le formulaire de saisie, appuie sur le champ « Lieu ». Tu peux utiliser ta position GPS ou saisir un nom manuellement.';

  @override
  String get aideTuto3Q => 'Comment retrouver mes lucioles ?';

  @override
  String get aideTuto3R =>
      'Tes lucioles sont visibles dans l\'onglet « Carte » (sur la carte) et dans l\'onglet « Moi » (fil du temps). Seules les lucioles avec un lieu apparaissent sur la carte.';

  @override
  String get aideTuto4Q => 'Comment filtrer par saison ?';

  @override
  String get aideTuto4R =>
      'Dans l\'onglet « Moi », utilise les filtres de saison (Printemps, Été, Automne, Hiver) juste au-dessus de ton fil du temps.';

  @override
  String get aideFaq1Q => 'Puis-je supprimer une luciole ?';

  @override
  String get aideFaq1R =>
      'Oui. Dans ton fil du temps (onglet « Moi »), fais glisser une entrée vers la gauche pour voir le bouton de suppression. Cette action est irréversible.';

  @override
  String get aideFaq2Q => 'Mes données sont-elles privées ?';

  @override
  String get aideFaq2R =>
      'Tes entrées avec un lieu peuvent apparaître sur la carte communautaire. Sans lieu, elles restent invisibles des autres. Tu peux aussi filtrer l\'affichage depuis la carte.';

  @override
  String get aideFaq3Q => 'Puis-je utiliser l\'app sans compte ?';

  @override
  String get aideFaq3R =>
      'Tu peux explorer la carte communautaire sans compte. Pour allumer des lucioles et retrouver tes souvenirs, il te faudra créer un compte gratuit.';

  @override
  String get aideFaq4Q => 'Comment fonctionne la modération ?';

  @override
  String get aideFaq4R =>
      'Lucioles repose sur la bienveillance. Tout contenu signalé est examiné par notre équipe. Les contenus inappropriés sont masqués pour préserver un espace positif et respectueux.';

  @override
  String get onboardingPasser => 'Passer';

  @override
  String get onboardingSuivant => 'Continuer';

  @override
  String get onboardingCommencer => 'Allumer ma première luciole ✦';

  @override
  String get onboarding1Titre => 'Bienvenue dans les Lucioles';

  @override
  String get onboarding1Corps =>
      'Chaque jour, une petite lumière. Note un moment positif que tu as vécu dans ton quartier — aussi discret soit-il.';

  @override
  String get onboarding2Titre => 'Ton atlas de bons souvenirs';

  @override
  String get onboarding2Corps =>
      'Localise tes observations et construis ta propre carte. Un atlas intime des endroits qui t\'ont touché.';

  @override
  String get onboarding3Titre => 'Un espace doux et sécurisé';

  @override
  String get onboarding3Corps =>
      'Lucioles repose sur la bienveillance. Chaque contenu est modéré pour que cet espace reste positif et respectueux pour tous.';

  @override
  String get signalementSignaler => 'Signaler';

  @override
  String get signalementTitre => 'Signaler cette luciole';

  @override
  String get signalementChoixRaison =>
      'Pourquoi veux-tu signaler cette luciole ?';

  @override
  String get signalementRaisonInapproprie => 'Contenu inapproprié';

  @override
  String get signalementRaisonOffensant => 'Contenu offensant';

  @override
  String get signalementRaisonSpam => 'Spam';

  @override
  String get signalementRaisonAutre => 'Autre';

  @override
  String get signalementDetails => 'Détails (optionnel)';

  @override
  String get signalementDetailsHint => 'Précisions éventuelles…';

  @override
  String get signalementEnvoyer => 'Envoyer le signalement';

  @override
  String get signalementConfirmation => 'Signalement envoyé.';

  @override
  String get signalementDejaFait => 'Tu as déjà signalé cette luciole.';

  @override
  String get signalementErreur => 'Une erreur est survenue.';
}
