import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/core/utils/fp/nil.dart';


abstract interface class ScheduleRepository {
  Future<Either<RepositoryException, Nil>> scheduleClient(
      ({
        int barbershopId,
        int userId,
        String clientName,
        DateTime date,
        int time
      }) scheduleData);      
}
