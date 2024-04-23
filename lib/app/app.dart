import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/language_constants.dart';
import 'config/my_theme_data.dart';
import 'config/providers.dart';

class App extends StatelessWidget {
  final GoRouter _router;
  const App({Key? key, required GoRouter router})
      : _router = router,
        super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: getProviders(),
        builder: (context, child) => MaterialApp.router(
          title: 'Flutter Demo',
          theme: MyThemeData.themeData,
          routerConfig: _router,
          localizationsDelegates: LanguageConstants.kLocalizationsDelegates,
          supportedLocales: LanguageConstants.kSupportedLocales,
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
        ),
      );
}
