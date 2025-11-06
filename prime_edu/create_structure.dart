import 'dart:io';

void main() {
  // Diretório base
  final libDir = Directory('lib');
  
  // Estrutura de pastas
  final structure = [
    // Core
    'core/constants',
    'core/errors',
    'core/network',
    'core/utils',
    'core/widgets',
    
    // Features
    'features/auth/data/datasources',
    'features/auth/data/models',
    'features/auth/data/repositories',
    'features/auth/domain/entities',
    'features/auth/domain/repositories',
    'features/auth/domain/usecases',
    'features/auth/presentation/pages',
    'features/auth/presentation/providers',
    'features/auth/presentation/widgets',
    
    'features/announcements/data/datasources',
    'features/announcements/data/models',
    'features/announcements/data/repositories',
    'features/announcements/domain/entities',
    'features/announcements/domain/repositories',
    'features/announcements/domain/usecases',
    'features/announcements/presentation/pages',
    'features/announcements/presentation/providers',
    'features/announcements/presentation/widgets',
    
    'features/home/data/datasources',
    'features/home/data/models',
    'features/home/data/repositories',
    'features/home/domain/entities',
    'features/home/domain/repositories',
    'features/home/domain/usecases',
    'features/home/presentation/pages',
    'features/home/presentation/providers',
    'features/home/presentation/widgets',
  ];

  // Criar diretórios
  for (final dir in structure) {
    final directory = Directory('${libDir.path}/$dir');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('Criado: ${directory.path}');
      
      // Adicionar arquivo .gitkeep em pastas vazias
      File('${directory.path}/.gitkeep').createSync();
    } else {
      print('Já existe: ${directory.path}');
    }
  }
  
  print('\nEstrutura de pastas criada com sucesso!');
}
