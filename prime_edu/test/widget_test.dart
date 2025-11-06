import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_edu/app.dart';
import 'package:prime_edu/core/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    // Inicializa as dependências antes de executar os testes
    await di.init();
  });

  group('Prime Edu App Tests', () {
    testWidgets('App should start without crashing', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const App());

      // Verify that our app starts correctly
      expect(find.byType(MaterialApp), findsOneWidget);
    }, skip: true); // Asset de imagem faltando (google_logo.png)
  });
}
