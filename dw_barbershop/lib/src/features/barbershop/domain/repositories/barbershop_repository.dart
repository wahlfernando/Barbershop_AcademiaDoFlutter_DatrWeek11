import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';
import 'package:dw_barbershop/src/features/barbershop/data/models/barbershop_model.dart';

import '../../../../core/utils/fp/either.dart';
import '../../../../core/utils/fp/nil.dart';

abstract interface class BarbershopRepository {
  Future<Either<RepositoryException, Nil>> save(
      ({
        String name,
        String email,
        List<String> openingDays,
        List<int> openingHours,
      }) data);

  Future<Either<RepositoryException, BarbershopModel>> getBarberShop(
      UserModel userModel);
}
