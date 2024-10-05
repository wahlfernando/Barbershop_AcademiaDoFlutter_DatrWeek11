import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/features/auth/data/usecases/services/user_register_service_adm_impl.dart';
import 'package:dw_barbershop/src/features/auth/domain/usecases/services/user_register_service_adm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_provider.g.dart';

@riverpod
UserRegisteAdmService userRegisterAdmService(UserRegisterAdmServiceRef ref) =>
    UserRegisteAdmServiceImpl(
      userRepository: ref.watch(userRepositoryProvider),
      userLoginService: ref.watch(userLoginServiceProvider),
    );
