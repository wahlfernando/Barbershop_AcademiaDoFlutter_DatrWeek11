import 'package:dw_barbershop/src/features/employee/presentation/pages/register/employee_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterAdm(bool isRegisterAdm) {
    state = state.copyWith(registerAdm: isRegisterAdm);
  }

  void addOrRemoveWordDays(String weekDay) {
    final EmployeeRegisterState(:workDays) = state;
    if (workDays.contains(weekDay)) {
      workDays.remove(weekDay);
    } else {
      workDays.add(weekDay);
    }

    state = state.copyWith(workDays: workDays);
  }

  void addOrRemoveWordHour(int hour) {
    final EmployeeRegisterState(:workHours) = state;
    if (workHours.contains(hour)) {
      workHours.remove(hour);
    } else {
      workHours.add(hour);
    }

    state = state.copyWith(workHours: workHours);
  }
}
