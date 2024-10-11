import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/features/employee/data/models/schedule_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_schedule_vm.g.dart';

@riverpod
class EmployeeScheduleVm extends _$EmployeeScheduleVm {
  Future<Either<RepositoryException, List<ScheduleModel>>> _getSchedules(
      int userId, DateTime date) {
    final repository = ref.read(scheduleEmployeeRepositoryProvider);
    return repository.findScheduleByDate((userId: userId, date: date));
  }

  @override
  Future<List<ScheduleModel>> build(int userId, DateTime date) async {
    final scheduleResult = await _getSchedules(userId, date);

    return switch (scheduleResult) {
      Success(value: final schedules) => schedules,
      Failure(:final exception) => throw Exception(exception)
    };
  }

  Future<void> changeDate(int userId, DateTime date) async {
    final scheduleResult = await _getSchedules(userId, date);

    state = switch (scheduleResult) {
      Success(value: final schedules) => AsyncData(schedules),
      Failure(:final exception) =>
        AsyncError(Exception(exception), StackTrace.current)
    };
  }
}
