import 'package:dw_barbershop/src/core/components/hours_panel.dart';
import 'package:dw_barbershop/src/core/components/weekdays_panel.dart';
import 'package:dw_barbershop/src/core/theme/ui/helpers/form_helpers.dart';
import 'package:dw_barbershop/src/core/theme/ui/helpers/message.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class BarbershopRegisterPage extends ConsumerStatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  ConsumerState<BarbershopRegisterPage> createState() =>
      _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState
    extends ConsumerState<BarbershopRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barbershopRegisterVm =
        ref.watch(barbershopRegisterVmProvider.notifier);

    ref.listen(barbershopRegisterVmProvider, (_, state){
      switch(state.status){
        case BarbershopRegisterStateStatus.initial:
          break;
        case BarbershopRegisterStateStatus.error:
          Messages.showError('Desculpe, erro ao cadastrar barbearia', context);
        case BarbershopRegisterStateStatus.success:
          Navigator.of(context).pushNamedAndRemoveUntil('/home/adm', (route) => false);  
      }
    });    

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
          ),
          onPressed: () {
            switch (formKey.currentState?.validate()) {
              case false || null:
                Messages.showError('Formulário inválido', context);
              case true:
                barbershopRegisterVm.register(nameEC.text, emailEC.text);
            }
          },
          child: const Text('Cadastrar Estabelecimento'),
        ),
      ),
      appBar: AppBar(
        title: const Text('Cadastrar Estabelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-Mail obrigatório'),
                    Validatorless.email('E-Mail inválido!'),
                  ]),
                  onTapOutside: (_) => context.unfocus(),
                  decoration: const InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 94,
                  child: WeekdaysPanel(
                    onDayPressed: (value) {
                      barbershopRegisterVm.addOrRemoveOpenDays(value);
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: HoursPanel(
                    startTime: 6,
                    endTime: 21,
                    onHourPressed: (value) {
                      barbershopRegisterVm.addOrRemoveOpenHours(value);
                    },
                  ),
                ),
                const SizedBox(
                  height: 74,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
