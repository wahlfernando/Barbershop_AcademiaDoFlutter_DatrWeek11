import 'package:dw_barbershop/src/core/error/exceptions/service_exception.dart';

import '../../../../../core/utils/fp/either.dart';
import '../../../../../core/utils/fp/nil.dart';

abstract interface class UserLoginService {

  Future<Either<ServiceException, Nil>> execute(String email, String password);

}