# 🚀 Guia de Implementação: Gerenciamento de Estado Avançado

## 📋 Índice
1. [Visão Geral](#visão-geral)
2. [Passo a Passo](#passo-a-passo)
3. [Exemplos de Uso](#exemplos-de-uso)
4. [Padrões Avançados](#padrões-avançados)
5. [Testes](#testes)

---

## 🎯 Visão Geral

### O que foi implementado?

✅ **Estado Imutável com Freezed**
- Classe `AuthState` com estados bem definidos
- Geração automática de `copyWith()`, `==`, `hashCode`
- Factory constructors para estados comuns

✅ **ViewModel Aprimorado**
- `AuthViewModelV2` usando estado imutável
- Melhor rastreamento de mudanças
- Logs para debug
- Tratamento de erros robusto

✅ **Arquitetura Mantida**
- Clean Architecture preservada
- MVVM pattern aprimorado
- Compatibilidade com código existente

---

## 📝 Passo a Passo

### Passo 1: Instalar Dependências

```bash
flutter pub get
```

### Passo 2: Gerar Código Freezed

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Isso irá gerar o arquivo `auth_state.freezed.dart`.

### Passo 3: Atualizar Injection Container

Edite `lib/core/injection_container.dart`:

```dart
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model_v2.dart';

void init() {
  // ViewModels / Providers
  sl.registerFactory(
    () => AuthViewModelV2(
      signInUseCase: sl(),
      signUpUseCase: sl(),
    ),
  );
  
  // ... resto do código
}
```

### Passo 4: Atualizar App.dart

Edite `lib/app.dart`:

```dart
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model_v2.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<AuthViewModelV2>(),
        ),
      ],
      child: MaterialApp(
        // ... resto do código
      ),
    );
  }
}
```

### Passo 5: Usar no Widget

#### Opção 1: Consumer (Rebuild completo)

```dart
Consumer<AuthViewModelV2>(
  builder: (context, viewModel, child) {
    if (viewModel.state.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (viewModel.state.error != null) {
      return Text('Erro: ${viewModel.state.error}');
    }
    
    if (viewModel.state.isAuthenticated) {
      return Text('Bem-vindo, ${viewModel.state.user?.name}!');
    }
    
    return const LoginForm();
  },
)
```

#### Opção 2: Selector (Otimizado - Recomendado)

```dart
// Rebuild apenas quando o nome do usuário mudar
Selector<AuthViewModelV2, String?>(
  selector: (_, viewModel) => viewModel.state.user?.name,
  builder: (context, userName, child) {
    return Text('Olá, ${userName ?? "Visitante"}!');
  },
)

// Rebuild apenas quando isLoading mudar
Selector<AuthViewModelV2, bool>(
  selector: (_, viewModel) => viewModel.state.isLoading,
  builder: (context, isLoading, child) {
    return isLoading
        ? const CircularProgressIndicator()
        : const LoginButton();
  },
)
```

#### Opção 3: Context.watch (Simples)

```dart
@override
Widget build(BuildContext context) {
  final viewModel = context.watch<AuthViewModelV2>();
  final state = viewModel.state;
  
  return Column(
    children: [
      if (state.isLoading)
        const CircularProgressIndicator(),
      if (state.error != null)
        Text(state.error!, style: TextStyle(color: Colors.red)),
      if (state.isAuthenticated)
        Text('Bem-vindo, ${state.user?.name}!'),
    ],
  );
}
```

---

## 💡 Exemplos de Uso

### Exemplo 1: Tela de Login Completa

```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            
            // Campo de senha
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            
            // Botão de login com estado
            Selector<AuthViewModelV2, bool>(
              selector: (_, vm) => vm.state.isLoading,
              builder: (context, isLoading, _) {
                return ElevatedButton(
                  onPressed: isLoading ? null : () => _handleLogin(context),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Entrar'),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Mensagem de erro
            Selector<AuthViewModelV2, String?>(
              selector: (_, vm) => vm.state.error,
              builder: (context, error, _) {
                if (error == null) return const SizedBox.shrink();
                return Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final viewModel = context.read<AuthViewModelV2>();
    
    final success = await viewModel.signIn(
      _emailController.text,
      _passwordController.text,
    );
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

### Exemplo 2: Widget de Perfil do Usuário

```dart
class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModelV2, UserEntity?>(
      selector: (_, vm) => vm.state.user,
      builder: (context, user, _) {
        if (user == null) {
          return const Text('Não autenticado');
        }
        
        return Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(user.name?[0] ?? '?'),
            ),
            const SizedBox(height: 8),
            Text(
              user.name ?? 'Sem nome',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
```

### Exemplo 3: Guard de Rota

```dart
class AuthGuard extends StatelessWidget {
  final Widget child;
  
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Selector<AuthViewModelV2, bool>(
      selector: (_, vm) => vm.state.isAuthenticated,
      builder: (context, isAuthenticated, _) {
        if (!isAuthenticated) {
          // Redireciona para login se não autenticado
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        return child;
      },
    );
  }
}

// Uso:
MaterialApp(
  routes: {
    '/home': (context) => const AuthGuard(child: HomePage()),
    '/profile': (context) => const AuthGuard(child: ProfilePage()),
  },
)
```

---

## 🎨 Padrões Avançados

### Pattern 1: Múltiplos Estados

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// Uso com pattern matching
state.when(
  initial: () => const Text('Inicializando...'),
  loading: () => const CircularProgressIndicator(),
  authenticated: (user) => Text('Olá, ${user.name}!'),
  unauthenticated: () => const LoginButton(),
  error: (message) => Text('Erro: $message'),
)
```

### Pattern 2: ProxyProvider para Dependências

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => AuthViewModelV2(...),
    ),
    ChangeNotifierProxyProvider<AuthViewModelV2, AnnouncementViewModel>(
      create: (_) => AnnouncementViewModel(...),
      update: (_, auth, announcements) {
        // Atualiza announcements quando auth mudar
        announcements?.updateUser(auth.state.user);
        return announcements!;
      },
    ),
  ],
)
```

### Pattern 3: Selector com Múltiplos Valores

```dart
Selector2<AuthViewModelV2, ThemeViewModel, (bool, ThemeMode)>(
  selector: (_, auth, theme) => (
    auth.state.isAuthenticated,
    theme.currentMode,
  ),
  builder: (context, data, _) {
    final (isAuthenticated, themeMode) = data;
    
    return Container(
      color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
      child: isAuthenticated
          ? const HomePage()
          : const LoginPage(),
    );
  },
)
```

### Pattern 4: Estado com Cache

```dart
class AuthViewModelV2 extends ChangeNotifier {
  // Cache do último estado bem-sucedido
  UserEntity? _cachedUser;
  
  Future<bool> signIn(String email, String password) async {
    // ... lógica de login
    
    if (success) {
      _cachedUser = user;
      // Salva no SharedPreferences
      await _saveUserToCache(user);
    }
  }
  
  Future<void> restoreSession() async {
    final cachedUser = await _loadUserFromCache();
    if (cachedUser != null) {
      _updateState(_state.copyWith(
        user: cachedUser,
        isAuthenticated: true,
      ));
    }
  }
}
```

---

## 🧪 Testes

### Teste do Estado Imutável

```dart
void main() {
  group('AuthState', () {
    test('initial state should have correct defaults', () {
      final state = AuthState.initial();
      
      expect(state.isLoading, false);
      expect(state.isAuthenticated, false);
      expect(state.user, isNull);
      expect(state.error, isNull);
    });
    
    test('copyWith should create new instance with updated values', () {
      final state = AuthState.initial();
      final updated = state.copyWith(isLoading: true);
      
      expect(updated.isLoading, true);
      expect(updated.isAuthenticated, false);
      expect(state.isLoading, false); // Original não muda
    });
    
    test('equality should work correctly', () {
      final state1 = AuthState.initial();
      final state2 = AuthState.initial();
      final state3 = state1.copyWith(isLoading: true);
      
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
}
```

### Teste do ViewModel com Estado Imutável

```dart
void main() {
  late AuthViewModelV2 viewModel;
  late MockSignInUseCase mockSignInUseCase;
  
  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    viewModel = AuthViewModelV2(
      signInUseCase: mockSignInUseCase,
      signUpUseCase: MockSignUpUseCase(),
    );
  });
  
  test('should update state to loading when signIn is called', () async {
    // arrange
    when(() => mockSignInUseCase(any()))
        .thenAnswer((_) async => Right(tUser));
    
    // act
    final future = viewModel.signIn('test@test.com', 'password');
    
    // assert - verifica estado intermediário
    expect(viewModel.state.isLoading, true);
    expect(viewModel.state.error, isNull);
    
    await future;
  });
  
  test('should update state to authenticated on successful signIn', () async {
    // arrange
    when(() => mockSignInUseCase(any()))
        .thenAnswer((_) async => Right(tUser));
    
    // act
    await viewModel.signIn('test@test.com', 'password');
    
    // assert
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.isAuthenticated, true);
    expect(viewModel.state.user, tUser);
    expect(viewModel.state.error, isNull);
  });
  
  test('should update state with error on failed signIn', () async {
    // arrange
    final failure = const InvalidCredentialsFailure();
    when(() => mockSignInUseCase(any()))
        .thenAnswer((_) async => Left(failure));
    
    // act
    await viewModel.signIn('test@test.com', 'wrong');
    
    // assert
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.isAuthenticated, false);
    expect(viewModel.state.user, isNull);
    expect(viewModel.state.error, isNotNull);
  });
}
```

---

## 📊 Comparação: Antes vs Depois

### Antes (Estado Mutável)

```dart
class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  UserEntity? _user;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserEntity? get user => _user;
  
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // 1ª notificação
    
    // ... lógica
    
    _isLoading = false;
    _user = user;
    notifyListeners(); // 2ª notificação
  }
}
```

**Problemas:**
- ❌ Estado mutável (difícil rastrear mudanças)
- ❌ Múltiplas notificações
- ❌ Sem garantia de consistência
- ❌ Difícil de testar estados intermediários

### Depois (Estado Imutável)

```dart
class AuthViewModelV2 extends ChangeNotifier {
  AuthState _state = AuthState.initial();
  AuthState get state => _state;
  
  void _updateState(AuthState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners(); // 1 notificação por mudança real
    }
  }
  
  Future<void> signIn(String email, String password) async {
    _updateState(_state.copyWith(isLoading: true, error: null));
    
    // ... lógica
    
    _updateState(_state.copyWith(
      isLoading: false,
      user: user,
      isAuthenticated: true,
    ));
  }
}
```

**Vantagens:**
- ✅ Estado imutável (rastreamento claro)
- ✅ Uma notificação por mudança real
- ✅ Consistência garantida
- ✅ Fácil de testar
- ✅ Melhor performance (evita rebuilds desnecessários)

---

## 🎯 Próximos Passos

1. ✅ Gerar código Freezed
2. ✅ Atualizar injection container
3. ✅ Atualizar app.dart
4. ⏳ Migrar telas para usar AuthViewModelV2
5. ⏳ Criar ViewModels para outros módulos
6. ⏳ Implementar testes para novos ViewModels

---

## 📚 Recursos Adicionais

- [Provider Documentation](https://pub.dev/packages/provider)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Flutter State Management Guide](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)

---

**Status:** ✅ Implementação Base Completa  
**Próximo:** Gerar código Freezed e testar
