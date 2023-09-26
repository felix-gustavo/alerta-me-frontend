import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import 'app/app.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    const apiKey = String.fromEnvironment('API_KEY');
    const appId = String.fromEnvironment('APP_ID');
    const messagingSenderId = String.fromEnvironment('MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('PROJECT_ID');
    const authDomain = String.fromEnvironment('AUTH_DOMAIN');
    const storageBucket = String.fromEnvironment('STORAGE_BUCKET');

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        authDomain: authDomain,
        storageBucket: storageBucket,
      ),
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
