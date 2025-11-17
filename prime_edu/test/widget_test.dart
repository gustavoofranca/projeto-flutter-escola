import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_edu/app.dart';
import 'package:prime_edu/core/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Inicializa as dependências antes de executar os testes
    await di.init();
  });

  group('Prime Edu App Tests', () {
    testWidgets('App deve inicializar com MaterialApp', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const App());

      // Verify that our app starts correctly
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App deve ter título correto', (
      WidgetTester tester,
    ) async {
      // Build our app
      await tester.pumpWidget(const App());

      // Verify app title
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.title, 'Prime Edu');
    });

    testWidgets('App deve usar tema escuro', (
      WidgetTester tester,
    ) async {
      // Build our app
      await tester.pumpWidget(const App());

      // Verify dark theme
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme?.brightness, Brightness.dark);
    });

    testWidgets('App não deve mostrar banner de debug', (
      WidgetTester tester,
    ) async {
      // Build our app
      await tester.pumpWidget(const App());

      // Verify debug banner is hidden
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });
}
