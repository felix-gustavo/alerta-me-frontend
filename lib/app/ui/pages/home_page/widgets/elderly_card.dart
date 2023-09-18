import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../model/users.dart';
import '../../../../shared/extensions/colors_app_extension.dart';
import '../../../../shared/extensions/iterable_extension.dart';
import '../../../../stores/authorization/load_autorization/load_authorization_store.dart';

class ElderlyCardWidget extends StatelessWidget {
  const ElderlyCardWidget({Key? key}) : super(key: key);

  Widget _buildLoadingCard() {
    return const Column(
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
            shape: BoxShape.circle,
            width: 63,
            height: 63,
          ),
        ),
        SizedBox(height: 12),
        SkeletonLine(
          style: SkeletonLineStyle(width: 135, alignment: Alignment.center),
        ),
        SizedBox(height: 6),
        SkeletonLine(),
      ],
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sem vínculo com pessoa idosa',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'É necessário solicitar autorização da pessoa idosa para editar os lembretes dela',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: context.colors.grey),
        ),
        Text(
          'Acesse as configurações para registrar um pedido de autorização',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: context.colors.grey),
        ),
      ].separator(const SizedBox(height: 21)).toList(),
    );
  }

  Widget _buildCard(BuildContext context, Users elderly) {
    return Column(
      children: [
        CircleAvatar(
          radius: 33,
          backgroundColor: context.colors.grey.withOpacity(.15),
          child: Icon(
            Icons.person,
            size: 42,
            color: context.colors.grey.withOpacity(.33),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          elderly.name,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 9),
        Text(elderly.email, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadAuthorizationStore = Provider.of<LoadAuthorizationStore>(
      context,
      listen: false,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colors.lightGrey),
      ),
      padding: const EdgeInsets.all(21),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 345),
        child: Observer(
          builder: (_) {
            final elderly = loadAuthorizationStore.authorization?.elderly;

            return loadAuthorizationStore.loading
                ? _buildLoadingCard()
                : elderly == null
                    ? _buildEmptyCard(context)
                    : _buildCard(context, elderly);
          },
        ),
      ),
    );
  }
}
