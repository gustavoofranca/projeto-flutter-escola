import 'package:flutter/material.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import 'package:provider/provider.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/section_title.dart';
import '../../models/event_model.dart';
import '../../providers/calendar_provider.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);
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
                child: CircularProgressIndicator(color: AppColors.primary),
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

                  ...context.watch<CalendarProvider>().upcomingEvents().map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.md),
                      child: _buildEventCard(event),
                    ),
                  ),

                  if (context.watch<CalendarProvider>().upcomingEvents().isEmpty) _buildEmptyState(),

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
                  .map(
                    (day) => Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.sm,
                        ),
                        child: CustomTypography.bodySmall(
                          text: day,
                          color: AppColors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
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
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final startDay = firstDayOfMonth.weekday % 7;

    final List<Widget> dayWidgets = [];

    // Empty cells for days before first day
    for (int i = 0; i < startDay; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final hasEvents = context.read<CalendarProvider>().eventsForDate(date).isNotEmpty;
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());

      dayWidgets.add(
        GestureDetector(
          onTap: () async {
            setState(() => _selectedDate = date);
            await _openEventsForDay(context, date);
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
                    text:
                        '${event.startTime.format(context)} - ${event.endTime.format(context)}',
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
            const SizedBox(height: AppDimensions.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _editEvent(context, event),
                  icon: const Icon(Icons.edit, size: 16, color: AppColors.info),
                  label: const CustomTypography.caption(text: 'Editar', color: AppColors.info),
                ),
                const SizedBox(width: AppDimensions.sm),
                TextButton.icon(
                  onPressed: () => _deleteEvent(context, event.id),
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
                  label: const CustomTypography.caption(text: 'Excluir', color: AppColors.error),
                ),
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
                  _openEventsForDay(context, _selectedDate);
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
                  _createEvent(context, initialDate: _selectedDate);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
            Icon(icon, color: color, size: AppDimensions.iconSizeLg),
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

  // CRUD helpers
  Future<void> _openEventsForDay(BuildContext context, DateTime date) async {
    final provider = context.read<CalendarProvider>();
    final events = provider.eventsForDate(date);
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppDimensions.lg,
          right: AppDimensions.lg,
          top: AppDimensions.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTypography.h6(
                  text: 'Eventos de ${date.day}/${date.month}/${date.year}',
                  color: AppColors.textPrimary,
                ),
                IconButton(
                  onPressed: () => _createEvent(context, initialDate: date),
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  tooltip: 'Adicionar evento',
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            if (events.isEmpty)
              const CustomTypography.bodyMedium(
                text: 'Sem eventos neste dia',
                color: AppColors.textSecondary,
              )
            else ...events.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                  child: _buildEventCard(e),
                )),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  Future<void> _createEvent(BuildContext context, {DateTime? initialDate}) async {
    final provider = context.read<CalendarProvider>();
    final now = DateTime.now();
    final date = initialDate ?? now;
    final newEvent = await _showEventDialog(
      context,
      initial: EventModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        description: '',
        date: DateUtils.dateOnly(date),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        type: EventType.other,
        location: '',
        isAllDay: false,
      ),
      isEditing: false,
    );
    if (newEvent != null) {
      await provider.addEvent(newEvent);
      if (mounted) setState(() {});
    }
  }

  Future<void> _editEvent(BuildContext context, EventModel event) async {
    final provider = context.read<CalendarProvider>();
    final updated = await _showEventDialog(context, initial: event, isEditing: true);
    if (updated != null) {
      await provider.updateEvent(updated);
      if (mounted) setState(() {});
    }
  }

  Future<void> _deleteEvent(BuildContext context, String id) async {
    final provider = context.read<CalendarProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(text: 'Excluir evento', color: AppColors.textPrimary),
        content: const CustomTypography.bodyMedium(text: 'Tem certeza que deseja excluir este evento?', color: AppColors.textSecondary),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const CustomTypography.bodyMedium(text: 'Cancelar', color: AppColors.textSecondary)),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const CustomTypography.bodyMedium(text: 'Excluir', color: AppColors.error)),
        ],
      ),
    );
    if (confirmed == true) {
      await provider.deleteEvent(id);
      if (mounted) setState(() {});
    }
  }

  Future<EventModel?> _showEventDialog(BuildContext context, {required EventModel initial, required bool isEditing}) async {
    final titleCtrl = TextEditingController(text: initial.title);
    final descCtrl = TextEditingController(text: initial.description);
    final locCtrl = TextEditingController(text: initial.location);
    DateTime date = initial.date;
    TimeOfDay start = initial.startTime;
    TimeOfDay end = initial.endTime;
    bool allDay = initial.isAllDay;
    EventType type = initial.type;

    return showDialog<EventModel>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: CustomTypography.h6(
          text: isEditing ? 'Editar Evento' : 'Novo Evento',
          color: AppColors.textPrimary,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: AppDimensions.sm),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
              ),
              const SizedBox(height: AppDimensions.sm),
              TextField(
                controller: locCtrl,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: c,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          date = picked;
                        }
                      },
                      icon: const Icon(Icons.calendar_today, color: AppColors.primary),
                      label: CustomTypography.caption(
                        text: '${date.day}/${date.month}/${date.year}',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: allDay
                                ? null
                                : () async {
                                    final t = await showTimePicker(context: c, initialTime: start);
                                    if (t != null) start = t;
                                  },
                            child: CustomTypography.caption(
                              text: allDay ? 'Dia inteiro' : 'Início: ${start.format(c)}',
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: allDay
                                ? null
                                : () async {
                                    final t = await showTimePicker(context: c, initialTime: end);
                                    if (t != null) end = t;
                                  },
                            child: CustomTypography.caption(
                              text: allDay ? '' : 'Fim: ${end.format(c)}',
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: allDay,
                    onChanged: (v) {
                      allDay = v ?? false;
                      if (allDay) {
                        start = const TimeOfDay(hour: 0, minute: 0);
                        end = const TimeOfDay(hour: 23, minute: 59);
                      }
                      (c as Element).markNeedsBuild();
                    },
                  ),
                  const CustomTypography.bodySmall(text: 'Dia inteiro', color: AppColors.textSecondary),
                ],
              ),
              DropdownButtonFormField<EventType>(
                value: type,
                items: EventType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                onChanged: (v) {
                  type = v ?? EventType.other;
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const CustomTypography.bodyMedium(text: 'Cancelar', color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(
                c,
                initial.copyWith(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  location: locCtrl.text.trim(),
                  date: DateUtils.dateOnly(date),
                  startTime: start,
                  endTime: end,
                  isAllDay: allDay,
                  type: type,
                ),
              );
            },
            child: const CustomTypography.bodyMedium(text: 'Salvar', color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
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
