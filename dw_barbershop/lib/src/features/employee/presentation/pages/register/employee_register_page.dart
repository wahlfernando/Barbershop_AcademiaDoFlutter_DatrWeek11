import 'dart:developer';

import 'package:dw_barbershop/src/core/components/hours_panel.dart';
import 'package:dw_barbershop/src/core/components/weekdays_panel.dart';
import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/theme/ui/helpers/message.dart';
import 'package:dw_barbershop/src/core/theme/ui/widget/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/employee/presentation/pages/register/employee_register_state.dart';
import 'package:dw_barbershop/src/features/employee/presentation/pages/register/employee_register_vm.dart';
import 'package:dw_barbershop/src/features/employee/presentation/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../barbershop/data/models/barbershop_model.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var registerADM = false;

  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(employeeRegisterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case EmployeeRegisterStateStatus.initial:
        case EmployeeRegisterStateStatus.success:
          Messages.showSuccess('Colaborador cadastrado com sucesso!', context);
          Navigator.of(context).pop();
        case EmployeeRegisterStateStatus.error:
          Messages.showError('Erro ao registrar colaborador!', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastar colaborador'),
      ),
      body: barbershopAsyncValue.when(
        data: (barbershopModel) {
          // ignore: unused_local_variable
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: registerADM,
                            onChanged: (value) {
                              setState(() {
                                registerADM = !registerADM;
                                employeeRegisterVm.setRegisterAdm(registerADM);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: registerADM,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              validator: registerADM
                                  ? null
                                  : Validatorless.required('Nome obrigatório'),
                              controller: nameEC,
                              decoration: const InputDecoration(
                                label: Text('Nome'),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'E-mail obrigatório'),
                                      Validatorless.email('E-mail inválido')
                                    ]),
                              controller: emailEC,
                              decoration: const InputDecoration(
                                label: Text('E-mail'),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          'Senha obrigatória'),
                                      Validatorless.min(6,
                                          'Deve conter no mínimo 6 caracteres')
                                    ]),
                              controller: passwordEC,
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text('Senha'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      WeekdaysPanel(
                        enableDays: barbershopModel.openingDays,
                        onDayPressed: employeeRegisterVm.addOrRemoveWordDays,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      HoursPanel(
                        enableTimes: barbershopModel.openingHours,
                        startTime: 6,
                        endTime: 22,
                        onHourPressed: employeeRegisterVm.addOrRemoveWordHour,
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
                              Messages.showError(
                                  'Existe campos imválidos', context);
                            case true:
                              final EmployeeRegisterState(
                                workDays: List(isNotEmpty: hasWorkDays),
                                workHours: List(isNotEmpty: hasWorkHours),
                              ) = ref.watch(employeeRegisterVmProvider);

                              if (!hasWorkDays || !hasWorkHours) {
                                Messages.showError(
                                    'Por favor selecione os dias da semana e horários de atendimento!',
                                    context);
                                return;
                              }

                              employeeRegisterVm.register(
                                name: nameEC.text,
                                email: emailEC.text,
                                password: passwordEC.text,
                              );
                          }
                        },
                        child: const Text('Cadastrar colaborador'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          var msg = 'Erro ao carregar a pagina';
          log(msg, error: error, stackTrace: stackTrace);
          return Center(
            child: Text(msg),
          );
        },
        loading: () => const BarbershopLoader(),
      ),
    );
  }
}
