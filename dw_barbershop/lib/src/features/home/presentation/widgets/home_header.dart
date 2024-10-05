import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:dw_barbershop/src/core/theme/ui/helpers/form_helpers.dart';
import 'package:dw_barbershop/src/core/theme/ui/widget/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/home/presentation/pages/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/applications_providers.dart';

class HomeHeader extends ConsumerWidget {
  final bool hideFilter;
  const HomeHeader({super.key, this.hideFilter = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershop = ref.watch(getMyBarbershopProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageConatants.backgorundChair),
              fit: BoxFit.cover,
              opacity: 0.5),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barbershop.maybeWhen(
            data: (data) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text('FA'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      data.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Expanded(
                    child: Text(
                      'editar',
                      style: TextStyle(
                          color: ColorsConstants.brow,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(homeAdmVmProvider.notifier).logout();
                    },
                    icon: const Icon(
                      Icons.exit_to_app_rounded,
                      color: ColorsConstants.brow,
                      size: 16,
                    ),
                  ),
                ],
              );
            },
            orElse: () {
              return const Center(child: BarbershopLoader());
            },
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Bem Vindo',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Agente um cliente',
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500),
          ),
          Offstage(
            offstage: hideFilter,
            child: const SizedBox(
              height: 16,
            ),
          ),
          Offstage(
            offstage: hideFilter,
            child: SizedBox(
              height: 36,
              child: TextFormField(
                onTapOutside: (_) => context.unfocus(),
                decoration: const InputDecoration(
                    label: Text('Buscar colaborador', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueAccent),),
                    suffixIcon: Icon(
                      Icons.search,
                      size: 22,
                      color: ColorsConstants.brow,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
