import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/usecase/restClient/rest_client.dart';

import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/core/utils/fp/nil.dart';

import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';

import 'package:dw_barbershop/src/features/barbershop/data/models/barbershop_model.dart';

import '../../domain/repositories/barbershop_repository.dart';

class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient restClient;

  BarbershopRepositoryImpl({required this.restClient});

  @override
  Future<Either<RepositoryException, BarbershopModel>> getBarberShop(
      UserModel userModel) async {
    switch (userModel) {
      case UserModelAdm():
         final Response(data: List(first: data)) = await restClient.auth.get(
          '/barbershop',
          queryParameters: {'user_id': '#userAuthRef'},
        );
        return Success(
          BarbershopModel.fromMap(data),
        );
      case UserModelEmployee():
       final Response(:data) =
            await restClient.auth.get('/barbershop/${userModel.barberShopId}');
        return Success(
          BarbershopModel.fromMap(data),
        );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        String email,
        String name,
        List<String> openingDays,
        List<int> openingHours
      }) data) async {
    try {
      await restClient.auth.post('/barbershop', data: {
        'user_id': '#userAuthRef',
        'name': data.name,
        'email': data.email,
        'opening_days': data.openingDays,
        'opening_hours': data.openingHours
      });
      return Success(nil);
    } on DioException catch (e, s) {
      String msg = 'Erro ao registrar barbearia';
      log(msg, error: e, stackTrace: s);
      return Failure(RepositoryException(message: msg));
    }
  }
}
