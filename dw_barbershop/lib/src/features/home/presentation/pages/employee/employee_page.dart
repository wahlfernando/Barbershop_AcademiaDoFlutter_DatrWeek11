import 'package:dw_barbershop/src/core/providers/applications_providers.dart';
import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:dw_barbershop/src/core/theme/ui/widget/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/auth/data/models/user_model.dart';
import 'package:dw_barbershop/src/features/employee/presentation/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/features/home/presentation/pages/employee/employee_vm.dart';
import 'package:dw_barbershop/src/features/home/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeePage extends ConsumerWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);

    return Scaffold(
      body: userModelAsync.when(
        error: (error, stackTrace) {
          return const Center(
            child: Text('Erro ao carregar pagina'),
          );
        },
        loading: () {
          return const BarbershopLoader();
        },
        data: (user) {
          final UserModel(:id, :name) = user;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(
                  hideFilter: true,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const AvatarWidget(
                        hideUploadButton: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        name,
                        style: const TextStyle(),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .7,
                        height: 108,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorsConstants.grey, width: 2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final totalAsync = ref
                                    .watch(GetTotalSchedulesTodayProvider(id));
                                return totalAsync.when(
                                  data: (totalSchedule) {
                                    return Text(
                                      '$totalSchedule',
                                      style: const TextStyle(
                                          color: ColorsConstants.brow,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32),
                                    );
                                  },
                                  error: (error, stackTrace) {
                                    return const Center(
                                      child: Text('Erro ao carregar pagina'),
                                    );
                                  },
                                  skipLoadingOnRefresh: false,
                                  loading: () {
                                    return const BarbershopLoader();
                                  },
                                );
                              },
                            ),
                            const Text(
                              'Hoje',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56)),
                        onPressed: () async {
                          await Navigator.of(context)
                              .pushNamed('/schedule', arguments: user);
                          ref.invalidate(getTotalSchedulesTodayProvider);
                        },
                        child: const Text('AGENDAR CLIENTE'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56)),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/employee/schedule', arguments: user);
                        },
                        child: const Text('VER AGENDA'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
