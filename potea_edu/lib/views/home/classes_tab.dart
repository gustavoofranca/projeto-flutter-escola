import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/info_card.dart';
import '../../components/molecules/section_title.dart';

class ClassesTab extends StatefulWidget {
  const ClassesTab({super.key});

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {
  final List<ClassModel> _classes = [];
  final List<SubjectModel> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      final user = context.read<AuthProvider>().currentUser;
      
      if (user != null) {
        if (user.userType == UserType.student) {
          _loadStudentClasses(user);
        } else if (user.userType == UserType.teacher) {
          _loadTeacherClasses(user);
        } else {
          _loadAdminClasses();
        }
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadStudentClasses(UserModel user) {
    // Mock student classes
    _classes.addAll([
      ClassModel(
        id: '1',
        name: '3º Ano A',
        description: 'Turma do Ensino Médio',
        studentCount: 28,
        teacherId: 'prof1',
        teacherName: 'Prof. Ana Silva',
        room: 'Sala 301',
        schedule: 'Segunda a Sexta - 07:00 às 12:00',
        subjects: ['Matemática', 'Física', 'Química', 'Português', 'História'],
      ),
    ]);

    _subjects.addAll([
      SubjectModel(
        id: '1',
        name: 'Matemática',
        teacher: 'Prof. Ana Silva',
        schedule: 'Segunda e Quarta - 07:00',
        room: 'Sala 301',
        nextClass: 'Equações do 2º Grau',
        grade: 8.5,
      ),
      SubjectModel(
        id: '2',
        name: 'Física',
        teacher: 'Prof. Carlos Santos',
        schedule: 'Terça e Quinta - 08:00',
        room: 'Lab. Física',
        nextClass: 'Movimento Retilíneo',
        grade: 7.8,
      ),
      SubjectModel(
        id: '3',
        name: 'Química',
        teacher: 'Prof. Maria Costa',
        schedule: 'Sexta - 09:00',
        room: 'Lab. Química',
        nextClass: 'Tabela Periódica',
        grade: 9.0,
      ),
    ]);
  }

  void _loadTeacherClasses(UserModel user) {
    // Mock teacher classes
    _classes.addAll([
      ClassModel(
        id: '1',
        name: '3º Ano A',
        description: 'Turma do Ensino Médio - Matemática',
        studentCount: 28,
        teacherId: user.id,
        teacherName: user.name,
        room: 'Sala 301',
        schedule: 'Segunda e Quarta - 07:00',
        subjects: ['Matemática'],
      ),
      ClassModel(
        id: '2',
        name: '3º Ano B',
        description: 'Turma do Ensino Médio - Matemática',
        studentCount: 25,
        teacherId: user.id,
        teacherName: user.name,
        room: 'Sala 302',
        schedule: 'Terça e Quinta - 08:00',
        subjects: ['Matemática'],
      ),
      ClassModel(
        id: '3',
        name: '2º Ano A',
        description: 'Turma do Ensino Médio - Física',
        studentCount: 30,
        teacherId: user.id,
        teacherName: user.name,
        room: 'Lab. Física',
        schedule: 'Sexta - 09:00',
        subjects: ['Física'],
      ),
    ]);
  }

  void _loadAdminClasses() {
    // Mock all classes for admin
    _classes.addAll([
      ClassModel(
        id: '1',
        name: '3º Ano A',
        description: 'Turma do Ensino Médio',
        studentCount: 28,
        teacherId: 'prof1',
        teacherName: 'Prof. Ana Silva',
        room: 'Sala 301',
        schedule: 'Segunda a Sexta - 07:00 às 12:00',
        subjects: ['Matemática', 'Física', 'Química'],
      ),
      ClassModel(
        id: '2',
        name: '3º Ano B',
        description: 'Turma do Ensino Médio',
        studentCount: 25,
        teacherId: 'prof2',
        teacherName: 'Prof. Carlos Santos',
        room: 'Sala 302',
        schedule: 'Segunda a Sexta - 07:00 às 12:00',
        subjects: ['História', 'Geografia', 'Português'],
      ),
      ClassModel(
        id: '3',
        name: '2º Ano A',
        description: 'Turma do Ensino Médio',
        studentCount: 30,
        teacherId: 'prof3',
        teacherName: 'Prof. Maria Costa',
        room: 'Sala 201',
        schedule: 'Segunda a Sexta - 13:00 às 18:00',
        subjects: ['Biologia', 'Química'],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: CustomTypography.h5(
                text: user?.userType == UserType.student 
                    ? 'Minhas Turmas' 
                    : user?.userType == UserType.teacher 
                        ? 'Turmas que Leciono'
                        : 'Todas as Turmas',
                color: AppColors.textPrimary,
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (user?.userType == UserType.student) ..._buildStudentView()
                  else if (user?.userType == UserType.teacher) ..._buildTeacherView()
                  else ..._buildAdminView(),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildStudentView() {
    return [
      const SectionTitle(
        title: 'Suas Matérias',
        subtitle: 'Acompanhe o progresso em cada disciplina',
      ),
      
      const SizedBox(height: AppDimensions.lg),
      
      ..._subjects.map((subject) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: _buildSubjectCard(subject),
      )),
      
      const SizedBox(height: AppDimensions.xl),
      
      const SectionTitle(
        title: 'Informações da Turma',
        subtitle: 'Detalhes da sua turma atual',
      ),
      
      const SizedBox(height: AppDimensions.lg),
      
      if (_classes.isNotEmpty) _buildClassInfoCard(_classes.first),
    ];
  }

  List<Widget> _buildTeacherView() {
    return [
      const SectionTitle(
        title: 'Suas Turmas',
        subtitle: 'Gerencie as turmas que você leciona',
      ),
      
      const SizedBox(height: AppDimensions.lg),
      
      ..._classes.map((classItem) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: _buildTeacherClassCard(classItem),
      )),
    ];
  }

  List<Widget> _buildAdminView() {
    return [
      const SectionTitle(
        title: 'Gestão de Turmas',
        subtitle: 'Visualize e gerencie todas as turmas da escola',
      ),
      
      const SizedBox(height: AppDimensions.lg),
      
      // Quick Stats
      Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Turmas',
              _classes.length.toString(),
              Icons.class_,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: _buildStatCard(
              'Total Alunos',
              _classes.fold(0, (sum, c) => sum + c.studentCount).toString(),
              Icons.people,
              AppColors.secondary,
            ),
          ),
        ],
      ),
      
      const SizedBox(height: AppDimensions.xl),
      
      ..._classes.map((classItem) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: _buildAdminClassCard(classItem),
      )),
    ];
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    Color gradeColor = subject.grade >= 8.0 
        ? AppColors.success
        : subject.grade >= 6.0 
            ? AppColors.warning
            : AppColors.error;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Icon(
                    _getSubjectIcon(subject.name),
                    color: AppColors.primary,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTypography.h6(
                        text: subject.name,
                        color: AppColors.textPrimary,
                      ),
                      CustomTypography.bodyMedium(
                        text: subject.teacher,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.sm,
                  ),
                  decoration: BoxDecoration(
                    color: gradeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: CustomTypography.bodyMedium(
                    text: subject.grade.toString(),
                    color: gradeColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.md),
            
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.xs),
                CustomTypography.bodySmall(
                  text: subject.schedule,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.lg),
                Icon(
                  Icons.location_on,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.xs),
                CustomTypography.bodySmall(
                  text: subject.room,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.sm),
            
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.book,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: CustomTypography.bodyMedium(
                      text: 'Próxima aula: ${subject.nextClass}',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassInfoCard(ClassModel classItem) {
    return InfoCard(
      title: classItem.name,
      description: classItem.description,
      subtitle: '${classItem.studentCount} alunos • ${classItem.room}',
      icon: Icons.class_,
      iconColor: AppColors.primary,
      onTap: () {
        // Navigate to class details
      },
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTypography.bodySmall(
            text: 'Professor',
            color: AppColors.textSecondary,
          ),
          CustomTypography.bodyMedium(
            text: classItem.teacherName.split(' ').last,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherClassCard(ClassModel classItem) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: const Icon(
                    Icons.class_,
                    color: AppColors.primary,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTypography.h6(
                        text: classItem.name,
                        color: AppColors.textPrimary,
                      ),
                      CustomTypography.bodyMedium(
                        text: '${classItem.studentCount} alunos',
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to class management
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconSizeSm,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.md),
            
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.xs),
                CustomTypography.bodySmall(
                  text: classItem.schedule,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.sm),
            
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: AppDimensions.iconSizeSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.xs),
                CustomTypography.bodySmall(
                  text: classItem.room,
                  color: AppColors.textSecondary,
                ),
                const Spacer(),
                Wrap(
                  spacing: AppDimensions.xs,
                  children: classItem.subjects.take(2).map((subject) => 
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      child: CustomTypography.caption(
                        text: subject,
                        color: AppColors.secondary,
                      ),
                    ),
                  ).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminClassCard(ClassModel classItem) {
    return InfoCard(
      title: classItem.name,
      description: '${classItem.studentCount} alunos • Professor: ${classItem.teacherName}',
      subtitle: '${classItem.room} • ${classItem.schedule}',
      icon: Icons.school,
      iconColor: AppColors.primary,
      onTap: () {
        // Navigate to class management
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppDimensions.iconSizeMd),
              const Spacer(),
              CustomTypography.h4(
                text: value,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          CustomTypography.bodyMedium(
            text: title,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'matemática':
        return Icons.calculate;
      case 'física':
        return Icons.science;
      case 'química':
        return Icons.biotech;
      case 'português':
        return Icons.menu_book;
      case 'história':
        return Icons.history_edu;
      case 'geografia':
        return Icons.public;
      case 'biologia':
        return Icons.eco;
      default:
        return Icons.book;
    }
  }
}

// Data Models
class ClassModel {
  final String id;
  final String name;
  final String description;
  final int studentCount;
  final String teacherId;
  final String teacherName;
  final String room;
  final String schedule;
  final List<String> subjects;

  ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.studentCount,
    required this.teacherId,
    required this.teacherName,
    required this.room,
    required this.schedule,
    required this.subjects,
  });
}

class SubjectModel {
  final String id;
  final String name;
  final String teacher;
  final String schedule;
  final String room;
  final String nextClass;
  final double grade;

  SubjectModel({
    required this.id,
    required this.name,
    required this.teacher,
    required this.schedule,
    required this.room,
    required this.nextClass,
    required this.grade,
  });
}

