import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/language_constants.dart';
import 'config/my_theme.dart';
import 'config/providers.dart';
import 'config/util.dart';
import 'stores/brightness/brightness_store.dart';

class App extends StatelessWidget {
  final GoRouter _router;
  const App({Key? key, required GoRouter router})
      : _router = router,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "DM Sans", "Mulish");
    MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: getProviders(),
      builder: (context, child) => Observer(
        builder: (context) {
          final brightnessStore = Provider.of<BrightnessStore>(
            context,
            listen: false,
          );

          final theme = brightnessStore.brightnessMode == Brightness.light.name
              ? materialTheme.light()
              : materialTheme.dark();

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: theme,
            routerConfig: _router,
            localizationsDelegates: LanguageConstants.kLocalizationsDelegates,
            supportedLocales: LanguageConstants.kSupportedLocales,
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
