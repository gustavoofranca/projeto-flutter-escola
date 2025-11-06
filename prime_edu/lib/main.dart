import 'package:flutter/material.dart';
import 'package:prime_edu/app.dart';
import 'core/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa as dependências
  await di.init();
  
  runApp(const App());
}
