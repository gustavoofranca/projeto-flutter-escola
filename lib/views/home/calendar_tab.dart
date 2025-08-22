import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';

/// Tab de Calendário - Organização de eventos e atividades
class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Calendário
            _buildCalendar(),
            
            // Eventos do dia selecionado
            Expanded(
              child: _buildDayEvents(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar adição de evento
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Constrói o cabeçalho da tela de calendário
  Widget _buildHeader() {
    return Container(
      padding: AppDimensions.screenPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendário',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Organize seus eventos e atividades',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o calendário
  Widget _buildCalendar() {
    return Container(
      margin: AppDimensions.screenPadding,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Navegação do mês
          _buildMonthNavigation(),
          
          const SizedBox(height: AppDimensions.md),
          
          // Dias da semana
          _buildWeekDays(),
          
          const SizedBox(height: AppDimensions.sm),
          
          // Grid do calendário
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  /// Constrói a navegação do mês
  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDate = DateTime(
                _focusedDate.year,
                _focusedDate.month - 1,
              );
            });
          },
          icon: Icon(
            Icons.chevron_left,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          _getMonthYearString(_focusedDate),
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDate = DateTime(
                _focusedDate.year,
                _focusedDate.month + 1,
              );
            });
          },
          icon: Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Constrói os dias da semana
  Widget _buildWeekDays() {
    const weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    
    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Text(
            day,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  /// Constrói o grid do calendário
  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    
    final days = <Widget>[];
    
    // Adiciona dias vazios no início
    for (int i = 0; i < firstWeekday; i++) {
      days.add(const Expanded(child: SizedBox()));
    }
    
    // Adiciona os dias do mês
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isSelected = _isSameDay(date, _selectedDate);
      final isToday = _isSameDay(date, DateTime.now());
      final hasEvents = _hasEvents(date);
      
      days.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary 
                    : isToday 
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: isToday && !isSelected
                    ? Border.all(
                        color: AppColors.primary,
                        width: 1,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      day.toString(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected 
                            ? AppColors.background 
                            : AppColors.textPrimary,
                        fontWeight: isSelected || isToday 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (hasEvents)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.background 
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Organiza em linhas de 7 dias
    final rows = <Widget>[];
    for (int i = 0; i < days.length; i += 7) {
      final rowDays = days.skip(i).take(7).toList();
      rows.add(Row(children: rowDays));
    }
    
    return Column(children: rows);
  }

  /// Constrói os eventos do dia selecionado
  Widget _buildDayEvents() {
    final events = _getEventsForDate(_selectedDate);
    
    return Container(
      margin: AppDimensions.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eventos de ${_getDayString(_selectedDate)}',
            style: AppTextStyles.h5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          if (events.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      'Nenhum evento para este dia',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Toque no + para adicionar um evento',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _buildEventItem(event);
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Constrói um item de evento
  Widget _buildEventItem(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: _getEventColor(event['type']).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _getEventColor(event['type']),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  event['description'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                event['time'],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _getEventColor(event['type']),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getEventColor(event['type']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  event['type'],
                  style: AppTextStyles.caption.copyWith(
                    color: _getEventColor(event['type']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Verifica se duas datas são o mesmo dia
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Verifica se uma data tem eventos
  bool _hasEvents(DateTime date) {
    final events = _getEventsForDate(date);
    return events.isNotEmpty;
  }

  /// Obtém eventos para uma data específica
  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    // Simulação de eventos - em uma implementação real viria do banco
    if (_isSameDay(date, DateTime.now())) {
      return [
        {
          'title': 'Prova de Matemática',
          'description': 'Capítulos 5 e 6',
          'time': '14:00',
          'type': 'Prova',
        },
        {
          'title': 'Entrega do Trabalho',
          'description': 'História - Segunda Guerra',
          'time': '16:30',
          'type': 'Entrega',
        },
      ];
    } else if (_isSameDay(date, DateTime.now().add(const Duration(days: 1)))) {
      return [
        {
          'title': 'Aula de Educação Física',
          'description': 'Quadra poliesportiva',
          'time': '10:00',
          'type': 'Aula',
        },
      ];
    }
    return [];
  }

  /// Obtém a cor para um tipo de evento
  Color _getEventColor(String type) {
    switch (type.toLowerCase()) {
      case 'prova':
        return AppColors.error;
      case 'entrega':
        return AppColors.warning;
      case 'aula':
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  /// Obtém string do mês e ano
  String _getMonthYearString(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Obtém string do dia
  String _getDayString(DateTime date) {
    const days = [
      'Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'
    ];
    return '${days[date.weekday % 7]}, ${date.day} de ${_getMonthYearString(date)}';
  }
}
