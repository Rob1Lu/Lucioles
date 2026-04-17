import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/supabase_config.dart';
import 'data/repositories/entree_repository.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/entrees_provider.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise les données de formatage des dates pour les 3 langues supportées
  await Future.wait([
    initializeDateFormatting('fr'),
    initializeDateFormatting('en'),
    initializeDateFormatting('es'),
  ]);

  // Initialise le client Supabase (auth, DB, storage)
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      // Restaure automatiquement la session depuis le stockage local
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Charge la locale persistée AVANT runApp pour éviter un flash au démarrage
  final localeProvider = LocaleProvider();
  await localeProvider.charger();

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        // Locale — contrôle la langue de toute l'app
        ChangeNotifierProvider.value(value: localeProvider),
        // Auth — session Supabase (écoute onAuthStateChange)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Données — entrées Supabase, auto-chargées à la connexion
        ChangeNotifierProvider(
          create: (_) => EntreesProvider(repository: EntreeRepository()),
        ),
        // Profil — pseudo et avatar, auto-chargés à la connexion
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: LuciolesApp(onboardingDone: onboardingDone),
    ),
  );
}
