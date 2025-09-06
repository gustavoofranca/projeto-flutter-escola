import 'package:flutter/material.dart';
import 'package:potea_edu/constants/app_colors.dart';
import 'package:potea_edu/constants/app_dimensions.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/section_title.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  final List<EventModel> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock events based on user type
    _events.addAll([
      EventModel(
        id: '1',
        title: 'Prova de Matemática',
        description: 'Avaliação sobre Equações do 2º Grau',
        date: DateTime.now().add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        type: EventType.exam,
        location: 'Sala 301',
        isAllDay: false,
      ),
      EventModel(
        id: '2',
        title: 'Reunião de Pais',
        description: 'Reunião para discussão do desempenho dos alunos',
        date: DateTime.now().add(const Duration(days: 7)),
        startTime: const TimeOfDay(hour: 19, minute: 0),
        endTime: const TimeOfDay(hour: 21, minute: 0),
        type: EventType.meeting,
        location: 'Auditório',
        isAllDay: false,
      ),
      EventModel(
        id: '3',
        title: 'Feriado Nacional',
        description: 'Independência do Brasil',
        date: DateTime.now().add(const Duration(days: 10)),
        startTime: const TimeOfDay(hour: 0, minute: 0),
        endTime: const TimeOfDay(hour: 23, minute: 59),
        type: EventType.holiday,
        location: '',
        isAllDay: true,
      ),
      EventModel(
        id: '4',
        title: 'Aula de Campo - Biologia',
        description: 'Visita ao Jardim Botânico para estudos de ecossistemas',
        date: DateTime.now().add(const Duration(days: 14)),
        startTime: const TimeOfDay(hour: 7, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        type: EventType.fieldTrip,
        location: 'Jardim Botânico',
        isAllDay: false,
      ),
      EventModel(
        id: '5',
        title: 'Projeto de Ciências',
        description: 'Apresentação dos projetos de feira de ciências',
        date: DateTime.now().add(const Duration(days: 21)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        type: EventType.presentation,
        location: 'Laboratório',
        isAllDay: false,
      ),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              title: const CustomTypography.h5(
                text: 'Calendário Acadêmico',
                color: AppColors.textPrimary,
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
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
                  _buildCalendarCard(),
                  
                  const SizedBox(height: AppDimensions.xl),
                  
                  const SectionTitle(
                    title: 'Próximos Eventos',
                    subtitle: 'Acompanhe suas atividades acadêmicas',
                  ),
                  
                  const SizedBox(height: AppDimensions.lg),
                  
                  ..._getUpcomingEvents().map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: _buildEventCard(event),
                  )),
                  
                  if (_getUpcomingEvents().isEmpty)
                    _buildEmptyState(),
                  
                  const SizedBox(height: AppDimensions.xl),
                  
                  _buildQuickActions(),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          // Month navigation
          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: CustomTypography.h6(
                    text: _getMonthYearText(_currentMonth),
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            child: Row(
              children: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb']
                  .map((day) => Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
                          child: CustomTypography.bodySmall(
                            text: day,
                            color: AppColors.textSecondary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // Calendar grid
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md,
            ),
            child: _buildCalendarGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startDay = firstDayOfMonth.weekday % 7;
    
    final List<Widget> dayWidgets = [];
    
    // Empty cells for days before first day
    for (int i = 0; i < startDay; i++) {
      dayWidgets.add(const SizedBox());
    }
    
    // Days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final hasEvents = _events.any((event) => _isSameDay(event.date, date));
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: hasEvents
                  ? Border.all(color: AppColors.secondary, width: 1)
                  : null,
            ),
            child: Center(
              child: CustomTypography.bodyMedium(
                text: day.toString(),
                color: isSelected
                    ? AppColors.background
                    : isToday
                        ? AppColors.primary
                        : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildEventCard(EventModel event) {
    final eventColor = _getEventColor(event.type);
    final eventIcon = _getEventIcon(event.type);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border(left: BorderSide(color: eventColor, width: 4)),
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
                    color: eventColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Icon(
                    eventIcon,
                    color: eventColor,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTypography.h6(
                        text: event.title,
                        color: AppColors.textPrimary,
                      ),
                      if (event.description.isNotEmpty)
                        CustomTypography.bodySmall(
                          text: event.description,
                          color: AppColors.textSecondary,
                          maxLines: 2,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xs,
                  ),
                  decoration: BoxDecoration(
                    color: eventColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: CustomTypography.caption(
                    text: _formatDate(event.date),
                    color: eventColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.md),
            
            Row(
              children: [
                if (!event.isAllDay) ...[
                  Icon(
                    Icons.access_time,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  CustomTypography.bodySmall(
                    text: '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                    color: AppColors.textSecondary,
                  ),
                ] else ...[
                  Icon(
                    Icons.event,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  CustomTypography.bodySmall(
                    text: 'Dia inteiro',
                    color: AppColors.textSecondary,
                  ),
                ],
                
                if (event.location.isNotEmpty) ...[
                  const SizedBox(width: AppDimensions.lg),
                  Icon(
                    Icons.location_on,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  CustomTypography.bodySmall(
                    text: event.location,
                    color: AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppDimensions.lg),
          CustomTypography.h6(
            text: 'Nenhum evento próximo',
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.sm),
          CustomTypography.bodyMedium(
            text: 'Você está livre nos próximos dias!',
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Ações Rápidas',
          subtitle: 'Gerencie seu calendário',
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Ver Todos\nEventos',
                Icons.calendar_view_month,
                AppColors.primary,
                () {
                  // Navigate to full calendar view
                },
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: _buildActionCard(
                'Adicionar\nEvento',
                Icons.add_circle,
                AppColors.secondary,
                () {
                  // Show add event dialog
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: AppDimensions.iconSizeLg,
            ),
            const SizedBox(height: AppDimensions.sm),
            CustomTypography.bodyMedium(
              text: title,
              color: color,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<EventModel> _getUpcomingEvents() {
    final now = DateTime.now();
    return _events
        .where((event) => event.date.isAfter(now) || _isSameDay(event.date, now))
        .take(5)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(date.year, date.month, date.day);
    
    final difference = eventDate.difference(today).inDays;
    
    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Amanhã';
    } else if (difference < 7) {
      return '$difference dias';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.exam:
        return AppColors.error;
      case EventType.meeting:
        return AppColors.info;
      case EventType.holiday:
        return AppColors.warning;
      case EventType.fieldTrip:
        return AppColors.success;
      case EventType.presentation:
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.exam:
        return Icons.quiz;
      case EventType.meeting:
        return Icons.people;
      case EventType.holiday:
        return Icons.celebration;
      case EventType.fieldTrip:
        return Icons.directions_bus;
      case EventType.presentation:
        return Icons.present_to_all;
      default:
        return Icons.event;
    }
  }
}

// Data Models
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final EventType type;
  final String location;
  final bool isAllDay;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.location,
    required this.isAllDay,
  });
}

enum EventType {
  exam,
  meeting,
  holiday,
  fieldTrip,
  presentation,
  other,
}

