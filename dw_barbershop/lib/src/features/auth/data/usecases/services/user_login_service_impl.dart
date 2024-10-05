import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/error/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/error/exceptions/service_exception.dart';

import 'package:dw_barbershop/src/core/utils/fp/either.dart';

import 'package:dw_barbershop/src/core/utils/fp/nil.dart';
import 'package:dw_barbershop/src/features/auth/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/usecases/services/user_login_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;

  UserLoginServiceImpl({required this.userRepository});

  @override
  Future<Either<ServiceException, Nil>> execute(
      String email, String password) async {
    final loginResult = await userRepository.login(email, password);

    //switch faz a verificação de tudo que precisa ser analisado
    switch (loginResult) {
      case Success(value: final accessToken):
        final sp = await SharedPreferences.getInstance();
        sp.setString(
          LocalStorageKeys.accessToken,
          accessToken,
        );
        return Success(nil);
      case Failure(:final exception):
        return switch (exception) {
          AuthError() => Failure(
              ServiceException(message: 'Erro ao realizar login!'),
            ),
          AuthUnautorizedException() => Failure(
              ServiceException(message: 'Login ou senha Inválidos!'),
            ),
        };
    }
  }
}
