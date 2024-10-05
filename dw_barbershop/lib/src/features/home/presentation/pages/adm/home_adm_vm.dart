import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';
import 'package:dw_barbershop/src/features/barbershop/data/models/barbershop_model.dart';
import 'package:dw_barbershop/src/features/home/presentation/pages/adm/home_adm_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVm extends _$HomeAdmVm {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);

    final me = await ref.watch(getMeProvider.future);

    final employeeResult = await repository.getEmployee(barbershopId);

    switch (employeeResult) {
      case Success(value: final employeeData):
        final employee = <UserModel>[];

        if (me case UserModelAdm(workDays: _?, workHours: _?)) {
          employee.add(me);
        }
        
        employee.addAll(employeeData);

        return HomeAdmState(
            status: HomeAdmStateStatus.loaded, employee: employee);
      case Failure():
        return HomeAdmState(status: HomeAdmStateStatus.loaded, employee: []);
    }
  }

  Future<void> logout() => ref.watch(logoutProvider.future).asyncLoader();
}
