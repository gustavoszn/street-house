import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../theme/design_tokens.dart';
import '../services/api_service.dart';

// MODELO DE EVENTO
class AgendaEvent {
  final String? id;
  final String name;
  final DateTime date;
  final String cep;
  final String address;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  AgendaEvent({
    this.id,
    required this.name,
    required this.date,
    required this.cep,
    required this.address,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  Map<String, dynamic> toApi() => {
    'id': id,
    'nome': name,
    'dataEvento': date.toIso8601String(),
    'cep': cep,
    'endereco': address,
    'numero': number,
    'complemento': complement,
    'bairro': neighborhood,
    'cidade': city,
    'estado': state,
  }..removeWhere((k, v) => v == null);

  static AgendaEvent fromApi(Map<String, dynamic> json) => AgendaEvent(
    id: json['id']?.toString(),
    name: json['nome'] ?? '',
    date: DateTime.parse(json['dataEvento']),
    cep: json['cep'] ?? '',
    address: json['endereco'] ?? '',
    number: json['numero'] ?? '',
    complement: json['complemento'] ?? '',
    neighborhood: json['bairro'] ?? '',
    city: json['cidade'] ?? '',
    state: json['estado'] ?? '',
  );
}

// Lista de estados brasileiros
const List<String> estados = [
  'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS',
  'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC',
  'SP', 'SE', 'TO'
];

// AGENDA PRINCIPAL
class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});
  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  int year = DateTime.now().year, month = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  final months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];
  final monthsShort = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'
  ];

  List<AgendaEvent> events = [];

  // Hover state for "Voltar" button
  bool _isHoveringBack = false;

  void _changeMonth(int delta) {
    setState(() {
      month += delta;
      if (month < 1) { month = 12; year--; }
      if (month > 12) { month = 1; year++; }
      selectedDay = 1;
    });
  }

  List<AgendaEvent> get dayEvents => events
      .where((e) => e.date.year == year && e.date.month == month && e.date.day == selectedDay)
      .toList();

  Set<int> get eventDays => events
      .where((e) => e.date.year == year && e.date.month == month)
      .map((e) => e.date.day)
      .toSet();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final data = await ApiService.get('/api/eventos');
      final list = (data as List).map((e) => AgendaEvent.fromApi(e as Map<String, dynamic>)).toList();
      setState(() { events = list; });
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
    }
  }

  void _saveEvent(AgendaEvent event) {
    _persistCreate(event);
  }

  Future<void> _persistCreate(AgendaEvent event) async {
    try {
      final created = await ApiService.post('/api/eventos', event.toApi());
      final saved = AgendaEvent.fromApi(created);
      setState(() { events.add(saved); selectedDay = saved.date.day; });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evento salvo!'), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red));
    }
  }

  void _editEvent(AgendaEvent event) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: EventForm(
          initial: event,
          months: months,
          onSave: (ev) {
            _persistUpdate(event, ev);
          },
          onDelete: () => _confirmDelete(event),
        ),
      ),
    );
  }

  void _confirmDelete(AgendaEvent event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Tem certeza que deseja excluir este evento?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.purpleHighlight),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _persistDelete(event);
    }
  }

  Future<void> _persistUpdate(AgendaEvent original, AgendaEvent edited) async {
    try {
      if (original.id == null) throw Exception('ID inválido');
      final updated = await ApiService.put('/api/eventos/${original.id}', edited.toApi());
      final ev = AgendaEvent.fromApi(updated);
      setState(() {
        final idx = events.indexWhere((e) => e.id == original.id);
        if (idx >= 0) events[idx] = ev;
      });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _persistDelete(AgendaEvent event) async {
    try {
      if (event.id == null) throw Exception('ID inválido');
      await ApiService.delete('/api/eventos/${event.id}');
      setState(() { events.removeWhere((e) => e.id == event.id); });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e'), backgroundColor: Colors.red));
    }
  }

  void _openNewEventForm() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: EventForm(
          initial: AgendaEvent(
            name: '',
            date: DateTime(year, month, selectedDay, 20, 0),
            cep: '',
            address: '',
            number: '',
            complement: '',
            neighborhood: '',
            city: '',
            state: '',
          ),
          months: months,
          onSave: _saveEvent,
        ),
      ),
    );
  }

  void _showEventDetails(AgendaEvent event) {
    showDialog(
      context: context,
      builder: (context) => MinimalEventDetails(event: event, monthsShort: monthsShort),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width < 500 ? MediaQuery.of(context).size.width * 0.97 : 400.0;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: Column(
        children: [
          // HEADER
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.purpleGradientStart,
                      AppColors.purpleGradientMiddle,
                      AppColors.purpleGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(135 * 3.14 / 180),
                  ),
                ),
                child: Center(
                  child: LogoWidget(
                    size: 115,
                    colorOverlay: Colors.white,
                    semanticsLabel: 'Street House — logo',
                    onTap: () => Navigator.of(context).pushNamed('/sobre'),
                  ),
                ),
              ),
              // Seta minimalista "Voltar" para o canto esquerdo do header
              Positioned(
                top: 20,
                left: 10,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isHoveringBack = true),
                  onExit: (_) => setState(() => _isHoveringBack = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: _isHoveringBack
                          ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.of(context).pushNamed('/sobre'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new,
                                color: _isHoveringBack
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Voltar',
                                style: TextStyle(
                                  color: _isHoveringBack
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // CARD PRINCIPAL
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MÊS E SETAS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left, color: AppColors.purpleHighlight, size: 22),
                          onPressed: () => _changeMonth(-1),
                          splashRadius: 16,
                        ),
                        Text(
                          '${months[month-1]} $year',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.black),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right, color: AppColors.purpleHighlight, size: 22),
                          onPressed: () => _changeMonth(1),
                          splashRadius: 16,
                        ),
                      ],
                    ),
                    // CALENDÁRIO
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: CalendarGrid(
                        year: year,
                        month: month,
                        selectedDay: selectedDay,
                        eventDays: eventDays,
                        onSelect: (d) => setState(() => selectedDay = d),
                      ),
                    ),
                    // EVENT LIST
                    dayEvents.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              "Nenhum evento para este dia",
                              style: TextStyle(color: AppColors.textGray, fontSize: 14),
                            ),
                          )
                        : Column(
                            children: dayEvents.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: MinimalEventCard(
                                event: e,
                                monthsShort: monthsShort,
                                onEdit: () => _editEvent(e),
                                onDelete: () => _confirmDelete(e),
                                onViewMore: () => _showEventDetails(e),
                              ),
                            )).toList(),
                          ),
                  ],
                ),
              ),
            ),
          ),
          // FOOTER
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 18),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purpleHighlight,
                  foregroundColor: Colors.white,
                  elevation: 7,
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 15),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: _openNewEventForm,
                child: const Text('NOVO SHOW +', style: TextStyle(fontSize: 17, letterSpacing: 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CALENDÁRIO
class CalendarGrid extends StatelessWidget {
  final int year, month, selectedDay;
  final Set<int> eventDays;
  final ValueChanged<int> onSelect;
  const CalendarGrid({
    super.key,
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.eventDays,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    final days = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday % 7;
    final List<Widget> dayWidgets = [];
    for (int i = 0; i < firstWeekday; i++) dayWidgets.add(const SizedBox());
    for (int d = 1; d <= days; d++) {
      final isSelected = d == selectedDay;
      final hasEvent = eventDays.contains(d);
      dayWidgets.add(
        GestureDetector(
          onTap: () => onSelect(d),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.purpleHighlight.withOpacity(0.13) : null,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: AppColors.purpleHighlight, width: 2) : null,
            ),
            width: 29, height: 29,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  d.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: isSelected ? AppColors.purpleHighlight : hasEvent ? AppColors.purpleHighlight : AppColors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (hasEvent && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.purpleHighlight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['DOM','SEG','TER','QUA','QUI','SEX','SAB']
              .map((d) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Text(
                      d,
                      style: TextStyle(
                        color: AppColors.purpleHighlight,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 7),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: dayWidgets,
        ),
      ],
    );
  }
}

// CARD DE EVENTO MINIMALISTA
class MinimalEventCard extends StatelessWidget {
  final AgendaEvent event;
  final List<String> monthsShort;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewMore;
  const MinimalEventCard({
    super.key,
    required this.event,
    required this.monthsShort,
    required this.onEdit,
    required this.onDelete,
    required this.onViewMore,
  });
  @override
  Widget build(BuildContext context) {
    // Resumido: nome, data/hora, cidade/estado
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F7FA),
        borderRadius: BorderRadius.circular(11),
      ),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.purpleHighlight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(monthsShort[event.date.month-1],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
                Text(event.date.day.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onViewMore,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.purpleHighlight, fontSize: 15)),
                  Text(
                    '${event.date.day} ${monthsShort[event.date.month-1]}, ${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: AppColors.black, fontSize: 12),
                  ),
                  Text('${event.city} - ${event.state}', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(30,18),
                      foregroundColor: AppColors.purpleHighlight,
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    onPressed: onViewMore,
                    child: const Text('Ver mais'),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.purpleHighlight, size: 21),
            onPressed: onEdit,
            tooltip: 'Editar',
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey, size: 21),
            onPressed: onDelete,
            tooltip: 'Excluir',
          ),
        ],
      ),
    );
  }
}

