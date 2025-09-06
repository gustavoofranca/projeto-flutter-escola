Sistema Escolar - Projeto em Desenvolvimento

Este projeto é um sistema voltado para instituições de ensino, com o objetivo de oferecer uma plataforma integrada tanto para alunos quanto para professores.

Funcionalidades Planejadas

Área do Aluno e do Professor: Interfaces distintas para alunos e professores, com funcionalidades específicas.

Quadro de Avisos: Visualização e cadastro de avisos importantes.

Notas e Disciplinas: Consulta e lançamento de notas, visualização de matérias cursadas.

Horários de Aula: Visualização dos horários organizados por dia e disciplina.

Cadastro de Alunos: Inclusão de novos alunos com suas informações pessoais.

Telas Implementadas até o Momento

Home: Exibe informações gerais sobre o sistema ou o usuário.

Turmas: Mostra as turmas vinculadas ao aluno.

Mensagens: Tela que será futuramente adaptada para exibir os avisos (em vez de um sistema de chat completo, que seria mais complexo).

Calendário: Exibe eventos e reuniões escolares.

Perfil: Mostra as informações pessoais do usuário.

API utilizada no projeto: Google Books API, disponibiliza download de livros e visualização de prévias, exemplos de funcionamento na página Materiais.

Atomic Design: Pode ser encontrado no main.dart e nas paginas do projeto.
Átomos: elementos básicos da interface, como AppColors.background, textos (Text) e ícones (Icon(Icons.school)).

Moléculas: combinações simples de átomos, como botões estilizados (ElevatedButtonThemeData), containers com ícones e blocos de texto com espaçamento.

Organismos: composições mais complexas, como a coluna central do SplashScreen, o Consumer<AuthProvider> no AppInitializer e Scaffold completos.

Templates: estruturas de layout, como MaterialApp, Scaffold e a lógica condicional do AppInitializer.

Páginas: instâncias concretas, como AuthScreen, HomeScreen e SplashScreen.
