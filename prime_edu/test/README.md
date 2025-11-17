# Testes do Prime Edu

Este diretório contém todos os testes automatizados do projeto Prime Edu, organizados por tipo e funcionalidade.

## 📁 Estrutura de Testes

```
test/
├── features/                    # Testes organizados por feature (Clean Architecture)
│   ├── auth/                   # Testes de autenticação
│   │   ├── data/              # Testes da camada de dados
│   │   │   └── repositories/  # Testes de repositórios
│   │   ├── domain/            # Testes da camada de domínio
│   │   │   └── usecases/     # Testes de casos de uso
│   │   └── presentation/      # Testes da camada de apresentação
│   │       └── providers/    # Testes de ViewModels
│   └── announcements/         # Testes de anúncios
│       ├── data/
│       │   └── repositories/
│       └── presentation/
│           └── providers/
├── integration/                # Testes de integração
│   ├── auth_flow_integration_test.dart
│   └── announcement_flow_integration_test.dart
├── mocks/                      # Mocks reutilizáveis
│   ├── mock_auth_provider.dart
│   └── mock_announcement_service.dart
├── unit/                       # Testes unitários legados
│   ├── announcement_model_test.dart
│   └── announcement_provider_test.dart
├── widgets/                    # Testes de widgets
│   ├── announcements_screen_test.dart
│   └── auth_text_field_test.dart
└── widget_test.dart           # Teste principal do App
```

## 🧪 Tipos de Testes

### 1. Testes Unitários

Testam unidades isoladas de código (classes, funções, métodos).

**Localização:**
- `test/features/*/domain/usecases/` - Use Cases
- `test/features/*/presentation/providers/` - ViewModels
- `test/features/*/data/repositories/` - Repositories
- `test/unit/` - Testes unitários legados

**Exemplos:**
- `auth_view_model_test.dart` - Testa o ViewModel de autenticação básico
- `auth_view_model_v2_test.dart` - Testa o ViewModel com estado imutável
- `auth_repository_impl_test.dart` - Testa o repositório de autenticação
- `announcement_view_model_test.dart` - Testa o ViewModel de anúncios

### 2. Testes de Widget

Testam componentes de UI isoladamente.

**Localização:** `test/widgets/`

**Exemplos:**
- `auth_text_field_test.dart` - Testa o campo de texto customizado
- `announcements_screen_test.dart` - Testa a tela de anúncios

### 3. Testes de Integração

Testam o fluxo completo entre múltiplas camadas.

**Localização:** `test/integration/`

**Exemplos:**
- `auth_flow_integration_test.dart` - Testa fluxo completo de autenticação
- `announcement_flow_integration_test.dart` - Testa fluxo completo de anúncios

## 🚀 Executando os Testes

### Todos os testes
```bash
flutter test
```

### Testes com cobertura
```bash
flutter test --coverage
```

### Testes específicos por arquivo
```bash
flutter test test/features/auth/presentation/providers/auth_view_model_v2_test.dart
```

### Testes por padrão
```bash
# Apenas testes de auth
flutter test test/features/auth/

# Apenas testes unitários
flutter test test/unit/

# Apenas testes de widget
flutter test test/widgets/

# Apenas testes de integração
flutter test test/integration/
```

### Modo watch (re-executa ao salvar)
```bash
flutter test --watch
```

## 📊 Cobertura de Testes

### Auth (Autenticação)
- ✅ **ViewModels**: AuthViewModel, AuthViewModelV2
- ✅ **Use Cases**: SignIn, SignUp
- ✅ **Repository**: AuthRepositoryImpl
- ✅ **Widgets**: AuthTextField
- ✅ **Integração**: Fluxo completo de login/cadastro

### Announcements (Anúncios)
- ✅ **ViewModels**: AnnouncementViewModel
- ✅ **Models**: AnnouncementModel
- ✅ **Providers**: AnnouncementProvider (legado)
- ✅ **Repository**: AnnouncementRepositoryImpl
- ✅ **Widgets**: AnnouncementsScreen
- ✅ **Integração**: Fluxo CRUD completo

