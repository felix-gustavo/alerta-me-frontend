import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '/app/stores/auth/auth_store.dart';
import '../../../../shared/extensions/app_styles_extension.dart';
import '../../../../shared/extensions/colors_app_extension.dart';
import '../../../../stores/authorization/load_autorization/load_authorization_store.dart';
import '../../../common_components/confirm_dialog.dart';
import '../../../common_components/my_dialog.dart';
import '../../settings_page/index.dart';

class SidebarWiget extends StatelessWidget {
  const SidebarWiget({super.key});

  Future<void> _doLogout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Sair',
        content: 'Deseja realmente sair do sistema?',
        positiveBtnText: 'SIM',
        onPostivePressed: () async {
          final authStore = Provider.of<AuthStore>(
            context,
            listen: false,
          );
          await authStore.signOut();

          if (authStore.error == null && context.mounted) {
            context.go('/login');
          }
        },
        negativeBtnText: 'NÃO',
      ),
    );
  }

  Future<void> _openSettingsPage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const MyDialog(
        title: 'Configurações',
        confirmPop: false,
        child: SettingsPage(),
      ),
    );
  }

  List<IconButton> _getIconButtons(BuildContext context) => [
        IconButton(
          onPressed: () async => _openSettingsPage(context),
          icon: Icon(Icons.settings, color: context.colors.primary),
          splashRadius: 18,
        ),
        IconButton(
          onPressed: () => _doLogout(context),
          icon: Icon(Icons.logout, color: context.colors.primary),
          splashRadius: 18,
        ),
      ];

  List<Widget> _getTextButtons(BuildContext context, TextTheme textTheme) => [
        TextButton.icon(
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('CONFIGURAÇÕES'),
          ),
          icon: const Icon(Icons.settings),
          onPressed: () async => _openSettingsPage(context),
        ),
        TextButton.icon(
          label: const Padding(
            padding: EdgeInsets.all(12),
            child: Text('SAIR'),
          ),
          icon: const Icon(Icons.logout),
          onPressed: () => _doLogout(context),
        ),
      ];

  List<Widget> _getSkeletons() => [
        const SizedBox(
          width: 234,
          child: Column(
            children: [
              SkeletonLine(),
              SizedBox(height: 9),
              SkeletonLine(),
            ],
          ),
        )
      ];

  IntrinsicWidth _buildActionButtons(
      BuildContext context, TextTheme textTheme) {
    return IntrinsicWidth(
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: context.isMobile
              ? _getIconButtons(context)
              : _getTextButtons(context, textTheme),
        ),
      ),
    );
  }

  List<Widget> _buildElderlyInfo(
    String name,
    String email,
    TextTheme textTheme,
  ) =>
      [
        Text(name),
        const SizedBox(height: 9),
        Text(email, style: textTheme.bodySmall)
      ];

  @override
  Widget build(BuildContext context) {
    final loadAuthorizationStore = Provider.of<LoadAuthorizationStore>(
      context,
      listen: false,
    );

    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(context.isMobile ? 3 : 12),
      child: Observer(
        builder: (_) {
          final elderly = loadAuthorizationStore.authorization?.elderly;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Visibility(
                visible: elderly != null,
                child: context.isMobile
                    ? MenuAnchor(
                        menuChildren: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildElderlyInfo(
                                elderly?.name ?? '',
                                elderly?.email ?? '',
                                textTheme,
                              ),
                            ),
                          )
                        ],
                        alignmentOffset: const Offset(39, -27),
                        builder: (context, controller, Widget? child) {
                          return Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () {
                                controller.isOpen
                                    ? controller.close()
                                    : controller.open();
                              },
                              icon: Icon(Icons.group,
                                  color: context.colors.primary),
                              splashRadius: 18,
                            ),
                          );
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pessoa idosa',
                            style: textTheme.titleMedium!
                                .copyWith(color: context.colors.grey),
                          ),
                          ...loadAuthorizationStore.loading
                              ? _getSkeletons()
                              : [
                                  IntrinsicWidth(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 3),
                                        const Divider(),
                                        const SizedBox(height: 12),
                                        ..._buildElderlyInfo(
                                          elderly?.name ?? '',
                                          elderly?.email ?? '',
                                          textTheme,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                        ],
                      ),
              ),
              const Spacer(flex: 6),
              _buildActionButtons(context, textTheme),
              const Spacer(flex: 1),
            ],
          );
        },
      ),
    );
  }
}
