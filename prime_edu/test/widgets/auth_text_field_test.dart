import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prime_edu/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthTextField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('deve renderizar o campo de texto com label correto',
        (WidgetTester tester) async {
      // arrange
      const labelText = 'Email';

      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: labelText,
          ),
        ),
      );

      // assert
      expect(find.text(labelText), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('deve aceitar entrada de texto', (WidgetTester tester) async {
      // arrange
      const testText = 'test@example.com';

      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), testText);

      // assert
      expect(controller.text, testText);
    });

    testWidgets('deve renderizar com obscureText true',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Senha',
            obscureText: true,
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('deve renderizar com obscureText false',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
            obscureText: false,
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('deve chamar validator quando fornecido',
        (WidgetTester tester) async {
      // arrange
      bool validatorCalled = false;
      String? validatorFunction(String? value) {
        validatorCalled = true;
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      }

      // act
      await tester.pumpWidget(
        createTestWidget(
          Form(
            child: AuthTextField(
              controller: controller,
              labelText: 'Email',
              validator: validatorFunction,
            ),
          ),
        ),
      );

      // Trigger validation
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();

      // assert
      expect(validatorCalled, true);
    });

    testWidgets('deve mostrar mensagem de erro quando validação falhar',
        (WidgetTester tester) async {
      // arrange
      const errorMessage = 'Campo obrigatório';
      String? validatorFunction(String? value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      }

      // act
      await tester.pumpWidget(
        createTestWidget(
          Form(
            child: AuthTextField(
              controller: controller,
              labelText: 'Email',
              validator: validatorFunction,
            ),
          ),
        ),
      );

      // Trigger validation
      final formState = tester.state<FormState>(find.byType(Form));
      formState.validate();
      await tester.pump();

      // assert
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('deve renderizar com tipo de teclado customizado',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('deve mostrar suffixIcon quando fornecido',
        (WidgetTester tester) async {
      // arrange
      const icon = Icon(Icons.visibility);

      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Senha',
            suffixIcon: icon,
          ),
        ),
      );

      // assert
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('deve chamar onChanged quando o texto mudar',
        (WidgetTester tester) async {
      // arrange
      String? changedValue;
      void onChangedFunction(String value) {
        changedValue = value;
      }

      const testText = 'test@example.com';

      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
            onChanged: onChangedFunction,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), testText);

      // assert
      expect(changedValue, testText);
    });

    testWidgets('deve renderizar quando desabilitado',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
            enabled: false,
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('deve renderizar quando habilitado',
        (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('deve renderizar corretamente', (WidgetTester tester) async {
      // act
      await tester.pumpWidget(
        createTestWidget(
          AuthTextField(
            controller: controller,
            labelText: 'Email',
          ),
        ),
      );

      // assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
    });
  });
}
