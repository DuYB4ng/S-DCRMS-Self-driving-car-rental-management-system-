import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../viewmodels/car_calendar_viewmodel.dart';

class CarCalendarView extends StatefulWidget {
  final int carId;
  final String carName;

  const CarCalendarView({super.key, required this.carId, required this.carName});

  @override
  State<CarCalendarView> createState() => _CarCalendarViewState();
}

class _CarCalendarViewState extends State<CarCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarCalendarViewModel(widget.carId)..loadCalendar(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Availability: ${widget.carName}"),
        ),
        body: Consumer<CarCalendarViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 1)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                       _selectedDay = selectedDay;
                       _focusedDay = focusedDay;
                    });
                    vm.toggleDate(selectedDay);
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (vm.isBusy(day)) {
                         return Center(
                           child: Container(
                             width: 40, height: 40,
                             decoration: const BoxDecoration(
                               color: Colors.redAccent,
                               shape: BoxShape.circle,
                             ),
                             alignment: Alignment.center,
                             child: Text(
                               '${day.day}',
                               style: const TextStyle(color: Colors.white),
                             ),
                           ),
                         );
                      }
                      return null;
                    },
                    todayBuilder: (context, day, focusedDay) {
                      // Keep today visible but if busy, override color
                       if (vm.isBusy(day)) {
                         return Center(
                           child: Container(
                             width: 40, height: 40,
                             decoration: const BoxDecoration(
                               color: Colors.redAccent,
                               shape: BoxShape.circle,
                             ),
                             alignment: Alignment.center,
                             child: Text('${day.day}', style: TextStyle(color: Colors.white)),
                           ),
                         );
                       }
                       // Default today style
                       return null;
                    },
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                       Icon(Icons.circle, color: Colors.redAccent, size: 16),
                       SizedBox(width: 8),
                       Text("Busy / Blocked"),
                       SizedBox(width: 16),
                       Icon(Icons.circle_outlined, color: Colors.black, size: 16),
                       SizedBox(width: 8),
                       Text("Available"),
                    ],
                  ),
                ),
                
                const Spacer(),
                const Text("Tap a date to toggle blocking", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
