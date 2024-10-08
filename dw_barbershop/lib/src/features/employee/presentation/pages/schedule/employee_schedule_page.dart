import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:dw_barbershop/src/features/employee/presentation/widgets/appointment_ds.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EmployeeSchedulePage extends StatelessWidget {
  const EmployeeSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          const Text(
            'Nome e Sobrenome',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 44,
          ),
          Expanded(
            child: SfCalendar(
              allowViewNavigation: true,
              view: CalendarView.day,
              showNavigationArrow: true,
              todayHighlightColor: ColorsConstants.brow,
              showDatePickerButton: true,
              showTodayButton: true,
              dataSource: AppointmentDs(),
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.appointments != null &&
                    calendarTapDetails.appointments!.isNotEmpty) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                  'Cliente: ${calendarTapDetails.appointments?.first.subject}'),
                              Text('Horário: ${dateFormat.format(
                                calendarTapDetails.date ?? DateTime.now(),
                              )}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              appointmentBuilder: (context, calendarAppointmentDetails) {
                return Container(
                  decoration: BoxDecoration(
                      color: ColorsConstants.brow,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      calendarAppointmentDetails.appointments.first.subject,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
