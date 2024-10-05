import 'package:dw_barbershop/src/core/error/exceptions/service_exception.dart';

import 'package:dw_barbershop/src/core/utils/fp/either.dart';

import 'package:dw_barbershop/src/core/utils/fp/nil.dart';
import 'package:dw_barbershop/src/features/auth/domain/repositories/user_repository.dart';
import 'package:dw_barbershop/src/features/auth/domain/usecases/services/user_login_service.dart';

import '../../../domain/usecases/services/user_register_service_adm.dart';

class UserRegisteAdmServiceImpl implements UserRegisteAdmService {
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  UserRegisteAdmServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
      ({String email, String name, String password}) userData) async {
    final registerResult = await userRepository.registerAdmin(userData);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(:final exception):
        return Failure(
          ServiceException(message: exception.message),
        );
    }
  }
}
