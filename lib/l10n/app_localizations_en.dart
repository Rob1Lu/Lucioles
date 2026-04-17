// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lucioles';

  @override
  String get navSaisie => 'Write';

  @override
  String get navCarte => 'Map';

  @override
  String get navMoi => 'Me';

  @override
  String get saisieAppBarTitle => 'Lucioles';

  @override
  String get saisieBadgeDuJour => 'Today\'s firefly';

  @override
  String get saisieDejaFaite => 'Come back tomorrow to light\na new firefly.';

  @override
  String get saisieQuestion => 'Today,\nin your neighbourhood…';

  @override
  String get saisieSubtitle => 'Note one positive thing you noticed.';

  @override
  String get saisieHint =>
      'A ray of sun between buildings, an unexpected conversation, flowers on a balcony…';

  @override
  String get saisieLieuLabel => 'Location (optional)';

  @override
  String get saisiePhotoLabel => 'Photo (optional)';

  @override
  String get saisieButtonAllumer => 'Light a firefly ✦';

  @override
  String get saisieConfirmation => 'Your firefly is lit.';

  @override
  String get saisieValidator => 'Write a few words…';

  @override
  String get saisieAjouterPhoto => 'Add a photo';

  @override
  String get lieuUtiliserPosition => 'Use my location';

  @override
  String get lieuLocalisation => 'Locating…';

  @override
  String get lieuPersonnaliserNom => 'Customise the place name… (optional)';

  @override
  String get lieuNomHint => 'Give this place a name… (optional)';

  @override
  String get lieuGeolocDesactive => 'Location services are disabled.';

  @override
  String get lieuPermissionRefusee => 'Location permission denied.';

  @override
  String get lieuPermissionDefinitive =>
      'Permission permanently denied. Check your settings.';

  @override
  String get lieuErreur => 'Unable to get your location.';

  @override
  String get carteMonAtlas => 'My atlas';

  @override
  String carteLucioles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fireflies',
      one: '1 firefly',
    );
    return '$_temp0';
  }

  @override
  String get carteFiltres => 'Filters';

  @override
  String get carteFiltresPeriode => 'Period';

  @override
  String get carteFiltresReinitialiser => 'Reset';

  @override
  String get carteFiltresUniquement => 'Only my fireflies';

  @override
  String get carteFiltresCommunaute => 'Hides community fireflies';

  @override
  String get carteFiltresChoisirDates => 'Choose dates…';

  @override
  String get carteDatePickerTitre => 'Choose a period';

  @override
  String get carteDatePickerAnnuler => 'Cancel';

  @override
  String get carteDatePickerConfirmer => 'Confirm';

  @override
  String get carteAtlasVide => 'Your atlas is still empty.';

  @override
  String get carteAtlasVideSub =>
      'Add a location to your next entry to\nsee your first firefly light up here.';

  @override
  String get carteAucunePeriode => 'No fireflies in this period.';

  @override
  String get carteAucunePeriodeSub =>
      'Try another period or\nreset the filters.';

  @override
  String get carteReinitialiserFiltres => 'Reset filters';

  @override
  String get filterToday => 'Today';

  @override
  String get filterWeek => 'This week';

  @override
  String get filterMonth => 'This month';

  @override
  String get filterYear => 'This year';

  @override
  String get filterCustom => 'Custom';

  @override
  String get filterTodayShort => 'Today';

  @override
  String get filterWeekShort => 'Week';

  @override
  String get filterMonthShort => 'Month';

  @override
  String get filterYearShort => 'Year';

  @override
  String get filterCustomShort => 'Custom';

  @override
  String get saisonToutes => 'All';

  @override
  String get saisonPrintemps => 'Spring';

  @override
  String get saisonEte => 'Summer';

  @override
  String get saisonAutomne => 'Autumn';

  @override
  String get saisonHiver => 'Winter';

  @override
  String get profilTitle => 'Profile';

  @override
  String get profilStatsSection => 'My fireflies';

  @override
  String profilLucioles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fireflies lit',
      one: '1 firefly lit',
      zero: 'No fireflies lit',
    );
    return '$_temp0';
  }

  @override
  String profilDepuis(String date) {
    return 'Since $date';
  }

  @override
  String get profilLangueSection => 'Language';

  @override
  String get profilFilSection => 'Timeline';

  @override
  String get filVide => 'Your atlas is still empty.';

  @override
  String get filVideSub => 'Start by noting what touched you today.';

  @override
  String filVideFiltre(String saison) {
    return 'No fireflies\nthis $saison.';
  }

  @override
  String get filVideFiltreSub => 'Change season to explore other memories.';

  @override
  String get filSupprimerLabel => 'Delete';

  @override
  String get filSupprimerTitre => 'Delete this firefly?';

  @override
  String get filSupprimerContenu =>
      'This action is irreversible. Your memory will be permanently erased.';

  @override
  String get filSupprimerAnnuler => 'Cancel';

  @override
  String get filSupprimerConfirmer => 'Delete';

  @override
  String get authBienvenue => 'Welcome to Lucioles';

  @override
  String get authSousTitre =>
      'Note what touched you today.\nYour memories always stay yours.';

  @override
  String get authEmail => 'Email address';

  @override
  String get authMotDePasse => 'Password';

  @override
  String get authSeConnecter => 'Sign in';

  @override
  String get authSInscrire => 'Create an account';

  @override
  String get authOu => 'or';

  @override
  String get authContinuerGoogle => 'Continue with Google';

  @override
  String get authContinuerApple => 'Continue with Apple';

  @override
  String get authPasDeCompte => 'No account yet?';

  @override
  String get authDejaUnCompte => 'Already have an account?';

  @override
  String get authLienCreerCompte => 'Create an account';

  @override
  String get authLienSeConnecter => 'Sign in';

  @override
  String get authSeDeconnecter => 'Sign out';

  @override
  String get authErreurEmailVide => 'Please enter your email address.';

  @override
  String get authErreurEmailInvalide => 'Invalid email address.';

  @override
  String get authErreurMotDePasseCourt => 'At least 6 characters.';

  @override
  String get authErreurGenerique => 'Something went wrong. Please try again.';

  @override
  String get authGateTitre => 'Join Lucioles';

  @override
  String get authGateSousTitre =>
      'Create an account to record what touched you today.\nYour memories always stay yours.';

  @override
  String get authGateBouton => 'Sign in or create an account';

  @override
  String get profilCompteSection => 'Account';

  @override
  String get profilConnecteEmail => 'Signed in as';

  @override
  String get profilNonConnecteTitre => 'You are not signed in';

  @override
  String get profilNonConnecteSousTitre =>
      'Sign in to light fireflies and find all your memories.';

  @override
  String get profilNonConnecteBouton => 'Sign in';

  @override
  String get profilPseudo => 'Username';

  @override
  String get profilAjouterPseudo => 'Add a username';

  @override
  String get profilModifierPseudo => 'Edit username';

  @override
  String get profilSauvegarder => 'Save';

  @override
  String get profilPhotoAvatar => 'Profile photo';

  @override
  String get profilZoneSensible => 'Danger zone';

  @override
  String get profilSupprimerCompte => 'Delete my account';

  @override
  String get profilSupprimerTitre => 'Delete your account?';

  @override
  String get profilSupprimerMessage =>
      'Your account will be permanently deleted. Your fireflies will be kept anonymously but will no longer be accessible. This action is irreversible.';

  @override
  String get profilSupprimerConfirmer => 'Delete permanently';

  @override
  String get authAppleBientot => 'Apple sign-in coming soon';

  @override
  String get saisieAjouterPhotoAposteriori => 'Add a photo';

  @override
  String get saisieAjoutPhotoConfirmation =>
      'Photo added to today\'s firefly ✦';

  @override
  String get profilLierGoogle => 'Link a Google account';

  @override
  String get profilLierGoogleConfirmation =>
      'Google account linked successfully';

  @override
  String get profilCompteLie => 'Linked account';

  @override
  String get profilLierApple => 'Link an Apple account';

  @override
  String get profilAppleBientot => 'Apple linking coming soon';

  @override
  String get profilConnexion => 'Sign-in';

  @override
  String get profilParametresCompte => 'Account settings';

  @override
  String get adminAccesBouton => 'Admin portal';

  @override
  String get adminPortalTitle => 'Admin portal';

  @override
  String get adminPortalStats => 'Statistics';

  @override
  String get adminPortalGestion => 'Management';

  @override
  String get adminPortalUtilisateurs => 'User management';

  @override
  String get adminPortalSignalements => 'Report management';

  @override
  String get adminPortalBientot => 'Soon';

  @override
  String get adminUsersTitle => 'Users';

  @override
  String get adminUsersRecherche => 'Search for a user…';

  @override
  String get adminUsersVide => 'No users found.';

  @override
  String get adminUsersSupprimerTitre => 'Delete user?';

  @override
  String adminUsersSupprimerMessage(String nom) {
    return 'The account of $nom will be permanently deleted. This action is irreversible.';
  }

  @override
  String get adminUserDetailTitle => 'User profile';

  @override
  String get adminLucioleRestrictTitre => 'Restrict this firefly?';

  @override
  String get adminLucioleRestrictMsg =>
      'It will be hidden from the community. This action is reversible.';

  @override
  String get adminLucioleApprouverTitre => 'Approve this firefly?';

  @override
  String get adminLucioleApprouverMsg =>
      'It will be visible to the community again.';

  @override
  String get adminSignalementsUserSupprimeLabel => 'Deleted account';

  @override
  String get adminSignalementsTitle => 'Reports';

  @override
  String get adminSignalementsVide => 'No pending reports.';

  @override
  String get adminSignalementsApprouver => 'Approve';

  @override
  String get adminSignalementsRestreindre => 'Restrict';

  @override
  String get adminSignalementsTagRestreinte => 'Restricted';

  @override
  String get adminSignalementsTagRecidiviste => 'Repeat offender';

  @override
  String get adminSignalementsVoirProfil => 'View profile';

  @override
  String adminSignalementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports',
      one: '1 report',
    );
    return '$_temp0';
  }

  @override
  String adminSignalementsLuciolesSig(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reported fireflies',
      one: '1 reported firefly',
    );
    return '$_temp0';
  }

  @override
  String get signalementSignaler => 'Report';

  @override
  String get signalementTitre => 'Report this firefly';

  @override
  String get signalementChoixRaison =>
      'Why do you want to report this firefly?';

  @override
  String get signalementRaisonInapproprie => 'Inappropriate content';

  @override
  String get signalementRaisonOffensant => 'Offensive content';

  @override
  String get signalementRaisonSpam => 'Spam';

  @override
  String get signalementRaisonAutre => 'Other';

  @override
  String get signalementDetails => 'Details (optional)';

  @override
  String get signalementDetailsHint => 'Additional details…';

  @override
  String get signalementEnvoyer => 'Send report';

  @override
  String get signalementConfirmation => 'Report sent.';

  @override
  String get signalementDejaFait => 'You have already reported this firefly.';

  @override
  String get signalementErreur => 'An error occurred.';
}
