import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../models/incidencia.dart';
import '../../../services/incidencia_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  AgendaScreenState createState() => AgendaScreenState();
}

class AgendaScreenState extends State<AgendaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Reunion>> _reuniones = {};
  final IncidenciaService _incidenciaService = IncidenciaService();

  @override
  void initState() {
    super.initState();
    _fetchReuniones();
  }

  Future<void> _fetchReuniones() async {
    final prefs = await SharedPreferences.getInstance();
    final personalId = prefs.getInt('userId');
    if (personalId != null) {
      final reunionesData =
          await _incidenciaService.fetchReunionesPorPersonal(personalId);
      setState(() {
        _reuniones = _groupReunionesByDate(reunionesData);
      });
    }
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    await SharedPreferencesService.removeUserId();
    await SharedPreferencesService.removeUserType();
    Navigator.pushReplacementNamed(context, '/');
  }

  Map<DateTime, List<Reunion>> _groupReunionesByDate(List<dynamic> reuniones) {
    Map<DateTime, List<Reunion>> reunionesMap = {};
    for (var reunionData in reuniones) {
      final reunion = Reunion.fromJson(reunionData);
      final date = DateTime.parse(reunion.fecha);
      final dateWithoutTime = DateTime(date.year, date.month, date.day);
      if (reunionesMap[dateWithoutTime] == null) {
        reunionesMap[dateWithoutTime] = [];
      }
      reunionesMap[dateWithoutTime]!.add(reunion);
    }
    return reunionesMap;
  }

  List<Reunion> _getReunionesForDay(DateTime day) {
    final dateWithoutTime = DateTime(day.year, day.month, day.day);
    return _reuniones[dateWithoutTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Image.network(
          'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
          width: 160,
        ),
      ),
      drawer: CustomDrawer(
        onLogout: () => _logout(context),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getReunionesForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xFF0575E6),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color(0xFF0575E6),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF0575E6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount:
                  _getReunionesForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                final reunion =
                    _getReunionesForDay(_selectedDay ?? _focusedDay)[index];
                return ListTile(
                  title: Text(reunion.tema),
                  subtitle:
                      Text('Hora: ${reunion.hora}\nLugar: ${reunion.lugar}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
