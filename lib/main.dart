import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import 'app/app.dart';
import 'app/config/easy_loading_config.dart';
import 'app/config/routes.dart';
import 'firebase_options.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      debugPrint('Não capturado ${errorDetails.stack}');
    };
    ValidationBuilder.setLocale('pt-br');
    EasyLoadingConfig.setup();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final router = getRouter();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      router.refresh();
    });

    runApp(App(router: router));
  }, (error, stackTrace) {
    debugPrint('error: $error');
    debugPrint('Others catching runtimeType ${error.runtimeType}');
  });
}
