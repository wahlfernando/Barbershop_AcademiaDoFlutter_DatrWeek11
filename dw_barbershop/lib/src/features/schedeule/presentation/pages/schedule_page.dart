import 'package:dw_barbershop/src/core/components/hours_panel.dart';
import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:dw_barbershop/src/core/theme/ui/helpers/form_helpers.dart';
import 'package:dw_barbershop/src/core/theme/ui/helpers/message.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';
import 'package:dw_barbershop/src/features/employee/presentation/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/features/schedeule/presentation/pages/schedule_state.dart';
import 'package:dw_barbershop/src/features/schedeule/presentation/pages/schedule_vm.dart';
import 'package:dw_barbershop/src/features/schedeule/presentation/widgets/schedule_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  var dateFormat = DateFormat('dd/MM/yyyy');
  var showCalendar = false;
  final formKey = GlobalKey<FormState>();
  final clienteEC = TextEditingController();
  final dateEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    clienteEC.dispose();
    dateEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    final scheduleVm = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelAdm(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays,
          workHours: workHours,
        ),  
    };

    ref.listen(scheduleVmProvider.select((state) => state.status), (_, status){
      switch(status){
        case ScheduleStateStatus.initial:
          break;
        case ScheduleStateStatus.success:
          Messages.showSuccess('Cleinte agendado com sucesso!', context);
          Navigator.pop(context);
        case ScheduleStateStatus.error:  
          Messages.showError('Erro ao registrar agendamento', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                    width: 60,
                    child: AvatarWidget(
                      hideUploadButton: true,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    userModel.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: clienteEC,
                    validator: Validatorless.required('Cliente obrigatório'),
                    decoration: const InputDecoration(
                      label: Text('Cliente'),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: dateEC,
                    validator: Validatorless.required(
                        'Selecione a data ed agendamento'),
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        showCalendar = true;
                      });
                      context.unfocus();
                    },
                    decoration: const InputDecoration(
                        label: Text('Selecione uma data'),
                        hintText: 'Selecione uma data',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.date_range,
                          size: 16,
                          color: ColorsConstants.brow,
                        )),
                  ),
                  Offstage(
                    offstage: !showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        ScheduleCalendar(
                          workDays: employeeData.workDays,
                          cancelPressed: () {
                            setState(() {
                              showCalendar = false;
                            });
                          },
                          onPressed: (value) {
                            setState(() {
                              dateEC.text = dateFormat.format(value);
                              scheduleVm.dateSelect(value);
                              showCalendar = false;
                            });
                          },
                          onDaySelected: (value) {
                            setState(() {
                              dateEC.text = dateFormat.format(value);
                              scheduleVm.dateSelect(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  HoursPanel.sinbgleSelection(
                    startTime: 6,
                    endTime: 23,
                    onHourPressed: scheduleVm.hourSelect,
                    enableTimes: employeeData.workHours,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56)),
                    onPressed: () {
                      switch (formKey.currentState?.validate()) {
                        case false || null:
                          Messages.showError('Dados incompletos', context);
                        case true:
                          final hourSelected =
                              ref.watch(scheduleVmProvider.select(
                            (state) => state.scheduleHour != null,
                          ));

                          if (hourSelected) {
                            scheduleVm.register(userModel: userModel, clientName: clienteEC.text);
                          } else {
                            Messages.showError(
                                'Por favor selecione um horario de atendimento',
                                context);
                          }
                      }
                    },
                    child: const Text('Agendar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
