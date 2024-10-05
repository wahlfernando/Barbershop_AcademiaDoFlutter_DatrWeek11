import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/error/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/user_model.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();
  Future<void> login(String email, String password) async {
    final loaderHandle = AsyncLoaderHandler()..start();

    final loginservice = ref.watch(userLoginServiceProvider);

    final result = await loginservice.execute(email, password);

    switch (result) {
      case Success():
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);
        final userModel = await ref.watch(getMeProvider.future);
        switch (userModel) {
          case UserModelAdm():
            state = state.copyWitch(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWitch(status: LoginStateStatus.employeeLogin);
        }
      case Failure(exception: ServiceException(:final message)):
        state = state.copyWitch(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandle.close();
  }
}
