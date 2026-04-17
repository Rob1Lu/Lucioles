import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Lucioles'**
  String get appName;

  /// No description provided for @navSaisie.
  ///
  /// In fr, this message translates to:
  /// **'Saisie'**
  String get navSaisie;

  /// No description provided for @navCarte.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get navCarte;

  /// No description provided for @navMoi.
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get navMoi;

  /// No description provided for @saisieAppBarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lucioles'**
  String get saisieAppBarTitle;

  /// No description provided for @saisieBadgeDuJour.
  ///
  /// In fr, this message translates to:
  /// **'Ta luciole du jour'**
  String get saisieBadgeDuJour;

  /// No description provided for @saisieDejaFaite.
  ///
  /// In fr, this message translates to:
  /// **'Reviens demain pour allumer\nune nouvelle luciole.'**
  String get saisieDejaFaite;

  /// No description provided for @saisieQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui,\ndans ton quartier…'**
  String get saisieQuestion;

  /// No description provided for @saisieSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Note une chose positive que tu as remarquée.'**
  String get saisieSubtitle;

  /// No description provided for @saisieHint.
  ///
  /// In fr, this message translates to:
  /// **'Un rayon de soleil entre les immeubles, une conversation inattendue, des fleurs sur un balcon…'**
  String get saisieHint;

  /// No description provided for @saisieLieuLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu (optionnel)'**
  String get saisieLieuLabel;

  /// No description provided for @saisiePhotoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Photo (optionnel)'**
  String get saisiePhotoLabel;

  /// No description provided for @saisieButtonAllumer.
  ///
  /// In fr, this message translates to:
  /// **'Allumer une luciole ✦'**
  String get saisieButtonAllumer;

  /// No description provided for @saisieConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Ta luciole est allumée.'**
  String get saisieConfirmation;

  /// No description provided for @saisieValidator.
  ///
  /// In fr, this message translates to:
  /// **'Écris quelques mots…'**
  String get saisieValidator;

  /// No description provided for @saisieAjouterPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo'**
  String get saisieAjouterPhoto;

  /// No description provided for @lieuUtiliserPosition.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser ma position'**
  String get lieuUtiliserPosition;

  /// No description provided for @lieuLocalisation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation en cours…'**
  String get lieuLocalisation;

  /// No description provided for @lieuPersonnaliserNom.
  ///
  /// In fr, this message translates to:
  /// **'Personnaliser le nom du lieu… (optionnel)'**
  String get lieuPersonnaliserNom;

  /// No description provided for @lieuNomHint.
  ///
  /// In fr, this message translates to:
  /// **'Donner un nom à cet endroit… (optionnel)'**
  String get lieuNomHint;

  /// No description provided for @lieuGeolocDesactive.
  ///
  /// In fr, this message translates to:
  /// **'La géolocalisation est désactivée.'**
  String get lieuGeolocDesactive;

  /// No description provided for @lieuPermissionRefusee.
  ///
  /// In fr, this message translates to:
  /// **'Permission de localisation refusée.'**
  String get lieuPermissionRefusee;

  /// No description provided for @lieuPermissionDefinitive.
  ///
  /// In fr, this message translates to:
  /// **'Permission refusée définitivement. Vérifie les réglages.'**
  String get lieuPermissionDefinitive;

  /// No description provided for @lieuErreur.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'obtenir la position.'**
  String get lieuErreur;

  /// No description provided for @carteMonAtlas.
  ///
  /// In fr, this message translates to:
  /// **'Mon atlas'**
  String get carteMonAtlas;

  /// No description provided for @carteLucioles.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 luciole} other{{count} lucioles}}'**
  String carteLucioles(int count);

  /// No description provided for @carteFiltres.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get carteFiltres;

  /// No description provided for @carteFiltresPeriode.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get carteFiltresPeriode;

  /// No description provided for @carteFiltresReinitialiser.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get carteFiltresReinitialiser;

  /// No description provided for @carteFiltresUniquement.
  ///
  /// In fr, this message translates to:
  /// **'Uniquement mes lucioles'**
  String get carteFiltresUniquement;

  /// No description provided for @carteFiltresCommunaute.
  ///
  /// In fr, this message translates to:
  /// **'Masque les lucioles de la communauté'**
  String get carteFiltresCommunaute;

  /// No description provided for @carteFiltresChoisirDates.
  ///
  /// In fr, this message translates to:
  /// **'Choisir les dates…'**
  String get carteFiltresChoisirDates;

  /// No description provided for @carteDatePickerTitre.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une période'**
  String get carteDatePickerTitre;

  /// No description provided for @carteDatePickerAnnuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get carteDatePickerAnnuler;

  /// No description provided for @carteDatePickerConfirmer.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get carteDatePickerConfirmer;

  /// No description provided for @carteAtlasVide.
  ///
  /// In fr, this message translates to:
  /// **'Ton atlas est encore vide.'**
  String get carteAtlasVide;

  /// No description provided for @carteAtlasVideSub.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute un lieu à ta prochaine entrée pour\nvoir ta première luciole s\'allumer ici.'**
  String get carteAtlasVideSub;

  /// No description provided for @carteAucunePeriode.
  ///
  /// In fr, this message translates to:
  /// **'Aucune luciole sur cette période.'**
  String get carteAucunePeriode;

  /// No description provided for @carteAucunePeriodeSub.
  ///
  /// In fr, this message translates to:
  /// **'Essaie une autre période ou\nréinitialise les filtres.'**
  String get carteAucunePeriodeSub;

  /// No description provided for @carteReinitialiserFiltres.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get carteReinitialiserFiltres;

  /// No description provided for @filterToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get filterToday;

  /// No description provided for @filterWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get filterWeek;

  /// No description provided for @filterMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci'**
  String get filterMonth;

  /// No description provided for @filterYear.
  ///
  /// In fr, this message translates to:
  /// **'Cette année'**
  String get filterYear;

  /// No description provided for @filterCustom.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get filterCustom;

  /// No description provided for @filterTodayShort.
  ///
  /// In fr, this message translates to:
  /// **'Auj.'**
  String get filterTodayShort;

  /// No description provided for @filterWeekShort.
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get filterWeekShort;

  /// No description provided for @filterMonthShort.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get filterMonthShort;

  /// No description provided for @filterYearShort.
  ///
  /// In fr, this message translates to:
  /// **'Cette année'**
  String get filterYearShort;

  /// No description provided for @filterCustomShort.
  ///
  /// In fr, this message translates to:
  /// **'Perso.'**
  String get filterCustomShort;

  /// No description provided for @saisonToutes.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get saisonToutes;

  /// No description provided for @saisonPrintemps.
  ///
  /// In fr, this message translates to:
  /// **'Printemps'**
  String get saisonPrintemps;

  /// No description provided for @saisonEte.
  ///
  /// In fr, this message translates to:
  /// **'Été'**
  String get saisonEte;

  /// No description provided for @saisonAutomne.
  ///
  /// In fr, this message translates to:
  /// **'Automne'**
  String get saisonAutomne;

  /// No description provided for @saisonHiver.
  ///
  /// In fr, this message translates to:
  /// **'Hiver'**
  String get saisonHiver;

  /// No description provided for @profilTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profilTitle;

  /// No description provided for @profilStatsSection.
  ///
  /// In fr, this message translates to:
  /// **'Mes lucioles'**
  String get profilStatsSection;

  /// No description provided for @profilLucioles.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune luciole allumée} =1{1 luciole allumée} other{{count} lucioles allumées}}'**
  String profilLucioles(int count);

  /// No description provided for @profilDepuis.
  ///
  /// In fr, this message translates to:
  /// **'Depuis le {date}'**
  String profilDepuis(String date);

  /// No description provided for @profilLangueSection.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get profilLangueSection;

  /// No description provided for @profilFilSection.
  ///
  /// In fr, this message translates to:
  /// **'Fil du temps'**
  String get profilFilSection;

  /// No description provided for @filVide.
  ///
  /// In fr, this message translates to:
  /// **'Ton atlas est encore vide.'**
  String get filVide;

  /// No description provided for @filVideSub.
  ///
  /// In fr, this message translates to:
  /// **'Commence par noter ce qui t\'a touché aujourd\'hui.'**
  String get filVideSub;

  /// No description provided for @filVideFiltre.
  ///
  /// In fr, this message translates to:
  /// **'Aucune luciole\ncet {saison}.'**
  String filVideFiltre(String saison);

  /// No description provided for @filVideFiltreSub.
  ///
  /// In fr, this message translates to:
  /// **'Change de saison pour explorer d\'autres souvenirs.'**
  String get filVideFiltreSub;

  /// No description provided for @filSupprimerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get filSupprimerLabel;

  /// No description provided for @filSupprimerTitre.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette luciole ?'**
  String get filSupprimerTitre;

  /// No description provided for @filSupprimerContenu.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Ton souvenir sera définitivement effacé.'**
  String get filSupprimerContenu;

  /// No description provided for @filSupprimerAnnuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get filSupprimerAnnuler;

  /// No description provided for @filSupprimerConfirmer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get filSupprimerConfirmer;

  /// No description provided for @authBienvenue.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans les Lucioles'**
  String get authBienvenue;

  /// No description provided for @authSousTitre.
  ///
  /// In fr, this message translates to:
  /// **'Note ce qui t\'a touché aujourd\'hui.\nTes souvenirs restent toujours les tiens.'**
  String get authSousTitre;

  /// No description provided for @authEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get authEmail;

  /// No description provided for @authMotDePasse.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authMotDePasse;

  /// No description provided for @authSeConnecter.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSeConnecter;

  /// No description provided for @authSInscrire.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSInscrire;

  /// No description provided for @authOu.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get authOu;

  /// No description provided for @authContinuerGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get authContinuerGoogle;

  /// No description provided for @authContinuerApple.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get authContinuerApple;

  /// No description provided for @authPasDeCompte.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authPasDeCompte;

  /// No description provided for @authDejaUnCompte.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authDejaUnCompte;

  /// No description provided for @authLienCreerCompte.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authLienCreerCompte;

  /// No description provided for @authLienSeConnecter.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLienSeConnecter;

  /// No description provided for @authSeDeconnecter.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authSeDeconnecter;

  /// No description provided for @authErreurEmailVide.
  ///
  /// In fr, this message translates to:
  /// **'Saisis ton adresse e-mail.'**
  String get authErreurEmailVide;

  /// No description provided for @authErreurEmailInvalide.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get authErreurEmailInvalide;

  /// No description provided for @authErreurMotDePasseCourt.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 6 caractères.'**
  String get authErreurMotDePasseCourt;

  /// No description provided for @authErreurGenerique.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessaie.'**
  String get authErreurGenerique;

  /// No description provided for @authGateTitre.
  ///
  /// In fr, this message translates to:
  /// **'Rejoins les Lucioles'**
  String get authGateTitre;

  /// No description provided for @authGateSousTitre.
  ///
  /// In fr, this message translates to:
  /// **'Crée un compte pour noter ce qui t\'a touché aujourd\'hui.\nTes souvenirs restent toujours les tiens.'**
  String get authGateSousTitre;

  /// No description provided for @authGateBouton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter ou créer un compte'**
  String get authGateBouton;

  /// No description provided for @profilCompteSection.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get profilCompteSection;

  /// No description provided for @profilConnecteEmail.
  ///
  /// In fr, this message translates to:
  /// **'Connecté en tant que'**
  String get profilConnecteEmail;

  /// No description provided for @profilNonConnecteTitre.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'es pas connecté'**
  String get profilNonConnecteTitre;

  /// No description provided for @profilNonConnecteSousTitre.
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour allumer des lucioles et retrouver tous tes souvenirs.'**
  String get profilNonConnecteSousTitre;

  /// No description provided for @profilNonConnecteBouton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get profilNonConnecteBouton;

  /// No description provided for @profilPseudo.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get profilPseudo;

  /// No description provided for @profilAjouterPseudo.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un pseudo'**
  String get profilAjouterPseudo;

  /// No description provided for @profilModifierPseudo.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le pseudo'**
  String get profilModifierPseudo;

  /// No description provided for @profilSauvegarder.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get profilSauvegarder;

  /// No description provided for @profilPhotoAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil'**
  String get profilPhotoAvatar;

  /// No description provided for @profilZoneSensible.
  ///
  /// In fr, this message translates to:
  /// **'Zone sensible'**
  String get profilZoneSensible;

  /// No description provided for @profilSupprimerCompte.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get profilSupprimerCompte;

  /// No description provided for @profilSupprimerTitre.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte ?'**
  String get profilSupprimerTitre;

  /// No description provided for @profilSupprimerMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ton compte sera supprimé définitivement. Tes lucioles seront conservées de façon anonyme mais ne seront plus accessibles. Cette action est irréversible.'**
  String get profilSupprimerMessage;

  /// No description provided for @profilSupprimerConfirmer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer définitivement'**
  String get profilSupprimerConfirmer;

  /// No description provided for @authAppleBientot.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Apple bientôt disponible'**
  String get authAppleBientot;

  /// No description provided for @saisieAjouterPhotoAposteriori.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo'**
  String get saisieAjouterPhotoAposteriori;

  /// No description provided for @saisieAjoutPhotoConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Photo ajoutée à ta luciole du jour ✦'**
  String get saisieAjoutPhotoConfirmation;

  /// No description provided for @profilLierGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Lier un compte Google'**
  String get profilLierGoogle;

  /// No description provided for @profilLierGoogleConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Compte Google lié avec succès'**
  String get profilLierGoogleConfirmation;

  /// No description provided for @profilCompteLie.
  ///
  /// In fr, this message translates to:
  /// **'Compte lié'**
  String get profilCompteLie;

  /// No description provided for @profilLierApple.
  ///
  /// In fr, this message translates to:
  /// **'Lier un compte Apple'**
  String get profilLierApple;

  /// No description provided for @profilAppleBientot.
  ///
  /// In fr, this message translates to:
  /// **'Liaison Apple bientôt disponible'**
  String get profilAppleBientot;

  /// No description provided for @profilConnexion.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get profilConnexion;

  /// No description provided for @profilParametresCompte.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres du compte'**
  String get profilParametresCompte;

  /// No description provided for @adminAccesBouton.
  ///
  /// In fr, this message translates to:
  /// **'Portail admin'**
  String get adminAccesBouton;

  /// No description provided for @adminPortalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Portail admin'**
  String get adminPortalTitle;

  /// No description provided for @adminPortalStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get adminPortalStats;

  /// No description provided for @adminPortalGestion.
  ///
  /// In fr, this message translates to:
  /// **'Gestion'**
  String get adminPortalGestion;

  /// No description provided for @adminPortalUtilisateurs.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des utilisateurs'**
  String get adminPortalUtilisateurs;

  /// No description provided for @adminPortalSignalements.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des signalements'**
  String get adminPortalSignalements;

  /// No description provided for @adminPortalBientot.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get adminPortalBientot;

  /// No description provided for @adminUsersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get adminUsersTitle;

  /// No description provided for @adminUsersRecherche.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un utilisateur…'**
  String get adminUsersRecherche;

  /// No description provided for @adminUsersVide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur trouvé.'**
  String get adminUsersVide;

  /// No description provided for @adminUsersSupprimerTitre.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'utilisateur ?'**
  String get adminUsersSupprimerTitre;

  /// No description provided for @adminUsersSupprimerMessage.
  ///
  /// In fr, this message translates to:
  /// **'Le compte de {nom} sera supprimé définitivement. Cette action est irréversible.'**
  String adminUsersSupprimerMessage(String nom);

  /// No description provided for @adminUserDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil utilisateur'**
  String get adminUserDetailTitle;

  /// No description provided for @feedbackBouton.
  ///
  /// In fr, this message translates to:
  /// **'Donner ton avis'**
  String get feedbackBouton;

  /// No description provided for @feedbackTitre.
  ///
  /// In fr, this message translates to:
  /// **'Partage ton avis'**
  String get feedbackTitre;

  /// No description provided for @feedbackTypeBug.
  ///
  /// In fr, this message translates to:
  /// **'Bug'**
  String get feedbackTypeBug;

  /// No description provided for @feedbackTypeSuggestion.
  ///
  /// In fr, this message translates to:
  /// **'Suggestion'**
  String get feedbackTypeSuggestion;

  /// No description provided for @feedbackTypeAutre.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get feedbackTypeAutre;

  /// No description provided for @feedbackMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ton message'**
  String get feedbackMessage;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Décris le problème ou ta suggestion…'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackEnvoyer.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get feedbackEnvoyer;

  /// No description provided for @feedbackConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour ton retour !'**
  String get feedbackConfirmation;

  /// No description provided for @feedbackErreur.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get feedbackErreur;

  /// No description provided for @feedbackMessageVide.
  ///
  /// In fr, this message translates to:
  /// **'Écris un message.'**
  String get feedbackMessageVide;

  /// No description provided for @adminLucioleRestrictTitre.
  ///
  /// In fr, this message translates to:
  /// **'Restreindre cette luciole ?'**
  String get adminLucioleRestrictTitre;

  /// No description provided for @adminLucioleRestrictMsg.
  ///
  /// In fr, this message translates to:
  /// **'Elle sera masquée de la communauté. Cette action est réversible.'**
  String get adminLucioleRestrictMsg;

  /// No description provided for @adminLucioleApprouverTitre.
  ///
  /// In fr, this message translates to:
  /// **'Approuver cette luciole ?'**
  String get adminLucioleApprouverTitre;

  /// No description provided for @adminLucioleApprouverMsg.
  ///
  /// In fr, this message translates to:
  /// **'Elle sera de nouveau visible dans la communauté.'**
  String get adminLucioleApprouverMsg;

  /// No description provided for @adminSignalementsUserSupprimeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Compte supprimé'**
  String get adminSignalementsUserSupprimeLabel;

  /// No description provided for @adminSignalementsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signalements'**
  String get adminSignalementsTitle;

  /// No description provided for @adminSignalementsVide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement en attente.'**
  String get adminSignalementsVide;

  /// No description provided for @adminSignalementsApprouver.
  ///
  /// In fr, this message translates to:
  /// **'Approuver'**
  String get adminSignalementsApprouver;

  /// No description provided for @adminSignalementsRestreindre.
  ///
  /// In fr, this message translates to:
  /// **'Restreindre'**
  String get adminSignalementsRestreindre;

  /// No description provided for @adminSignalementsTagRestreinte.
  ///
  /// In fr, this message translates to:
  /// **'Restreinte'**
  String get adminSignalementsTagRestreinte;

  /// No description provided for @adminSignalementsTagRecidiviste.
  ///
  /// In fr, this message translates to:
  /// **'Récidiviste'**
  String get adminSignalementsTagRecidiviste;

  /// No description provided for @adminSignalementsVoirProfil.
  ///
  /// In fr, this message translates to:
  /// **'Voir le profil'**
  String get adminSignalementsVoirProfil;

  /// No description provided for @adminSignalementsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 signalement} other{{count} signalements}}'**
  String adminSignalementsCount(int count);

  /// No description provided for @adminSignalementsLuciolesSig.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 luciole signalée} other{{count} lucioles signalées}}'**
  String adminSignalementsLuciolesSig(int count);

  /// No description provided for @aideAccesBouton.
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get aideAccesBouton;

  /// No description provided for @aideTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get aideTitle;

  /// No description provided for @aideFeedbackTitre.
  ///
  /// In fr, this message translates to:
  /// **'Partage ton avis'**
  String get aideFeedbackTitre;

  /// No description provided for @aideFeedbackSousTitre.
  ///
  /// In fr, this message translates to:
  /// **'Une suggestion, un bug, une idée ? Dis-nous tout.'**
  String get aideFeedbackSousTitre;

  /// No description provided for @aideTutorielsSection.
  ///
  /// In fr, this message translates to:
  /// **'Tutoriels'**
  String get aideTutorielsSection;

  /// No description provided for @aideFAQSection.
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes'**
  String get aideFAQSection;

  /// No description provided for @aideTuto1Q.
  ///
  /// In fr, this message translates to:
  /// **'Comment allumer une luciole ?'**
  String get aideTuto1Q;

  /// No description provided for @aideTuto1R.
  ///
  /// In fr, this message translates to:
  /// **'Va dans l\'onglet « Saisie », note une chose positive que tu as observée dans ton quartier, puis appuie sur « Allumer une luciole ». Tu peux y ajouter un lieu et une photo.'**
  String get aideTuto1R;

  /// No description provided for @aideTuto2Q.
  ///
  /// In fr, this message translates to:
  /// **'Comment ajouter un lieu à une entrée ?'**
  String get aideTuto2Q;

  /// No description provided for @aideTuto2R.
  ///
  /// In fr, this message translates to:
  /// **'Dans le formulaire de saisie, appuie sur le champ « Lieu ». Tu peux utiliser ta position GPS ou saisir un nom manuellement.'**
  String get aideTuto2R;

  /// No description provided for @aideTuto3Q.
  ///
  /// In fr, this message translates to:
  /// **'Comment retrouver mes lucioles ?'**
  String get aideTuto3Q;

  /// No description provided for @aideTuto3R.
  ///
  /// In fr, this message translates to:
  /// **'Tes lucioles sont visibles dans l\'onglet « Carte » (sur la carte) et dans l\'onglet « Moi » (fil du temps). Seules les lucioles avec un lieu apparaissent sur la carte.'**
  String get aideTuto3R;

  /// No description provided for @aideTuto4Q.
  ///
  /// In fr, this message translates to:
  /// **'Comment filtrer par saison ?'**
  String get aideTuto4Q;

  /// No description provided for @aideTuto4R.
  ///
  /// In fr, this message translates to:
  /// **'Dans l\'onglet « Moi », utilise les filtres de saison (Printemps, Été, Automne, Hiver) juste au-dessus de ton fil du temps.'**
  String get aideTuto4R;

  /// No description provided for @aideFaq1Q.
  ///
  /// In fr, this message translates to:
  /// **'Puis-je supprimer une luciole ?'**
  String get aideFaq1Q;

  /// No description provided for @aideFaq1R.
  ///
  /// In fr, this message translates to:
  /// **'Oui. Dans ton fil du temps (onglet « Moi »), fais glisser une entrée vers la gauche pour voir le bouton de suppression. Cette action est irréversible.'**
  String get aideFaq1R;

  /// No description provided for @aideFaq2Q.
  ///
  /// In fr, this message translates to:
  /// **'Mes données sont-elles privées ?'**
  String get aideFaq2Q;

  /// No description provided for @aideFaq2R.
  ///
  /// In fr, this message translates to:
  /// **'Tes entrées avec un lieu peuvent apparaître sur la carte communautaire. Sans lieu, elles restent invisibles des autres. Tu peux aussi filtrer l\'affichage depuis la carte.'**
  String get aideFaq2R;

  /// No description provided for @aideFaq3Q.
  ///
  /// In fr, this message translates to:
  /// **'Puis-je utiliser l\'app sans compte ?'**
  String get aideFaq3Q;

  /// No description provided for @aideFaq3R.
  ///
  /// In fr, this message translates to:
  /// **'Tu peux explorer la carte communautaire sans compte. Pour allumer des lucioles et retrouver tes souvenirs, il te faudra créer un compte gratuit.'**
  String get aideFaq3R;

  /// No description provided for @aideFaq4Q.
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionne la modération ?'**
  String get aideFaq4Q;

  /// No description provided for @aideFaq4R.
  ///
  /// In fr, this message translates to:
  /// **'Lucioles repose sur la bienveillance. Tout contenu signalé est examiné par notre équipe. Les contenus inappropriés sont masqués pour préserver un espace positif et respectueux.'**
  String get aideFaq4R;

  /// No description provided for @onboardingPasser.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingPasser;

  /// No description provided for @onboardingSuivant.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get onboardingSuivant;

  /// No description provided for @onboardingCommencer.
  ///
  /// In fr, this message translates to:
  /// **'Allumer ma première luciole ✦'**
  String get onboardingCommencer;

  /// No description provided for @onboarding1Titre.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans les Lucioles'**
  String get onboarding1Titre;

  /// No description provided for @onboarding1Corps.
  ///
  /// In fr, this message translates to:
  /// **'Chaque jour, une petite lumière. Note un moment positif que tu as vécu dans ton quartier — aussi discret soit-il.'**
  String get onboarding1Corps;

  /// No description provided for @onboarding2Titre.
  ///
  /// In fr, this message translates to:
  /// **'Ton atlas de bons souvenirs'**
  String get onboarding2Titre;

  /// No description provided for @onboarding2Corps.
  ///
  /// In fr, this message translates to:
  /// **'Localise tes observations et construis ta propre carte. Un atlas intime des endroits qui t\'ont touché.'**
  String get onboarding2Corps;

  /// No description provided for @onboarding3Titre.
  ///
  /// In fr, this message translates to:
  /// **'Un espace doux et sécurisé'**
  String get onboarding3Titre;

  /// No description provided for @onboarding3Corps.
  ///
  /// In fr, this message translates to:
  /// **'Lucioles repose sur la bienveillance. Chaque contenu est modéré pour que cet espace reste positif et respectueux pour tous.'**
  String get onboarding3Corps;

  /// No description provided for @adminPortalFeedbacks.
  ///
  /// In fr, this message translates to:
  /// **'Feedbacks utilisateurs'**
  String get adminPortalFeedbacks;

  /// No description provided for @adminFeedbacksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Feedbacks'**
  String get adminFeedbacksTitle;

  /// No description provided for @adminFeedbacksVide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun feedback pour l\'instant.'**
  String get adminFeedbacksVide;

  /// No description provided for @adminArchivesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Archives'**
  String get adminArchivesTitle;

  /// No description provided for @adminArchivesVide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement archivé.'**
  String get adminArchivesVide;

  /// No description provided for @adminArchivesRecherche.
  ///
  /// In fr, this message translates to:
  /// **'Email, pseudo, contenu, date…'**
  String get adminArchivesRecherche;

  /// No description provided for @adminArchivesApprouve.
  ///
  /// In fr, this message translates to:
  /// **'Approuvé'**
  String get adminArchivesApprouve;

  /// No description provided for @adminArchivesRestreint.
  ///
  /// In fr, this message translates to:
  /// **'Restreint'**
  String get adminArchivesRestreint;

  /// No description provided for @adminArchivesDecisionLe.
  ///
  /// In fr, this message translates to:
  /// **'Décidé le {date}'**
  String adminArchivesDecisionLe(String date);

  /// No description provided for @adminArchivesPublieLe.
  ///
  /// In fr, this message translates to:
  /// **'Publié le {date}'**
  String adminArchivesPublieLe(String date);

  /// No description provided for @signalementSignaler.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get signalementSignaler;

  /// No description provided for @signalementTitre.
  ///
  /// In fr, this message translates to:
  /// **'Signaler cette luciole'**
  String get signalementTitre;

  /// No description provided for @signalementChoixRaison.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi veux-tu signaler cette luciole ?'**
  String get signalementChoixRaison;

  /// No description provided for @signalementRaisonInapproprie.
  ///
  /// In fr, this message translates to:
  /// **'Contenu inapproprié'**
  String get signalementRaisonInapproprie;

  /// No description provided for @signalementRaisonOffensant.
  ///
  /// In fr, this message translates to:
  /// **'Contenu offensant'**
  String get signalementRaisonOffensant;

  /// No description provided for @signalementRaisonSpam.
  ///
  /// In fr, this message translates to:
  /// **'Spam'**
  String get signalementRaisonSpam;

  /// No description provided for @signalementRaisonAutre.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get signalementRaisonAutre;

  /// No description provided for @signalementDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails (optionnel)'**
  String get signalementDetails;

  /// No description provided for @signalementDetailsHint.
  ///
  /// In fr, this message translates to:
  /// **'Précisions éventuelles…'**
  String get signalementDetailsHint;

  /// No description provided for @signalementEnvoyer.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le signalement'**
  String get signalementEnvoyer;

  /// No description provided for @signalementConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Signalement envoyé.'**
  String get signalementConfirmation;

  /// No description provided for @signalementDejaFait.
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà signalé cette luciole.'**
  String get signalementDejaFait;

  /// No description provided for @signalementErreur.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get signalementErreur;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
