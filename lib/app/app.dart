import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '/app/stores/auth/auth_store.dart';
import 'config/index.dart';
import 'config/routes.dart';
import 'services/auth/auth_service_impl.dart';
import 'services/authorization/authorization_service_impl.dart';
import 'services/http/http_client_dio_impl.dart';
import 'services/medical_reminder/medical_reminder_service_impl.dart';
import 'services/medication_reminder/medication_reminder_service_impl.dart';
import 'services/users/users_service_impl.dart';
import 'services/water_reminder/water_reminder_service_impl.dart';
import 'stores/authorization/create_autorization/create_autorization_store.dart';
import 'stores/authorization/load_autorization/load_authorization_store.dart';
import 'stores/medical_reminder/edit_medical_reminder/edit_medical_reminder_store.dart';
import 'stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import 'stores/medication_reminder/delete_medication_reminder/delete_medication_reminder_store.dart';
import 'stores/medication_reminder/edit_medication_reminder/edit_medication_reminder_store.dart';
import 'stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import 'stores/water_reminder/edit_water_reminder/edit_water_reminder_store.dart';
import 'stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthServiceImpl(
      UsersServiceImpl(
        httpClient: HttpClientDioImpl.instance,
      ),
    );

    return MultiProvider(
      providers: [
        Provider<AuthStore>(
          create: (_) => AuthStore(authService: authService),
        ),
        Provider<CreateAuthorizationStore>(
          create: (_) => CreateAuthorizationStore(
            authorizationService: AuthorizationServiceImpl(
              httpClient: HttpClientDioImpl.instance,
            ),
          ),
        ),
        Provider<LoadAuthorizationStore>(
          create: (_) => LoadAuthorizationStore(
            authorizationService: AuthorizationServiceImpl(
              httpClient: HttpClientDioImpl.instance,
            ),
          ),
        ),
        Provider<EditWaterReminderStore>(
          create: (_) => EditWaterReminderStore(
            waterReminderService: WaterReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
        Provider<LoadWaterReminderStore>(
          create: (_) => LoadWaterReminderStore(
            waterReminderService: WaterReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
        Provider<EditMedicalReminderStore>(
          create: (_) => EditMedicalReminderStore(
            medicalReminderService: MedicalReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
        Provider<LoadMedicalReminderStore>(
          create: (_) => LoadMedicalReminderStore(
            medicalReminderService: MedicalReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
        Provider<EditMedicationReminderStore>(
          create: (_) => EditMedicationReminderStore(
            medicationReminderService: MedicationReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
        Provider<DeleteMedicationReminderStore>(
          create: (_) => DeleteMedicationReminderStore(
            medicationReminderService: MedicationReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
        Provider<LoadMedicationReminderStore>(
          create: (_) => LoadMedicationReminderStore(
            medicationReminderService: MedicationReminderServiceImpl(
              httpClient: HttpClientDioImpl.instance,
              authService: authService,
            ),
          ),
        ),
      ],
      builder: (context, child) {
        final authStore = Provider.of<AuthStore>(context);

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await authStore.initAuthUser();
        });

        return Observer(
          builder: (context) => MaterialApp.router(
            title: 'Flutter Demo',
            theme: MyThemeData.themeData,
            routerConfig: getRoutes(context),
            localizationsDelegates: LanguageConstants.kLocalizationsDelegates,
            supportedLocales: LanguageConstants.kSupportedLocales,
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
