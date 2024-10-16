import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/theme/ui/barbershop_nav_globalkey.dart';
import 'package:dw_barbershop/src/core/theme/ui/barbershop_theme.dart';
import 'package:dw_barbershop/src/core/theme/ui/widget/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_page.dart';
import 'package:dw_barbershop/src/features/auth/register/user/user_register_page.dart';
import 'package:dw_barbershop/src/features/employee/presentation/pages/register/employee_register_page.dart';
import 'package:dw_barbershop/src/features/home/presentation/pages/adm/home_adm_page.dart';
import 'package:dw_barbershop/src/features/home/presentation/pages/employee/employee_page.dart';
import 'package:dw_barbershop/src/features/schedeule/presentation/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/employee/presentation/pages/schedule/employee_schedule_page.dart';
import 'features/splash/splash_page.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
        customLoader: const BarbershopLoader(),
        builder: (asyncNavigatorObserver) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "dw_barbershop",
            theme: BarbershopTheme.themeData,
            navigatorObservers: [asyncNavigatorObserver],
            navigatorKey: BarbershopNavGlobalkey.instance.navKey,
            routes: {
              '/': (_) => const SplashPage(),
              '/auth/login': (_) => const LoginPage(),
              '/auth/register/user': (_) => const UserRegisterPage(),
              '/auth/register/barbershop': (_) => const BarbershopRegisterPage(),
              '/home/adm': (_) => const HomeAdmPage(),
              '/home/employee': (_) => const EmployeePage(),
              '/employee/register': (_) => const EmployeeRegisterPage(),
              '/employee/schedule': (_) => const EmployeeSchedulePage(),
              '/schedule': (_) => const SchedulePage(),
            },
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR')],
            locale: const Locale('pt', 'BR'),
          );
        });
  }
}