// DETALHES DO EVENTO (minimalista)
class MinimalEventDetails extends StatelessWidget {
  final AgendaEvent event;
  final List<String> monthsShort;
  const MinimalEventDetails({super.key, required this.event, required this.monthsShort});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: AppColors.purpleHighlight)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_month, color: AppColors.purpleHighlight, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${event.date.day} ${monthsShort[event.date.month-1]}, ${event.date.year} • ${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: AppColors.black, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: AppColors.purpleHighlight, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${event.address}, ${event.number}${event.complement.isNotEmpty ? " (${event.complement})" : ""}, ${event.neighborhood}, ${event.city} - ${event.state}',
                    style: TextStyle(color: AppColors.textGray, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (event.cep.isNotEmpty)
              Text('CEP: ${event.cep}', style: TextStyle(color: AppColors.textGray, fontSize: 13)),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.purpleHighlight,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fechar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FORMULÁRIO DE EVENTO MINIMALISTA
class EventForm extends StatefulWidget {
  final AgendaEvent initial;
  final List<String> months;
  final void Function(AgendaEvent) onSave;
  final VoidCallback? onDelete;
  const EventForm({
    super.key,
    required this.initial,
    required this.months,
    required this.onSave,
    this.onDelete,
  });
  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name, cep, address, number, complement, neighborhood, city;
  late String state;
  late DateTime date;
  late int hour, minute;
  bool _holdHour = false, _holdMinute = false;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.initial.name);
    cep = TextEditingController(text: widget.initial.cep);
    address = TextEditingController(text: widget.initial.address);
    number = TextEditingController(text: widget.initial.number);
    complement = TextEditingController(text: widget.initial.complement);
    neighborhood = TextEditingController(text: widget.initial.neighborhood);
    city = TextEditingController(text: widget.initial.city);
    state = widget.initial.state;
    date = widget.initial.date;
    hour = date.hour;
    minute = date.minute;
  }

  void _increaseHour({bool fast = false}) async {
    while (_holdHour) {
      setState(() => hour = (hour + 1) % 24);
      await Future.delayed(Duration(milliseconds: fast ? 80 : 220));
    }
  }
  void _decreaseHour({bool fast = false}) async {
    while (_holdHour) {
      setState(() => hour = (hour - 1 + 24) % 24);
      await Future.delayed(Duration(milliseconds: fast ? 80 : 220));
    }
  }
  void _increaseMinute({bool fast = false}) async {
    while (_holdMinute) {
      setState(() => minute = (minute + 1) % 60);
      await Future.delayed(Duration(milliseconds: fast ? 80 : 220));
    }
  }
  void _decreaseMinute({bool fast = false}) async {
    while (_holdMinute) {
      setState(() => minute = (minute - 1 + 60) % 60);
      await Future.delayed(Duration(milliseconds: fast ? 80 : 220));
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
        ),
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Novo Evento", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF7952B3))),
                const SizedBox(height: 10),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Nome do Evento",
                    hintText: "Ex: Show Street House",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Informe o nome do evento' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: "Dia", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        value: date.day,
                        items: List.generate(daysInMonth, (i) => i + 1).map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
                        onChanged: (d) => setState(() => date = DateTime(date.year, date.month, d!, hour, minute)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(labelText: "Mês", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        value: date.month,
                        items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(value: m, child: Text(widget.months[m-1]))).toList(),
                        onChanged: (m) => setState(() => date = DateTime(date.year, m!, date.day, hour, minute)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Horário", style: TextStyle(fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onLongPressStart: (_) { _holdHour = true; _increaseHour(fast: true); },
                                    onLongPressEnd: (_) => setState(() => _holdHour = false),
                                    child: IconButton(
                                      icon: const Icon(Icons.keyboard_arrow_up, size: 22),
                                      onPressed: () => setState(() => hour = (hour + 1) % 24),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Container(
                                    width: 36,
                                    height: 36, // ajuste para melhor centralização
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.purpleHighlight, width: 1),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: TextFormField(
                                      controller: TextEditingController(text: hour.toString().padLeft(2, '0')),
                                      textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: false,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        height: 1.1,
                                      ),
                                      onChanged: (v) {
                                        int? value = int.tryParse(v);
                                        if (value != null && value >= 0 && value < 24) setState(() => hour = value);
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onLongPressStart: (_) { _holdHour = true; _decreaseHour(fast: true); },
                                    onLongPressEnd: (_) => setState(() => _holdHour = false),
                                    child: IconButton(
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                                      onPressed: () => setState(() => hour = (hour - 1 + 24) % 24),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(":", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                              Column(
                                children: [
                                  GestureDetector(
                                    onLongPressStart: (_) { _holdMinute = true; _increaseMinute(fast: true); },
                                    onLongPressEnd: (_) => setState(() => _holdMinute = false),
                                    child: IconButton(
                                      icon: const Icon(Icons.keyboard_arrow_up, size: 22),
                                      onPressed: () => setState(() => minute = (minute + 1) % 60),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.purpleHighlight, width: 1),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: TextFormField(
                                      controller: TextEditingController(text: minute.toString().padLeft(2, '0')),
                                      textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: false,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        height: 1.1,
                                      ),
                                      onChanged: (v) {
                                        int? value = int.tryParse(v);
                                        if (value != null && value >= 0 && value < 60) setState(() => minute = value);
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onLongPressStart: (_) { _holdMinute = true; _decreaseMinute(fast: true); },
                                    onLongPressEnd: (_) => setState(() => _holdMinute = false),
                                    child: IconButton(
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                                      onPressed: () => setState(() => minute = (minute - 1 + 60) % 60),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: cep,
                  decoration: InputDecoration(
                    labelText: "CEP",
                    hintText: "Ex: 12345-678",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Informe o CEP' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: address,
                  decoration: InputDecoration(
                    labelText: "Endereço",
                    hintText: "Ex: Av. Principal",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Informe o endereço' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: number,
                        decoration: InputDecoration(
                          labelText: "Número",
                          hintText: "Ex: 123",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Informe o número' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: complement,
                        decoration: InputDecoration(
                          labelText: "Complemento",
                          hintText: "Ex: Casa, Prédio, Sala 2",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: neighborhood,
                  decoration: InputDecoration(
                    labelText: "Bairro",
                    hintText: "Ex: Centro",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Informe o bairro' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: city,
                        decoration: InputDecoration(
                          labelText: "Cidade",
                          hintText: "Ex: São Paulo",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Informe a cidade' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Estado",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        value: state.isNotEmpty ? state : null,
                        items: estados.map((uf) => DropdownMenuItem(value: uf, child: Text(uf))).toList(),
                        onChanged: (v) => setState(() => state = v ?? ''),
                        validator: (v) => (v == null || v.isEmpty) ? 'Informe o estado' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          elevation: 0,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("CANCELAR"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7952B3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          elevation: 4,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            widget.onSave(AgendaEvent(
                              name: name.text,
                              date: DateTime(date.year, date.month, date.day, hour, minute),
                              cep: cep.text,
                              address: address.text,
                              number: number.text,
                              complement: complement.text,
                              neighborhood: neighborhood.text,
                              city: city.text,
                              state: state,
                            ));
                          }
                        },
                        child: const Text("SALVAR"),
                      ),
                    ),
                    if (widget.onDelete != null) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          elevation: 0,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.onDelete,
                        child: const Text("EXCLUIR"),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}