import 'dart:developer';

import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:dw_barbershop/src/core/theme/ui/widget/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';
import 'package:dw_barbershop/src/features/employee/presentation/pages/schedule/employee_schedule_vm.dart';
import 'package:dw_barbershop/src/features/employee/presentation/widgets/appointment_ds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends ConsumerState<EmployeeSchedulePage> {
  late DateTime dateSelected;
  var ignoreFirstLoad = true;

  @override
  void initState() {
    super.initState();
    final DateTime(:year, :month, :day) = DateTime.now();
    dateSelected = DateTime(year, month, day, 0, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(id: userId, :name) =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    final scheduleAsync =
        ref.watch(employeeScheduleVmProvider(userId, dateSelected));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 44,
          ),
          scheduleAsync.when(
            data: (schedules) {
              return Expanded(
                child: SfCalendar(
                  allowViewNavigation: true,
                  view: CalendarView.day,
                  showNavigationArrow: true,
                  todayHighlightColor: ColorsConstants.brow,
                  showDatePickerButton: true,
                  showTodayButton: true,
                  dataSource: AppointmentDs(schedules: schedules),
                  onViewChanged: (viewChangedDetails) {
                    if (ignoreFirstLoad) {
                      ignoreFirstLoad = false;
                      return;
                    }
                    ref
                        .read(employeeScheduleVmProvider(userId, dateSelected)
                            .notifier)
                        .changeDate(
                          userId,
                          viewChangedDetails.visibleDates.first,
                        );
                  },
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
                                  const SizedBox(
                                    height: 24,
                                  ),
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
                ),
              );
            },
            error: (error, stackTrace) {
              log('Erro ao carregar pagina',
                  error: error, stackTrace: stackTrace);
              return const Center(
                child: Text('Erro ao carregar pagina'),
              );
            },
            loading: () => const BarbershopLoader(),
          ),
        ],
      ),
    );
  }
}
