import 'package:dw_barbershop/src/core/theme/ui/barbershop_nav_globalkey.dart';
import 'package:dw_barbershop/src/core/utils/fp/either.dart';
import 'package:dw_barbershop/src/features/auth/data/usecases/services/user_login_service_impl.dart';
import 'package:dw_barbershop/src/features/auth/domain/repositories/user_repository.dart';
import 'package:dw_barbershop/src/features/auth/data/repositories/user_repository_impl.dart';
import 'package:dw_barbershop/src/core/usecase/restClient/rest_client.dart';
import 'package:dw_barbershop/src/features/auth/domain/usecases/services/user_login_service.dart';
import 'package:dw_barbershop/src/features/barbershop/data/repositories/barbershop_repository_impl.dart';
import 'package:dw_barbershop/src/features/barbershop/domain/repositories/barbershop_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/barbershop/data/models/barbershop_model.dart';

part 'applications_providers.g.dart';

@Riverpod(keepAlive: true)
RestClient restClient(RestClientRef ref) => RestClient();

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) => UserRepositoryImpl(
      restClient: ref.read(restClientProvider),
    );

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(
      userRepository: ref.read(userRepositoryProvider),
    );

@Riverpod(keepAlive: true)
Future<UserModel> getMe(GetMeRef ref) async {
  final result = await ref.watch(userRepositoryProvider).me();

  return switch (result) {
    Success(value: final userModel) => userModel,
    Failure(:final exception) => throw exception,
  };
}

@Riverpod(keepAlive: true)
BarbershopRepository barbershopRepository(BarbershopRepositoryRef ref) =>
    BarbershopRepositoryImpl(
      restClient: ref.watch(
        restClientProvider,
      ),
    );

@Riverpod(keepAlive: true)
Future<BarbershopModel> getMyBarbershop(GetMyBarbershopRef ref) async {
  final userModel = await ref.watch(getMeProvider.future);

  final barbershopRepository = ref.watch(barbershopRepositoryProvider);
  final result = await barbershopRepository.getBarberShop(userModel);

  return switch (result) {
    Success(value: final barbershop) => barbershop,
    Failure(:final exception) => throw exception
  };
}

@riverpod
Future<void> logout(LogoutRef ref) async {
  final sp = await SharedPreferences.getInstance();
  sp.clear();

  ref.invalidate(getMeProvider);
  ref.invalidate(getMyBarbershopProvider);

  Navigator.of(BarbershopNavGlobalkey.instance.navKey.currentContext!)
      .pushNamedAndRemoveUntil(
    '/auth/login',
    (route) => false,
  );
}
