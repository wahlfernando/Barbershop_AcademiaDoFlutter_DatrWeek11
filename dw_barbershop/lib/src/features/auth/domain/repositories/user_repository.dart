
import 'package:dw_barbershop/src/core/error/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/utils/fp/nil.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';

import '../../../../core/error/exceptions/repository_exception.dart';
import '../../../../core/utils/fp/either.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, String>> login(String email, String password);

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(({
    String name, String email, String password
  }) userData);

  Future<Either<RepositoryException, List<UserModel>>> getEmployee(int barbershopId);

}