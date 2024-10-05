import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/error/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/error/exceptions/repository_exception.dart';

import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/core/usecase/restClient/rest_client.dart';
import 'package:dw_barbershop/src/core/utils/fp/nil.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;

  UserRepositoryImpl({required this.restClient});

  @override
  Future<Either<AuthException, String>> login(
      String email, String password) async {
    try {
      final Response(:data) = await restClient.unauth
          .post('/auth', data: {'email': email, 'password': password});

      return Success(data['access_token']);
    } on DioException catch (e, s) {
      if (e.response != null) {
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log(' Login ou senha invalidos', error: e, stackTrace: s);
          return Failure(AuthUnautorizedException());
        }
      }
      const message = 'Erro ao realizar login';
      log(message, error: e, stackTrace: s);
      return Failure(AuthError(message: message));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');

      return Success(UserModel.fromMap(data));
    } on DioException catch (e, s) {
      var erro = 'Erro ao buscar usuario logado!';
      log(erro, error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: erro),
      );
    } on ArgumentError catch (e, s) {
      log('Invalid json', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: e.message),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String email, String name, String password}) userData) async {
    try {
      await restClient.unauth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM'
      });
      return Success(nil);
    } on Exception catch (e, s) {
      log('Erro ao registrar usuario Admin', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao registrar usuario Admin'));
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployee(
      int barbershopId) async {
    try {
      final Response(:List data) = await restClient.auth
          .get('/users', queryParameters: {'barbershop_id': barbershopId});
      final employee = data.map((e) => UserModelEmployee.fromMap(e)).toList();
      return Success(employee);
    } on DioException catch (e, s) {
      const msg = 'Erro ao buscar colaboradores';
      log(msg, error: e, stackTrace: s);
      return Failure(RepositoryException(message: msg));
    } on ArgumentError catch (e, s) {
      const msg = 'Erro ao converter colaboradores (Invalid Json)';
      log(msg, error: e, stackTrace: s);
      return Failure(RepositoryException(message: msg));
    }
  }
}
