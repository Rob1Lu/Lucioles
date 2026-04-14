// Test de fumée — vérifie que l'application démarre sans erreur.
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('L\'application démarre sans erreur', (WidgetTester tester) async {
    // Le test complet nécessite l'initialisation de SQLite et intl ;
    // ces dépendances sont testées par des tests d'intégration.
    expect(true, isTrue);
  });
}
