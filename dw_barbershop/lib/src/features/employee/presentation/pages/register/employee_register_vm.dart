import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/core/utils/fp/nil.dart';
import 'package:dw_barbershop/src/features/auth/domain/repositories/user_repository.dart';
import 'package:dw_barbershop/src/features/barbershop/data/models/barbershop_model.dart';
import 'package:dw_barbershop/src/features/employee/presentation/pages/register/employee_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  @override
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

  Future<void> register({String? name, String? email, String? password}) async {
    final EmployeeRegisterState(:registerAdm, :workDays, :workHours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

    final Either<RepositoryException, Nil> resultRegister;

    if (registerAdm) {
      final dto = (
        workDays: workDays,
        workHours: workHours,
      );
      resultRegister = await registerAdmEmployee(dto);
    } else{
      final BarbershopModel(:id) = await ref.watch(getMyBarbershopProvider.future);
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workDays: workDays,
        workHours: workHours,
      );

      resultRegister = await registerEmployee(dto);
    }

    switch(resultRegister){
      case Success():
        state = state.copyWith(status: EmployeeRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStateStatus.error);
    }
    asyncLoaderHandler.close();
  }
}
