import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_vm.g.dart';

@riverpod
Future<int> getTotalSchedulesToday(
    GetTotalSchedulesTodayRef ref, int userId) async {
  final DateTime(:year, :month, :day) = DateTime.now();
  final filter = (
    date: DateTime(year, month, day, 0, 0, 0),
    userId: userId,
  );

  final schedulesRepository = ref.read(scheduleEmployeeRepositoryProvider);
  final schedulesResult = await schedulesRepository.findScheduleByDate(filter);

  return switch (schedulesResult) {
    Success(value: List(length: final totalSchedules)) => totalSchedules,
    Failure(:final exception) => throw exception
  };
}
