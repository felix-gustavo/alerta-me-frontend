import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/auth/auth_service_impl.dart';
import '../services/authorization/authorization_service_impl.dart';
import '../services/http/http_client_dio_impl.dart';
import '../services/medical_reminder/medical_reminder_service_impl.dart';
import '../services/medication_reminder/medication_reminder_service_impl.dart';
import '../services/users/users_service_impl.dart';
import '../services/water_history/water_history_service_impl.dart';
import '../services/water_reminder/water_reminder_service_impl.dart';
import '../stores/auth/auth_store.dart';
import '../stores/authorization/autorization/authorization_store.dart';
import '../stores/authorization/create_autorization/create_autorization_store.dart';
import '../stores/authorization/delete_autorization/delete_authorization_store.dart';
import '../stores/brightness/brightness_store.dart';
import '../stores/elderly/load_elderly/load_elderly_store.dart';
import '../stores/medical_reminder/delete_medical_reminder/delete_medical_reminder_store.dart';
import '../stores/medical_reminder/edit_medical_reminder/edit_medical_reminder_store.dart';
import '../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../stores/medication_reminder/delete_medication_reminder/delete_medication_reminder_store.dart';
import '../stores/medication_reminder/edit_medication_reminder/edit_medication_reminder_store.dart';
import '../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../stores/user/delete_elderly/delete_elderly_store.dart';
import '../stores/user/delete_user/delete_user_store.dart';
import '../stores/water_history/load_older_date_history/load_older_date_history_store.dart';
import '../stores/water_history/load_water_history/load_water_history_store.dart';
import '../stores/water_reminder/edit_water_reminder/edit_water_reminder_store.dart';
import '../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';

List<SingleChildWidget> getProviders() {
  final userService = UsersServiceImpl(httpClient: HttpClientDioImpl.instance);
  final authService = AuthServiceImpl();

  final authorizationService = AuthorizationServiceImpl(
    httpClient: HttpClientDioImpl.instance,
  );
  final waterReminderService = WaterReminderServiceImpl(
    httpClient: HttpClientDioImpl.instance,
  );
  final medicalReminderService = MedicalReminderServiceImpl(
    httpClient: HttpClientDioImpl.instance,
  );
  final medicationReminderService = MedicationReminderServiceImpl(
    httpClient: HttpClientDioImpl.instance,
  );

  return [
    Provider<AuthStore>(
      create: (_) => AuthStore(authService: authService),
    ),
    Provider<DeleteUserStore>(
      create: (_) => DeleteUserStore(usersService: userService),
    ),
    Provider<DeleteElderlyStore>(
      create: (_) => DeleteElderlyStore(usersService: userService),
    ),
    Provider<CreateAuthorizationStore>(
      create: (_) => CreateAuthorizationStore(
        authorizationService: authorizationService,
      ),
    ),
    Provider<AuthorizationStore>(
      create: (_) => AuthorizationStore(
        authorizationService: authorizationService,
      ),
    ),
    Provider<DeleteAuthorizationStore>(
      create: (_) => DeleteAuthorizationStore(
        authorizationService: authorizationService,
      ),
    ),
    ProxyProvider<AuthorizationStore, LoadElderlyStore>(
      update: (_, authorizationStore, __) => LoadElderlyStore(
        authorizationStore: authorizationStore,
        service: userService,
      ),
    ),
    Provider<EditWaterReminderStore>(
      create: (_) => EditWaterReminderStore(
        waterReminderService: waterReminderService,
      ),
    ),
    Provider<LoadWaterReminderStore>(
      create: (_) => LoadWaterReminderStore(
        waterReminderService: waterReminderService,
      ),
    ),
    Provider<EditMedicalReminderStore>(
      create: (_) => EditMedicalReminderStore(
        medicalReminderService: medicalReminderService,
      ),
    ),
    Provider<DeleteMedicalReminderStore>(
      create: (_) => DeleteMedicalReminderStore(
        medicalReminderService: medicalReminderService,
      ),
    ),
    Provider<LoadMedicalReminderStore>(
      create: (_) => LoadMedicalReminderStore(
        medicalReminderService: medicalReminderService,
      ),
    ),
    Provider<EditMedicationReminderStore>(
      create: (_) => EditMedicationReminderStore(
        medicationReminderService: medicationReminderService,
      ),
    ),
    Provider<DeleteMedicationReminderStore>(
      create: (_) => DeleteMedicationReminderStore(
        medicationReminderService: medicationReminderService,
      ),
    ),
    Provider<LoadMedicationReminderStore>(
      create: (_) => LoadMedicationReminderStore(
        medicationReminderService: medicationReminderService,
      ),
    ),
    Provider<LoadWaterHistoryStore>(
      create: (_) => LoadWaterHistoryStore(
        waterHistoryService: WaterHistoryServiceImpl(
          httpClient: HttpClientDioImpl.instance,
        ),
      ),
    ),
    Provider<LoadOlderDateHistoryStore>(
      create: (_) => LoadOlderDateHistoryStore(
        waterHistoryService: WaterHistoryServiceImpl(
          httpClient: HttpClientDioImpl.instance,
        ),
      ),
    ),
    Provider<BrightnessStore>(
      create: (_) => BrightnessStore()..init(),
    )
  ];
}