## 🛠️ Ferramentas Utilizadas

- **flutter_test**: Framework de testes do Flutter
- **mocktail**: Biblioteca de mocking
- **dartz**: Programação funcional (Either, Left, Right)
- **freezed**: Estados imutáveis

## 📝 Convenções de Nomenclatura

### Arquivos de Teste
- Sufixo `_test.dart` para todos os arquivos de teste
- Nome igual ao arquivo sendo testado: `auth_view_model.dart` → `auth_view_model_test.dart`

### Estrutura de Testes
```dart
void main() {
  group('Nome do Grupo', () {
    late ClasseTestada instancia;
    
    setUp(() {
      // Configuração antes de cada teste
    });
    
    tearDown(() {
      // Limpeza após cada teste
    });
    
    test('deve fazer algo específico', () {
      // arrange - preparação
      // act - ação
      // assert - verificação
    });
  });
}
```

### Nomenclatura de Testes
- Use português para descrições
- Seja específico e descritivo
- Formato: "deve [ação] quando [condição]"
- Exemplos:
  - ✅ "deve retornar UserEntity quando o login for bem-sucedido"
  - ✅ "deve atualizar estado com erro quando o cadastro falhar"
  - ❌ "teste de login"
  - ❌ "funciona"

## 🎯 Boas Práticas

### 1. Isolamento
- Cada teste deve ser independente
- Use `setUp()` e `tearDown()` para preparação e limpeza
- Não compartilhe estado entre testes

### 2. Mocking
- Mock apenas dependências externas
- Use `when()` para configurar comportamento
- Use `verify()` para verificar chamadas

### 3. Arrange-Act-Assert (AAA)
```dart
test('exemplo', () {
  // Arrange - Preparação
  final input = 'test';
  
  // Act - Ação
  final result = funcao(input);
  
  // Assert - Verificação
  expect(result, expected);
});
```

### 4. Cobertura
- Teste casos de sucesso
- Teste casos de erro
- Teste casos extremos (edge cases)
- Teste validações

### 5. Performance
- Testes devem ser rápidos
- Evite delays desnecessários
- Use `pumpAndSettle()` com cuidado em testes de widget

## 🐛 Debugging de Testes

### Executar um único teste
```dart
test('nome do teste', () {
  // ...
}, skip: false); // ou remova outros testes temporariamente
```

### Ver output detalhado
```bash
flutter test --verbose
```

### Debugar no VS Code
1. Adicione breakpoint no teste
2. Use "Debug Test" no CodeLens
3. Ou pressione F5 com o teste aberto

## 📈 Métricas de Qualidade

### Objetivos de Cobertura
- **Mínimo**: 70% de cobertura geral
- **Ideal**: 80%+ de cobertura
- **Crítico**: 90%+ para lógica de negócio

### Áreas Prioritárias
1. **Alta prioridade**: Use Cases, ViewModels, Repositories
2. **Média prioridade**: Widgets complexos, Services
3. **Baixa prioridade**: Widgets simples, Constants

## 🔄 CI/CD

Os testes são executados automaticamente em:
- Pull Requests
- Commits na branch main
- Builds de produção

### Pipeline de Testes
1. Análise estática (`flutter analyze`)
2. Testes unitários
3. Testes de widget
4. Testes de integração
5. Relatório de cobertura

## 📚 Recursos Adicionais

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [Testing Best Practices](https://docs.flutter.dev/testing/best-practices)

## 🤝 Contribuindo

Ao adicionar novos testes:

1. ✅ Siga a estrutura de pastas existente
2. ✅ Use as convenções de nomenclatura
3. ✅ Documente testes complexos
4. ✅ Mantenha alta cobertura
5. ✅ Execute todos os testes antes de commitar

```bash
# Antes de commitar
flutter test
flutter analyze
```

## 📞 Suporte

Para dúvidas sobre testes:
1. Consulte este README
2. Veja exemplos nos arquivos de teste existentes
3. Consulte a documentação oficial do Flutter
