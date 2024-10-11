import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/usecase/restClient/rest_client.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/core/utils/fp/nil.dart';
import '../../data/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;

  ScheduleRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, Nil>> scheduleClient(
      ({
        int barbershopId,
        String clientName,
        DateTime date,
        int time,
        int userId
      }) scheduleData) async {
    try {
      await restClient.auth.post('/schedules', data: {
        'barbershop_id': scheduleData.barbershopId,
        'user_id': scheduleData.userId,
        'client_name': scheduleData.clientName,
        'date': scheduleData.date.toIso8601String(),
        'time': scheduleData.time,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar agendamento', stackTrace: s, error: e);
      return Failure(RepositoryException(message: 'Erro ao agendar horário'));
    }
  }

  
}
