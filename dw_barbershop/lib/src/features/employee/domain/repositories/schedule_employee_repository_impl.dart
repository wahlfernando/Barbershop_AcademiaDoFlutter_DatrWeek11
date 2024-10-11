import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/usecase/restClient/rest_client.dart';

import 'package:dw_barbershop/src/core/utils/fp/either.dart';

import 'package:dw_barbershop/src/features/employee/data/models/schedule_model.dart';

import '../../data/repositories/schedule_employee_repository.dart';

class ScheduleEmployeeRepositoryImpl implements ScheduleEmployeeRepository {
  final RestClient restClient;

  ScheduleEmployeeRepositoryImpl({required this.restClient});
  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
      ({DateTime date, int userId}) fileter) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/schedules', queryParameters: {
        'user_id': fileter.userId,
        'date': fileter.date.toIso8601String(),
      });

      final schedules =
          data.map((schedule) => ScheduleModel.fromMap(schedule)).toList();

      return Success(schedules);
    } on DioException catch (e, s) {
      var msg = 'Erro ao buscar agendamento de uma data';
      log(msg, stackTrace: s, error: e);
      return Failure(
        RepositoryException(message: msg),
      );
    } on ArgumentError catch (e, s) {
      var msg = 'Json inválido';
      log(msg, stackTrace: s, error: e);
      return Failure(
        RepositoryException(message: msg),
      );
    }
  }
}
