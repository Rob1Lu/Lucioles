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

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'Lucioles'**
  String get appName;

  /// Nav bas : onglet saisie
  ///
  /// In fr, this message translates to:
  /// **'Saisie'**
  String get navSaisie;

  /// Nav bas : onglet carte
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get navCarte;

  /// Nav bas : onglet profil
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get navMoi;

  /// Titre AppBar écran saisie
  ///
  /// In fr, this message translates to:
  /// **'Lucioles'**
  String get saisieAppBarTitle;

  /// Badge affiché quand l'entrée du jour existe
  ///
  /// In fr, this message translates to:
  /// **'Ta luciole du jour'**
  String get saisieBadgeDuJour;

  /// Message quand l'entrée du jour est déjà créée
  ///
  /// In fr, this message translates to:
  /// **'Reviens demain pour allumer\nune nouvelle luciole.'**
  String get saisieDejaFaite;

  /// En-tête de la question de saisie
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui,\ndans ton quartier…'**
  String get saisieQuestion;

  /// Sous-titre de la question de saisie
  ///
  /// In fr, this message translates to:
  /// **'Note une chose positive que tu as remarquée.'**
  String get saisieSubtitle;

  /// Placeholder du champ texte de saisie
  ///
  /// In fr, this message translates to:
  /// **'Un rayon de soleil entre les immeubles, une conversation inattendue, des fleurs sur un balcon…'**
  String get saisieHint;

  /// Label du champ lieu
  ///
  /// In fr, this message translates to:
  /// **'Lieu (optionnel)'**
  String get saisieLieuLabel;

  /// Label du champ photo
  ///
  /// In fr, this message translates to:
  /// **'Photo (optionnel)'**
  String get saisiePhotoLabel;

  /// Bouton de validation de la saisie
  ///
  /// In fr, this message translates to:
  /// **'Allumer une luciole ✦'**
  String get saisieButtonAllumer;

  /// Snackbar de confirmation après création
  ///
  /// In fr, this message translates to:
  /// **'Ta luciole est allumée.'**
  String get saisieConfirmation;

  /// Erreur de validation champ texte vide
  ///
  /// In fr, this message translates to:
  /// **'Écris quelques mots…'**
  String get saisieValidator;

  /// Bouton ajout photo dans le formulaire
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo'**
  String get saisieAjouterPhoto;

  /// Bouton ajout photo a posteriori sur l'entrée du jour
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo'**
  String get saisieAjouterPhotoAposteriori;

  /// Confirmation après ajout de photo a posteriori
  ///
  /// In fr, this message translates to:
  /// **'Photo ajoutée à ta luciole du jour ✦'**
  String get saisieAjoutPhotoConfirmation;

  /// Bouton géolocalisation automatique
  ///
  /// In fr, this message translates to:
  /// **'Utiliser ma position'**
  String get lieuUtiliserPosition;

  /// État de chargement de la géolocalisation
  ///
  /// In fr, this message translates to:
  /// **'Localisation en cours…'**
  String get lieuLocalisation;

  /// Placeholder champ personnalisation nom de lieu
  ///
  /// In fr, this message translates to:
  /// **'Personnaliser le nom du lieu… (optionnel)'**
  String get lieuPersonnaliserNom;

  /// Hint champ nom personnalisé du lieu
  ///
  /// In fr, this message translates to:
  /// **'Donner un nom à cet endroit… (optionnel)'**
  String get lieuNomHint;

  /// Erreur géolocalisation désactivée
  ///
  /// In fr, this message translates to:
  /// **'La géolocalisation est désactivée.'**
  String get lieuGeolocDesactive;

  /// Erreur permission localisation refusée
  ///
  /// In fr, this message translates to:
  /// **'Permission de localisation refusée.'**
  String get lieuPermissionRefusee;

  /// Erreur permission localisation refusée définitivement
  ///
  /// In fr, this message translates to:
  /// **'Permission refusée définitivement. Vérifie les réglages.'**
  String get lieuPermissionDefinitive;

  /// Erreur générique de géolocalisation
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'obtenir la position.'**
  String get lieuErreur;

  /// Titre section atlas personnel sur la carte
  ///
  /// In fr, this message translates to:
  /// **'Mon atlas'**
  String get carteMonAtlas;

  /// Compteur de lucioles sur la carte
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 luciole} other{{count} lucioles}}'**
  String carteLucioles(int count);

  /// Label bouton filtres carte
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get carteFiltres;

  /// Label section période dans les filtres
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get carteFiltresPeriode;

  /// Bouton réinitialisation des filtres
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get carteFiltresReinitialiser;

  /// Toggle affichage uniquement lucioles personnelles
  ///
  /// In fr, this message translates to:
  /// **'Uniquement mes lucioles'**
  String get carteFiltresUniquement;

  /// Toggle masquage lucioles communautaires
  ///
  /// In fr, this message translates to:
  /// **'Masque les lucioles de la communauté'**
  String get carteFiltresCommunaute;

  /// Bouton ouverture sélecteur de dates
  ///
  /// In fr, this message translates to:
  /// **'Choisir les dates…'**
  String get carteFiltresChoisirDates;

  /// Titre du sélecteur de période
  ///
  /// In fr, this message translates to:
  /// **'Choisir une période'**
  String get carteDatePickerTitre;

  /// Bouton annulation du date picker
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get carteDatePickerAnnuler;

  /// Bouton confirmation du date picker
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get carteDatePickerConfirmer;

  /// Message état vide atlas personnel
  ///
  /// In fr, this message translates to:
  /// **'Ton atlas est encore vide.'**
  String get carteAtlasVide;

  /// Sous-titre état vide atlas personnel
  ///
  /// In fr, this message translates to:
  /// **'Ajoute un lieu à ta prochaine entrée pour\nvoir ta première luciole s\'allumer ici.'**
  String get carteAtlasVideSub;

  /// Message aucun résultat pour la période filtrée
  ///
  /// In fr, this message translates to:
  /// **'Aucune luciole sur cette période.'**
  String get carteAucunePeriode;

  /// Sous-titre aucun résultat pour la période filtrée
  ///
  /// In fr, this message translates to:
  /// **'Essaie une autre période ou\nréinitialise les filtres.'**
  String get carteAucunePeriodeSub;

  /// Bouton réinitialisation filtres depuis l'état vide
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get carteReinitialiserFiltres;

  /// Filtre période : aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get filterToday;

  /// Filtre période : cette semaine
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get filterWeek;

  /// Filtre période : ce mois
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci'**
  String get filterMonth;

  /// Filtre période : cette année
  ///
  /// In fr, this message translates to:
  /// **'Cette année'**
  String get filterYear;

  /// Filtre période : personnalisé
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get filterCustom;

  /// Filtre période court : aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Auj.'**
  String get filterTodayShort;

  /// Filtre période court : semaine
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get filterWeekShort;

  /// Filtre période court : mois
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get filterMonthShort;

  /// Filtre période court : année
  ///
  /// In fr, this message translates to:
  /// **'Cette année'**
  String get filterYearShort;

  /// Filtre période court : personnalisé
  ///
  /// In fr, this message translates to:
  /// **'Perso.'**
  String get filterCustomShort;

  /// Filtre saison : toutes
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get saisonToutes;

  /// Filtre saison : printemps
  ///
  /// In fr, this message translates to:
  /// **'Printemps'**
  String get saisonPrintemps;

  /// Filtre saison : été
  ///
  /// In fr, this message translates to:
  /// **'Été'**
  String get saisonEte;

  /// Filtre saison : automne
  ///
  /// In fr, this message translates to:
  /// **'Automne'**
  String get saisonAutomne;

  /// Filtre saison : hiver
  ///
  /// In fr, this message translates to:
  /// **'Hiver'**
  String get saisonHiver;

  /// Titre écran profil
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profilTitle;

  /// Titre section statistiques profil
  ///
  /// In fr, this message translates to:
  /// **'Mes lucioles'**
  String get profilStatsSection;

  /// Compteur de lucioles dans le profil
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune luciole allumée} =1{1 luciole allumée} other{{count} lucioles allumées}}'**
  String profilLucioles(int count);

  /// Date d'inscription affichée dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Depuis le {date}'**
  String profilDepuis(String date);

  /// Titre section langue dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get profilLangueSection;

  /// Titre section fil du temps dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Fil du temps'**
  String get profilFilSection;

  /// Titre section compte dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get profilCompteSection;

  /// Label email de l'utilisateur connecté
  ///
  /// In fr, this message translates to:
  /// **'Connecté en tant que'**
  String get profilConnecteEmail;

  /// Titre état non connecté dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'es pas connecté'**
  String get profilNonConnecteTitre;

  /// Sous-titre état non connecté dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour allumer des lucioles et retrouver tous tes souvenirs.'**
  String get profilNonConnecteSousTitre;

  /// Bouton connexion depuis le profil non connecté
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get profilNonConnecteBouton;

  /// Label champ pseudo
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get profilPseudo;

  /// Bouton ajout pseudo
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un pseudo'**
  String get profilAjouterPseudo;

  /// Bouton modification pseudo
  ///
  /// In fr, this message translates to:
  /// **'Modifier le pseudo'**
  String get profilModifierPseudo;

  /// Bouton sauvegarde dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get profilSauvegarder;

  /// Label section photo de profil
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil'**
  String get profilPhotoAvatar;

  /// Titre section actions destructives dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Zone sensible'**
  String get profilZoneSensible;

  /// Bouton suppression de compte
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get profilSupprimerCompte;

  /// Titre dialogue confirmation suppression de compte
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte ?'**
  String get profilSupprimerTitre;

  /// Message dialogue confirmation suppression de compte
  ///
  /// In fr, this message translates to:
  /// **'Ton compte sera supprimé définitivement. Tes lucioles seront conservées de façon anonyme mais ne seront plus accessibles. Cette action est irréversible.'**
  String get profilSupprimerMessage;

  /// Bouton confirmation suppression de compte
  ///
  /// In fr, this message translates to:
  /// **'Supprimer définitivement'**
  String get profilSupprimerConfirmer;

  /// Bouton liaison compte Google
  ///
  /// In fr, this message translates to:
  /// **'Lier un compte Google'**
  String get profilLierGoogle;

  /// Confirmation liaison compte Google
  ///
  /// In fr, this message translates to:
  /// **'Compte Google lié avec succès'**
  String get profilLierGoogleConfirmation;

  /// Label compte OAuth lié
  ///
  /// In fr, this message translates to:
  /// **'Compte lié'**
  String get profilCompteLie;

  /// Bouton liaison compte Apple
  ///
  /// In fr, this message translates to:
  /// **'Lier un compte Apple'**
  String get profilLierApple;

  /// Message liaison Apple non disponible
  ///
  /// In fr, this message translates to:
  /// **'Liaison Apple bientôt disponible'**
  String get profilAppleBientot;

  /// Titre section connexion dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get profilConnexion;

  /// Titre section paramètres de compte
  ///
  /// In fr, this message translates to:
  /// **'Paramètres du compte'**
  String get profilParametresCompte;

  /// Titre état vide du fil du temps
  ///
  /// In fr, this message translates to:
  /// **'Ton atlas est encore vide.'**
  String get filVide;

  /// Sous-titre état vide du fil du temps
  ///
  /// In fr, this message translates to:
  /// **'Commence par noter ce qui t\'a touché aujourd\'hui.'**
  String get filVideSub;

  /// Titre état vide du fil filtré par saison
  ///
  /// In fr, this message translates to:
  /// **'Aucune luciole\ncet {saison}.'**
  String filVideFiltre(String saison);

  /// Sous-titre état vide du fil filtré par saison
  ///
  /// In fr, this message translates to:
  /// **'Change de saison pour explorer d\'autres souvenirs.'**
  String get filVideFiltreSub;

  /// Label action swipe suppression
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get filSupprimerLabel;

  /// Titre dialogue confirmation suppression d'entrée
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette luciole ?'**
  String get filSupprimerTitre;

  /// Contenu dialogue confirmation suppression d'entrée
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Ton souvenir sera définitivement effacé.'**
  String get filSupprimerContenu;

  /// Bouton annulation suppression d'entrée
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get filSupprimerAnnuler;

  /// Bouton confirmation suppression d'entrée
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get filSupprimerConfirmer;

  /// Titre principal écran d'authentification
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans les Lucioles'**
  String get authBienvenue;

  /// Sous-titre écran d'authentification
  ///
  /// In fr, this message translates to:
  /// **'Note ce qui t\'a touché aujourd\'hui.\nTes souvenirs restent toujours les tiens.'**
  String get authSousTitre;

  /// Label champ email
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get authEmail;

  /// Label champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authMotDePasse;

  /// Bouton connexion par email
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSeConnecter;

  /// Bouton inscription par email
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSInscrire;

  /// Séparateur entre auth email et auth sociale
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get authOu;

  /// Bouton connexion Google
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get authContinuerGoogle;

  /// Bouton connexion Apple
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get authContinuerApple;

  /// Texte bascule vers le mode inscription
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authPasDeCompte;

  /// Texte bascule vers le mode connexion
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authDejaUnCompte;

  /// Lien bascule vers inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authLienCreerCompte;

  /// Lien bascule vers connexion
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLienSeConnecter;

  /// Bouton déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authSeDeconnecter;

  /// Erreur validation email vide
  ///
  /// In fr, this message translates to:
  /// **'Saisis ton adresse e-mail.'**
  String get authErreurEmailVide;

  /// Erreur validation email invalide
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get authErreurEmailInvalide;

  /// Erreur validation mot de passe trop court
  ///
  /// In fr, this message translates to:
  /// **'Au moins 6 caractères.'**
  String get authErreurMotDePasseCourt;

  /// Erreur générique d'authentification
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessaie.'**
  String get authErreurGenerique;

  /// Message connexion Apple non disponible
  ///
  /// In fr, this message translates to:
  /// **'Connexion Apple bientôt disponible'**
  String get authAppleBientot;

  /// Titre gate d'authentification
  ///
  /// In fr, this message translates to:
  /// **'Rejoins les Lucioles'**
  String get authGateTitre;

  /// Sous-titre gate d'authentification
  ///
  /// In fr, this message translates to:
  /// **'Crée un compte pour noter ce qui t\'a touché aujourd\'hui.\nTes souvenirs restent toujours les tiens.'**
  String get authGateSousTitre;

  /// Bouton principal gate d'authentification
  ///
  /// In fr, this message translates to:
  /// **'Se connecter ou créer un compte'**
  String get authGateBouton;

  /// Bouton accès portail admin dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Portail admin'**
  String get adminAccesBouton;

  /// Titre écran portail admin
  ///
  /// In fr, this message translates to:
  /// **'Portail admin'**
  String get adminPortalTitle;

  /// Titre section statistiques du portail admin
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get adminPortalStats;

  /// Titre section gestion du portail admin
  ///
  /// In fr, this message translates to:
  /// **'Gestion'**
  String get adminPortalGestion;

  /// Bouton gestion utilisateurs
  ///
  /// In fr, this message translates to:
  /// **'Gestion des utilisateurs'**
  String get adminPortalUtilisateurs;

  /// Bouton gestion signalements
  ///
  /// In fr, this message translates to:
  /// **'Gestion des signalements'**
  String get adminPortalSignalements;

  /// Badge fonctionnalité admin à venir
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get adminPortalBientot;

  /// Bouton gestion feedbacks
  ///
  /// In fr, this message translates to:
  /// **'Feedbacks utilisateurs'**
  String get adminPortalFeedbacks;

  /// Titre écran gestion utilisateurs
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get adminUsersTitle;

  /// Placeholder barre de recherche utilisateurs
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un utilisateur…'**
  String get adminUsersRecherche;

  /// État vide liste utilisateurs
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur trouvé.'**
  String get adminUsersVide;

  /// Titre dialogue confirmation suppression utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'utilisateur ?'**
  String get adminUsersSupprimerTitre;

  /// Contenu dialogue confirmation suppression utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Le compte de {nom} sera supprimé définitivement. Cette action est irréversible.'**
  String adminUsersSupprimerMessage(String nom);

  /// Titre écran détail utilisateur admin
  ///
  /// In fr, this message translates to:
  /// **'Profil utilisateur'**
  String get adminUserDetailTitle;

  /// Titre dialogue grant admin
  ///
  /// In fr, this message translates to:
  /// **'Accorder les droits admin ?'**
  String get adminUsersGrantAdminTitre;

  /// Message dialogue grant admin
  ///
  /// In fr, this message translates to:
  /// **'{nom} aura accès au portail admin.'**
  String adminUsersGrantAdminMessage(String nom);

  /// Titre dialogue revoke admin
  ///
  /// In fr, this message translates to:
  /// **'Retirer les droits admin ?'**
  String get adminUsersRevokeAdminTitre;

  /// Message dialogue revoke admin
  ///
  /// In fr, this message translates to:
  /// **'{nom} n\'aura plus accès au portail admin.'**
  String adminUsersRevokeAdminMessage(String nom);

  /// Titre dialogue restriction de luciole
  ///
  /// In fr, this message translates to:
  /// **'Restreindre cette luciole ?'**
  String get adminLucioleRestrictTitre;

  /// Message dialogue restriction de luciole
  ///
  /// In fr, this message translates to:
  /// **'Elle sera masquée de la communauté. Cette action est réversible.'**
  String get adminLucioleRestrictMsg;

  /// Titre dialogue approbation de luciole
  ///
  /// In fr, this message translates to:
  /// **'Approuver cette luciole ?'**
  String get adminLucioleApprouverTitre;

  /// Message dialogue approbation de luciole
  ///
  /// In fr, this message translates to:
  /// **'Elle sera de nouveau visible dans la communauté.'**
  String get adminLucioleApprouverMsg;

  /// Label utilisateur supprimé dans un signalement
  ///
  /// In fr, this message translates to:
  /// **'Compte supprimé'**
  String get adminSignalementsUserSupprimeLabel;

  /// Titre écran gestion signalements
  ///
  /// In fr, this message translates to:
  /// **'Signalements'**
  String get adminSignalementsTitle;

  /// État vide liste signalements
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement en attente.'**
  String get adminSignalementsVide;

  /// Bouton approbation d'un signalement
  ///
  /// In fr, this message translates to:
  /// **'Approuver'**
  String get adminSignalementsApprouver;

  /// Bouton restriction d'un signalement
  ///
  /// In fr, this message translates to:
  /// **'Restreindre'**
  String get adminSignalementsRestreindre;

  /// Badge luciole restreinte
  ///
  /// In fr, this message translates to:
  /// **'Restreinte'**
  String get adminSignalementsTagRestreinte;

  /// Badge utilisateur récidiviste
  ///
  /// In fr, this message translates to:
  /// **'Récidiviste'**
  String get adminSignalementsTagRecidiviste;

  /// Lien vers profil depuis un signalement
  ///
  /// In fr, this message translates to:
  /// **'Voir le profil'**
  String get adminSignalementsVoirProfil;

  /// Compteur de signalements sur une luciole
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 signalement} other{{count} signalements}}'**
  String adminSignalementsCount(int count);

  /// Compteur de lucioles signalées par un utilisateur
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 luciole signalée} other{{count} lucioles signalées}}'**
  String adminSignalementsLuciolesSig(int count);

  /// Titre écran feedbacks admin
  ///
  /// In fr, this message translates to:
  /// **'Feedbacks'**
  String get adminFeedbacksTitle;

  /// État vide liste feedbacks admin
  ///
  /// In fr, this message translates to:
  /// **'Aucun feedback pour l\'instant.'**
  String get adminFeedbacksVide;

  /// Titre écran archives signalements
  ///
  /// In fr, this message translates to:
  /// **'Archives'**
  String get adminArchivesTitle;

  /// État vide liste archives signalements
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement archivé.'**
  String get adminArchivesVide;

  /// Placeholder barre de recherche des archives
  ///
  /// In fr, this message translates to:
  /// **'Email, pseudo, contenu, date…'**
  String get adminArchivesRecherche;

  /// Badge décision approuvé dans les archives
  ///
  /// In fr, this message translates to:
  /// **'Approuvé'**
  String get adminArchivesApprouve;

  /// Badge décision restreint dans les archives
  ///
  /// In fr, this message translates to:
  /// **'Restreint'**
  String get adminArchivesRestreint;

  /// Date de décision admin dans les archives
  ///
  /// In fr, this message translates to:
  /// **'Décidé le {date}'**
  String adminArchivesDecisionLe(String date);

  /// Date de publication de l'entrée dans les archives
  ///
  /// In fr, this message translates to:
  /// **'Publié le {date}'**
  String adminArchivesPublieLe(String date);

  /// Bouton ouverture bottom sheet feedback
  ///
  /// In fr, this message translates to:
  /// **'Donner ton avis'**
  String get feedbackBouton;

  /// Titre bottom sheet feedback
  ///
  /// In fr, this message translates to:
  /// **'Partage ton avis'**
  String get feedbackTitre;

  /// Type feedback : bug
  ///
  /// In fr, this message translates to:
  /// **'Bug'**
  String get feedbackTypeBug;

  /// Type feedback : suggestion
  ///
  /// In fr, this message translates to:
  /// **'Suggestion'**
  String get feedbackTypeSuggestion;

  /// Type feedback : autre
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get feedbackTypeAutre;

  /// Label champ message du feedback
  ///
  /// In fr, this message translates to:
  /// **'Ton message'**
  String get feedbackMessage;

  /// Placeholder champ message du feedback
  ///
  /// In fr, this message translates to:
  /// **'Décris le problème ou ta suggestion…'**
  String get feedbackMessageHint;

  /// Bouton envoi du feedback
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get feedbackEnvoyer;

  /// Confirmation envoi du feedback
  ///
  /// In fr, this message translates to:
  /// **'Merci pour ton retour !'**
  String get feedbackConfirmation;

  /// Erreur envoi du feedback
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get feedbackErreur;

  /// Erreur validation message feedback vide
  ///
  /// In fr, this message translates to:
  /// **'Écris un message.'**
  String get feedbackMessageVide;

  /// Bouton Buy Me a Coffee dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Soutenir le développeur'**
  String get donAccesBouton;

  /// Sous-titre bouton don
  ///
  /// In fr, this message translates to:
  /// **'Buy Me a Coffee ☕'**
  String get donSousTitre;

  /// Bouton accès écran aide dans le profil
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get aideAccesBouton;

  /// Titre écran aide
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get aideTitle;

  /// Titre carte feedback dans l'aide
  ///
  /// In fr, this message translates to:
  /// **'Partage ton avis'**
  String get aideFeedbackTitre;

  /// Sous-titre carte feedback dans l'aide
  ///
  /// In fr, this message translates to:
  /// **'Une suggestion, un bug, une idée ? Dis-nous tout.'**
  String get aideFeedbackSousTitre;

  /// Titre section tutoriels dans l'aide
  ///
  /// In fr, this message translates to:
  /// **'Tutoriels'**
  String get aideTutorielsSection;

  /// Titre section FAQ dans l'aide
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes'**
  String get aideFAQSection;

  /// Tutoriel 1 : question
  ///
  /// In fr, this message translates to:
  /// **'Comment allumer une luciole ?'**
  String get aideTuto1Q;

  /// Tutoriel 1 : réponse
  ///
  /// In fr, this message translates to:
  /// **'Va dans l\'onglet « Saisie », note une chose positive que tu as observée dans ton quartier, puis appuie sur « Allumer une luciole ». Tu peux y ajouter un lieu et une photo.'**
  String get aideTuto1R;

  /// Tutoriel 2 : question
  ///
  /// In fr, this message translates to:
  /// **'Comment ajouter un lieu à une entrée ?'**
  String get aideTuto2Q;

  /// Tutoriel 2 : réponse
  ///
  /// In fr, this message translates to:
  /// **'Dans le formulaire de saisie, appuie sur le champ « Lieu ». Tu peux utiliser ta position GPS ou saisir un nom manuellement.'**
  String get aideTuto2R;

  /// Tutoriel 3 : question
  ///
  /// In fr, this message translates to:
  /// **'Comment retrouver mes lucioles ?'**
  String get aideTuto3Q;

  /// Tutoriel 3 : réponse
  ///
  /// In fr, this message translates to:
  /// **'Tes lucioles sont visibles dans l\'onglet « Carte » (sur la carte) et dans l\'onglet « Moi » (fil du temps). Seules les lucioles avec un lieu apparaissent sur la carte.'**
  String get aideTuto3R;

  /// Tutoriel 4 : question
  ///
  /// In fr, this message translates to:
  /// **'Comment filtrer par saison ?'**
  String get aideTuto4Q;

  /// Tutoriel 4 : réponse
  ///
  /// In fr, this message translates to:
  /// **'Dans l\'onglet « Moi », utilise les filtres de saison (Printemps, Été, Automne, Hiver) juste au-dessus de ton fil du temps.'**
  String get aideTuto4R;

  /// FAQ 1 : question suppression
  ///
  /// In fr, this message translates to:
  /// **'Puis-je supprimer une luciole ?'**
  String get aideFaq1Q;

  /// FAQ 1 : réponse suppression
  ///
  /// In fr, this message translates to:
  /// **'Oui. Dans ton fil du temps (onglet « Moi »), fais glisser une entrée vers la gauche pour voir le bouton de suppression. Cette action est irréversible.'**
  String get aideFaq1R;

  /// FAQ 2 : question confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Mes données sont-elles privées ?'**
  String get aideFaq2Q;

  /// FAQ 2 : réponse confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Tes entrées avec un lieu peuvent apparaître sur la carte communautaire. Sans lieu, elles restent invisibles des autres. Tu peux aussi filtrer l\'affichage depuis la carte.'**
  String get aideFaq2R;

  /// FAQ 3 : question sans compte
  ///
  /// In fr, this message translates to:
  /// **'Puis-je utiliser l\'app sans compte ?'**
  String get aideFaq3Q;

  /// FAQ 3 : réponse sans compte
  ///
  /// In fr, this message translates to:
  /// **'Tu peux explorer la carte communautaire sans compte. Pour allumer des lucioles et retrouver tes souvenirs, il te faudra créer un compte gratuit.'**
  String get aideFaq3R;

  /// FAQ 4 : question modération
  ///
  /// In fr, this message translates to:
  /// **'Comment fonctionne la modération ?'**
  String get aideFaq4Q;

  /// FAQ 4 : réponse modération
  ///
  /// In fr, this message translates to:
  /// **'Lucioles repose sur la bienveillance. Tout contenu signalé est examiné par notre équipe. Les contenus inappropriés sont masqués pour préserver un espace positif et respectueux.'**
  String get aideFaq4R;

  /// Bouton passer l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingPasser;

  /// Bouton page suivante onboarding
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get onboardingSuivant;

  /// Bouton terminer l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Allumer ma première luciole ✦'**
  String get onboardingCommencer;

  /// Titre page 1 onboarding
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans les Lucioles'**
  String get onboarding1Titre;

  /// Texte page 1 onboarding
  ///
  /// In fr, this message translates to:
  /// **'Chaque jour, une petite lumière. Note un moment positif que tu as vécu dans ton quartier — aussi discret soit-il.'**
  String get onboarding1Corps;

  /// Titre page 2 onboarding
  ///
  /// In fr, this message translates to:
  /// **'Ton atlas de bons souvenirs'**
  String get onboarding2Titre;

  /// Texte page 2 onboarding
  ///
  /// In fr, this message translates to:
  /// **'Localise tes observations et construis ta propre carte. Un atlas intime des endroits qui t\'ont touché.'**
  String get onboarding2Corps;

  /// Titre page 3 onboarding
  ///
  /// In fr, this message translates to:
  /// **'Un espace doux et sécurisé'**
  String get onboarding3Titre;

  /// Texte page 3 onboarding
  ///
  /// In fr, this message translates to:
  /// **'Lucioles repose sur la bienveillance. Chaque contenu est modéré pour que cet espace reste positif et respectueux pour tous.'**
  String get onboarding3Corps;

  /// Bouton signaler une luciole
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get signalementSignaler;

  /// Titre bottom sheet signalement
  ///
  /// In fr, this message translates to:
  /// **'Signaler cette luciole'**
  String get signalementTitre;

  /// Question choix de raison du signalement
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi veux-tu signaler cette luciole ?'**
  String get signalementChoixRaison;

  /// Raison signalement : contenu inapproprié
  ///
  /// In fr, this message translates to:
  /// **'Contenu inapproprié'**
  String get signalementRaisonInapproprie;

  /// Raison signalement : contenu offensant
  ///
  /// In fr, this message translates to:
  /// **'Contenu offensant'**
  String get signalementRaisonOffensant;

  /// Raison signalement : spam
  ///
  /// In fr, this message translates to:
  /// **'Spam'**
  String get signalementRaisonSpam;

  /// Raison signalement : autre
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get signalementRaisonAutre;

  /// Label champ détails du signalement
  ///
  /// In fr, this message translates to:
  /// **'Détails (optionnel)'**
  String get signalementDetails;

  /// Placeholder champ détails du signalement
  ///
  /// In fr, this message translates to:
  /// **'Précisions éventuelles…'**
  String get signalementDetailsHint;

  /// Bouton envoi du signalement
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le signalement'**
  String get signalementEnvoyer;

  /// Confirmation envoi du signalement
  ///
  /// In fr, this message translates to:
  /// **'Signalement envoyé.'**
  String get signalementConfirmation;

  /// Message signalement déjà effectué
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà signalé cette luciole.'**
  String get signalementDejaFait;

  /// Erreur envoi du signalement
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
