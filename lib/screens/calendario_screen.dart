import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _recolecciones = {
    DateTime.utc(2025, 11, 5): ['Recolección de residuos orgánicos'],
    DateTime.utc(2025, 11, 6): ['Recolección de reciclaje'],
    DateTime.utc(2025, 11, 7): ['No hay servicio'],
    DateTime.utc(2025, 11, 8): ['Recolección de residuos mixtos'],
  };

  List<String> _eventosDelDia(DateTime day) {
    final normalizado = DateTime.utc(day.year, day.month, day.day);
    return _recolecciones[normalizado] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final eventosHoy = _selectedDay != null
        ? _eventosDelDia(_selectedDay!)
        : [];

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de recolección')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _eventosDelDia,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 24),
            if (eventosHoy.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: eventosHoy.length,
                  itemBuilder: (context, index) {
                    final evento = eventosHoy[index];
                    final icono = evento.contains('orgánicos')
                        ? Icons.eco
                        : evento.contains('reciclaje')
                        ? Icons.recycling
                        : Icons.block;

                    final color = evento.contains('orgánicos')
                        ? Colors.green
                        : evento.contains('reciclaje')
                        ? Colors.blue
                        : Colors.red;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Icon(icono, color: color),
                        title: Text(evento),
                      ),
                    );
                  },
                ),
              )
            else
              const Text(
                'No hay recolección programada para este día',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
