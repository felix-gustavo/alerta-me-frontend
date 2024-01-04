import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '/app/stores/auth/auth_store.dart';
import 'config/language_constants.dart';
import 'config/my_theme_data.dart';
import 'config/providers.dart';
import 'config/routes.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(),
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final authStore = Provider.of<AuthStore>(context, listen: false);
          await authStore.initAuthUser();
        });

        return Observer(
          builder: (context) {
            return MaterialApp.router(
              title: 'Flutter Demo',
              theme: MyThemeData.themeData,
              routerConfig: getRoutes(context),
              localizationsDelegates: LanguageConstants.kLocalizationsDelegates,
              supportedLocales: LanguageConstants.kSupportedLocales,
              builder: EasyLoading.init(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
