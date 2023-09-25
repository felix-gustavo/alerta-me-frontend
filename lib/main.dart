import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import 'app/app.dart';
import 'firebase_options.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    ValidationBuilder.setLocale('pt-br');

    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      debugPrint('Não capturado ${errorDetails.stack}');
    };

    runApp(const App());
  }, (error, stackTrace) {
    debugPrint('error: $error');
    debugPrint('Others catching runtimeType ${error.runtimeType}');
  });
}
