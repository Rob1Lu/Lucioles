// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Lucioles';

  @override
  String get navSaisie => 'Escribir';

  @override
  String get navCarte => 'Mapa';

  @override
  String get navMoi => 'Yo';

  @override
  String get saisieAppBarTitle => 'Lucioles';

  @override
  String get saisieBadgeDuJour => 'Tu luciérnaga de hoy';

  @override
  String get saisieDejaFaite =>
      'Vuelve mañana para encender\nuna nueva luciérnaga.';

  @override
  String get saisieQuestion => 'Hoy,\nen tu barrio…';

  @override
  String get saisieSubtitle => 'Anota algo positivo que hayas notado.';

  @override
  String get saisieHint =>
      'Un rayo de sol entre edificios, una conversación inesperada, flores en un balcón…';

  @override
  String get saisieLieuLabel => 'Lugar (opcional)';

  @override
  String get saisiePhotoLabel => 'Foto (opcional)';

  @override
  String get saisieButtonAllumer => 'Encender una luciérnaga ✦';

  @override
  String get saisieConfirmation => 'Tu luciérnaga está encendida.';

  @override
  String get saisieValidator => 'Escribe algunas palabras…';

  @override
  String get saisieAjouterPhoto => 'Añadir una foto';

  @override
  String get saisieAjouterPhotoAposteriori => 'Añadir una foto';

  @override
  String get saisieAjoutPhotoConfirmation =>
      'Foto añadida a tu luciérnaga del día ✦';

  @override
  String get lieuUtiliserPosition => 'Usar mi ubicación';

  @override
  String get lieuLocalisation => 'Localizando…';

  @override
  String get lieuPersonnaliserNom =>
      'Personalizar el nombre del lugar… (opcional)';

  @override
  String get lieuNomHint => 'Dale un nombre a este lugar… (opcional)';

  @override
  String get lieuGeolocDesactive => 'La geolocalización está desactivada.';

  @override
  String get lieuPermissionRefusee => 'Permiso de ubicación denegado.';

  @override
  String get lieuPermissionDefinitive =>
      'Permiso denegado permanentemente. Revisa los ajustes.';

  @override
  String get lieuErreur => 'No se puede obtener la ubicación.';

  @override
  String get carteMonAtlas => 'Mi atlas';

  @override
  String carteLucioles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count luciérnagas',
      one: '1 luciérnaga',
    );
    return '$_temp0';
  }

  @override
  String get carteFiltres => 'Filtros';

  @override
  String get carteFiltresPeriode => 'Período';

  @override
  String get carteFiltresReinitialiser => 'Restablecer';

  @override
  String get carteFiltresUniquement => 'Solo mis luciérnagas';

  @override
  String get carteFiltresCommunaute => 'Oculta las luciérnagas de la comunidad';

  @override
  String get carteFiltresChoisirDates => 'Elegir fechas…';

  @override
  String get carteDatePickerTitre => 'Elegir un período';

  @override
  String get carteDatePickerAnnuler => 'Cancelar';

  @override
  String get carteDatePickerConfirmer => 'Confirmar';

  @override
  String get carteAtlasVide => 'Tu atlas está aún vacío.';

  @override
  String get carteAtlasVideSub =>
      'Añade un lugar a tu próxima entrada para\nver tu primera luciérnaga encenderse aquí.';

  @override
  String get carteAucunePeriode => 'Ninguna luciérnaga en este período.';

  @override
  String get carteAucunePeriodeSub =>
      'Prueba otro período o\nrestablece los filtros.';

  @override
  String get carteReinitialiserFiltres => 'Restablecer filtros';

  @override
  String get filterToday => 'Hoy';

  @override
  String get filterWeek => 'Esta semana';

  @override
  String get filterMonth => 'Este mes';

  @override
  String get filterYear => 'Este año';

  @override
  String get filterCustom => 'Personalizado';

  @override
  String get filterTodayShort => 'Hoy';

  @override
  String get filterWeekShort => 'Semana';

  @override
  String get filterMonthShort => 'Mes';

  @override
  String get filterYearShort => 'Año';

  @override
  String get filterCustomShort => 'Perso.';

  @override
  String get saisonToutes => 'Todas';

  @override
  String get saisonPrintemps => 'Primavera';

  @override
  String get saisonEte => 'Verano';

  @override
  String get saisonAutomne => 'Otoño';

  @override
  String get saisonHiver => 'Invierno';

  @override
  String get profilTitle => 'Perfil';

  @override
  String get profilStatsSection => 'Mis luciérnagas';

  @override
  String profilLucioles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count luciérnagas encendidas',
      one: '1 luciérnaga encendida',
      zero: 'Ninguna luciérnaga',
    );
    return '$_temp0';
  }

  @override
  String profilDepuis(String date) {
    return 'Desde el $date';
  }

  @override
  String get profilLangueSection => 'Idioma';

  @override
  String get profilFilSection => 'Cronología';

  @override
  String get profilCompteSection => 'Cuenta';

  @override
  String get profilConnecteEmail => 'Conectado como';

  @override
  String get profilNonConnecteTitre => 'No has iniciado sesión';

  @override
  String get profilNonConnecteSousTitre =>
      'Inicia sesión para encender luciérnagas y encontrar todos tus recuerdos.';

  @override
  String get profilNonConnecteBouton => 'Iniciar sesión';

  @override
  String get profilPseudo => 'Apodo';

  @override
  String get profilAjouterPseudo => 'Añadir apodo';

  @override
  String get profilModifierPseudo => 'Editar apodo';

  @override
  String get profilSauvegarder => 'Guardar';

  @override
  String get profilPhotoAvatar => 'Foto de perfil';

  @override
  String get profilZoneSensible => 'Zona sensible';

  @override
  String get profilSupprimerCompte => 'Eliminar mi cuenta';

  @override
  String get profilSupprimerTitre => '¿Eliminar tu cuenta?';

  @override
  String get profilSupprimerMessage =>
      'Tu cuenta se eliminará definitivamente. Tus luciérnagas se conservarán de forma anónima pero ya no serán accesibles. Esta acción es irreversible.';

  @override
  String get profilSupprimerConfirmer => 'Eliminar definitivamente';

  @override
  String get profilLierGoogle => 'Vincular una cuenta de Google';

  @override
  String get profilLierGoogleConfirmation =>
      'Cuenta de Google vinculada exitosamente';

  @override
  String get profilCompteLie => 'Cuenta vinculada';

  @override
  String get profilLierApple => 'Vincular una cuenta de Apple';

  @override
  String get profilAppleBientot => 'Vinculación con Apple próximamente';

  @override
  String get profilConnexion => 'Inicio de sesión';

  @override
  String get profilParametresCompte => 'Ajustes de la cuenta';

  @override
  String get filVide => 'Tu atlas está aún vacío.';

  @override
  String get filVideSub => 'Empieza anotando lo que te conmovió hoy.';

  @override
  String filVideFiltre(String saison) {
    return 'Ninguna luciérnaga\nesta $saison.';
  }

  @override
  String get filVideFiltreSub =>
      'Cambia de estación para explorar otros recuerdos.';

  @override
  String get filSupprimerLabel => 'Eliminar';

  @override
  String get filSupprimerTitre => '¿Eliminar esta luciérnaga?';

  @override
  String get filSupprimerContenu =>
      'Esta acción es irreversible. Tu recuerdo será borrado definitivamente.';

  @override
  String get filSupprimerAnnuler => 'Cancelar';

  @override
  String get filSupprimerConfirmer => 'Eliminar';

  @override
  String get authBienvenue => 'Bienvenido a Lucioles';

  @override
  String get authSousTitre =>
      'Anota lo que te conmovió hoy.\nTus recuerdos siempre serán tuyos.';

  @override
  String get authEmail => 'Dirección de correo';

  @override
  String get authMotDePasse => 'Contraseña';

  @override
  String get authSeConnecter => 'Iniciar sesión';

  @override
  String get authSInscrire => 'Crear una cuenta';

  @override
  String get authOu => 'o';

  @override
  String get authContinuerGoogle => 'Continuar con Google';

  @override
  String get authContinuerApple => 'Continuar con Apple';

  @override
  String get authPasDeCompte => '¿Sin cuenta aún?';

  @override
  String get authDejaUnCompte => '¿Ya tienes una cuenta?';

  @override
  String get authLienCreerCompte => 'Crear una cuenta';

  @override
  String get authLienSeConnecter => 'Iniciar sesión';

  @override
  String get authSeDeconnecter => 'Cerrar sesión';

  @override
  String get authErreurEmailVide => 'Introduce tu correo electrónico.';

  @override
  String get authErreurEmailInvalide => 'Dirección de correo inválida.';

  @override
  String get authErreurMotDePasseCourt => 'Al menos 6 caracteres.';

  @override
  String get authErreurGenerique => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get authAppleBientot => 'Inicio de sesión con Apple próximamente';

  @override
  String get authGateTitre => 'Únete a Lucioles';

  @override
  String get authGateSousTitre =>
      'Crea una cuenta para anotar lo que te conmovió hoy.\nTus recuerdos siempre serán tuyos.';

  @override
  String get authGateBouton => 'Iniciar sesión o crear una cuenta';

  @override
  String get adminAccesBouton => 'Portal admin';

  @override
  String get adminPortalTitle => 'Portal admin';

  @override
  String get adminPortalStats => 'Estadísticas';

  @override
  String get adminPortalGestion => 'Gestión';

  @override
  String get adminPortalUtilisateurs => 'Gestión de usuarios';

  @override
  String get adminPortalSignalements => 'Gestión de reportes';

  @override
  String get adminPortalBientot => 'Próximamente';

  @override
  String get adminPortalFeedbacks => 'Opiniones de usuarios';

  @override
  String get adminUsersTitle => 'Usuarios';

  @override
  String get adminUsersRecherche => 'Buscar un usuario…';

  @override
  String get adminUsersVide => 'No se encontraron usuarios.';

  @override
  String get adminUsersSupprimerTitre => '¿Eliminar usuario?';

  @override
  String adminUsersSupprimerMessage(String nom) {
    return 'La cuenta de $nom se eliminará definitivamente. Esta acción es irreversible.';
  }

  @override
  String get adminUserDetailTitle => 'Perfil de usuario';

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
  String get adminLucioleRestrictTitre => '¿Restringir esta luciérnaga?';

  @override
  String get adminLucioleRestrictMsg =>
      'Se ocultará de la comunidad. Esta acción es reversible.';

  @override
  String get adminLucioleApprouverTitre => '¿Aprobar esta luciérnaga?';

  @override
  String get adminLucioleApprouverMsg =>
      'Volverá a ser visible en la comunidad.';

  @override
  String get adminSignalementsUserSupprimeLabel => 'Cuenta eliminada';

  @override
  String get adminSignalementsTitle => 'Reportes';

  @override
  String get adminSignalementsVide => 'Sin reportes pendientes.';

  @override
  String get adminSignalementsApprouver => 'Aprobar';

  @override
  String get adminSignalementsRestreindre => 'Restringir';

  @override
  String get adminSignalementsTagRestreinte => 'Restringida';

  @override
  String get adminSignalementsTagRecidiviste => 'Reincidente';

  @override
  String get adminSignalementsVoirProfil => 'Ver perfil';

  @override
  String adminSignalementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reportes',
      one: '1 reporte',
    );
    return '$_temp0';
  }

  @override
  String adminSignalementsLuciolesSig(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count luciérnagas reportadas',
      one: '1 luciérnaga reportada',
    );
    return '$_temp0';
  }

  @override
  String get adminFeedbacksTitle => 'Opiniones';

  @override
  String get adminFeedbacksVide => 'Aún no hay opiniones.';

  @override
  String get adminArchivesTitle => 'Archivos';

  @override
  String get adminArchivesVide => 'No hay reportes archivados.';

  @override
  String get adminArchivesRecherche => 'Email, usuario, contenido, fecha…';

  @override
  String get adminArchivesApprouve => 'Aprobado';

  @override
  String get adminArchivesRestreint => 'Restringido';

  @override
  String adminArchivesDecisionLe(String date) {
    return 'Decidido el $date';
  }

  @override
  String adminArchivesPublieLe(String date) {
    return 'Publicado el $date';
  }

  @override
  String get feedbackBouton => 'Dar opinión';

  @override
  String get feedbackTitre => 'Comparte tu opinión';

  @override
  String get feedbackTypeBug => 'Error';

  @override
  String get feedbackTypeSuggestion => 'Sugerencia';

  @override
  String get feedbackTypeAutre => 'Otro';

  @override
  String get feedbackMessage => 'Tu mensaje';

  @override
  String get feedbackMessageHint => 'Describe el problema o tu sugerencia…';

  @override
  String get feedbackEnvoyer => 'Enviar';

  @override
  String get feedbackConfirmation => '¡Gracias por tu opinión!';

  @override
  String get feedbackErreur => 'Se produjo un error.';

  @override
  String get feedbackMessageVide => 'Por favor, escribe un mensaje.';

  @override
  String get donAccesBouton => 'Apoyar al desarrollador';

  @override
  String get donSousTitre => 'Buy Me a Coffee ☕';

  @override
  String get aideAccesBouton => 'Ayuda';

  @override
  String get aideTitle => 'Ayuda';

  @override
  String get aideFeedbackTitre => 'Comparte tu opinión';

  @override
  String get aideFeedbackSousTitre =>
      '¿Una sugerencia, un error, una idea? Cuéntanos todo.';

  @override
  String get aideTutorielsSection => 'Tutoriales';

  @override
  String get aideFAQSection => 'Preguntas frecuentes';

  @override
  String get aideTuto1Q => '¿Cómo encender una luciérnaga?';

  @override
  String get aideTuto1R =>
      'Ve a la pestaña «Escribir», anota algo positivo que hayas observado en tu barrio y pulsa «Encender una luciérnaga». Puedes añadir un lugar y una foto.';

  @override
  String get aideTuto2Q => '¿Cómo añadir un lugar a una entrada?';

  @override
  String get aideTuto2R =>
      'En el formulario de entrada, pulsa el campo «Lugar». Puedes usar tu posición GPS o escribir un nombre manualmente.';

  @override
  String get aideTuto3Q => '¿Cómo encontrar mis luciérnagas?';

  @override
  String get aideTuto3R =>
      'Tus luciérnagas aparecen en la pestaña «Mapa» (en el mapa) y en la pestaña «Yo» (cronología). Solo las luciérnagas con un lugar aparecen en el mapa.';

  @override
  String get aideTuto4Q => '¿Cómo filtrar por estación?';

  @override
  String get aideTuto4R =>
      'En la pestaña «Yo», usa los filtros de estación (Primavera, Verano, Otoño, Invierno) justo encima de tu cronología.';

  @override
  String get aideFaq1Q => '¿Puedo eliminar una luciérnaga?';

  @override
  String get aideFaq1R =>
      'Sí. En tu cronología (pestaña «Yo»), desliza una entrada hacia la izquierda para ver el botón de eliminación. Esta acción es irreversible.';

  @override
  String get aideFaq2Q => '¿Son privados mis datos?';

  @override
  String get aideFaq2R =>
      'Las entradas con un lugar pueden aparecer en el mapa comunitario. Sin lugar, permanecen invisibles para los demás. También puedes filtrar la visualización desde el mapa.';

  @override
  String get aideFaq3Q => '¿Puedo usar la app sin cuenta?';

  @override
  String get aideFaq3R =>
      'Puedes explorar el mapa comunitario sin cuenta. Para encender luciérnagas y recuperar tus recuerdos, necesitarás crear una cuenta gratuita.';

  @override
  String get aideFaq4Q => '¿Cómo funciona la moderación?';

  @override
  String get aideFaq4R =>
      'Lucioles se basa en la amabilidad. Todo contenido reportado es revisado por nuestro equipo. El contenido inapropiado se oculta para preservar un espacio positivo y respetuoso.';

  @override
  String get onboardingPasser => 'Omitir';

  @override
  String get onboardingSuivant => 'Continuar';

  @override
  String get onboardingCommencer => 'Encender mi primera luciérnaga ✦';

  @override
  String get onboarding1Titre => 'Bienvenido a Lucioles';

  @override
  String get onboarding1Corps =>
      'Cada día, una pequeña luz. Anota un momento positivo que hayas vivido en tu barrio — por pequeño que sea.';

  @override
  String get onboarding2Titre => 'Tu atlas de buenos recuerdos';

  @override
  String get onboarding2Corps =>
      'Localiza tus observaciones y construye tu propio mapa personal. Un atlas íntimo de los lugares que te han tocado.';

  @override
  String get onboarding3Titre => 'Un espacio tranquilo y seguro';

  @override
  String get onboarding3Corps =>
      'Lucioles se basa en la amabilidad. Cada contenido es moderado para que este espacio siga siendo positivo y respetuoso para todos.';

  @override
  String get signalementSignaler => 'Reportar';

  @override
  String get signalementTitre => 'Reportar esta luciérnaga';

  @override
  String get signalementChoixRaison =>
      '¿Por qué quieres reportar esta luciérnaga?';

  @override
  String get signalementRaisonInapproprie => 'Contenido inapropiado';

  @override
  String get signalementRaisonOffensant => 'Contenido ofensivo';

  @override
  String get signalementRaisonSpam => 'Spam';

  @override
  String get signalementRaisonAutre => 'Otro';

  @override
  String get signalementDetails => 'Detalles (opcional)';

  @override
  String get signalementDetailsHint => 'Detalles adicionales…';

  @override
  String get signalementEnvoyer => 'Enviar reporte';

  @override
  String get signalementConfirmation => 'Reporte enviado.';

  @override
  String get signalementDejaFait => 'Ya has reportado esta luciérnaga.';

  @override
  String get signalementErreur => 'Se produjo un error.';
}
