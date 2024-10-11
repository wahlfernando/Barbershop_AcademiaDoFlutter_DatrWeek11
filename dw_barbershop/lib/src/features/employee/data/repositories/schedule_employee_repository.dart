import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/features/employee/data/models/schedule_model.dart';

abstract interface class ScheduleEmployeeRepository {
    Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(({
    DateTime date, int userId
  })filter); 
}
