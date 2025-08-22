import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:potea_edu/main.dart';

void main() {
  group('Potea Edu App Tests', () {
    testWidgets('App should start without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const PoteaEduApp());

      // Verify that our app starts correctly
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    
  });
}
