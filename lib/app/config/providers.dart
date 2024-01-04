import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/auth/auth_service_impl.dart';
import '../services/authorization/authorization_service_impl.dart';
import '../services/http/http_client_dio_impl.dart';
import '../services/medical_reminder/medical_reminder_service_impl.dart';
import '../services/medication_reminder/medication_reminder_service_impl.dart';
import '../services/users/users_service_impl.dart';
import '../services/water_reminder/water_reminder_service_impl.dart';
import '../stores/auth/auth_store.dart';
import '../stores/authorization/autorization/authorization_store.dart';
import '../stores/authorization/create_autorization/create_autorization_store.dart';
import '../stores/authorization/delete_autorization/delete_authorization_store.dart';
import '../stores/medical_reminder/delete_medical_reminder/delete_medical_reminder_store.dart';
import '../stores/medical_reminder/edit_medical_reminder/edit_medical_reminder_store.dart';
import '../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../stores/medication_reminder/delete_medication_reminder/delete_medication_reminder_store.dart';
import '../stores/medication_reminder/edit_medication_reminder/edit_medication_reminder_store.dart';
import '../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../stores/user/delete_elderly/delete_elderly_store.dart';
import '../stores/user/delete_user/delete_user_store.dart';
import '../stores/water_reminder/edit_water_reminder/edit_water_reminder_store.dart';
import '../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';

List<SingleChildWidget> getProviders() {
  final userService = UsersServiceImpl(
    httpClient: HttpClientDioImpl.instance,
  );

  final authService = AuthServiceImpl(usersService: userService);

  return [
    Provider<AuthStore>(
      create: (_) => AuthStore(authService: authService),
    ),
    ProxyProvider<AuthStore, DeleteUserStore>(
      update: (_, authStore, __) => DeleteUserStore(
        usersService: userService,
        authStore: authStore,
      ),
    ),
    ProxyProvider<AuthStore, DeleteElderlyStore>(
      update: (_, authStore, __) => DeleteElderlyStore(
        usersService: userService,
        authStore: authStore,
      ),
    ),
    ProxyProvider<AuthStore, CreateAuthorizationStore>(
      update: (_, authStore, __) => CreateAuthorizationStore(
        authorizationService: AuthorizationServiceImpl(
          httpClient: HttpClientDioImpl.instance,
        ),
        authStore: authStore,
      ),
    ),
    ProxyProvider<AuthStore, AuthorizationStore>(
      update: (_, authStore, __) => AuthorizationStore(
        authorizationService: AuthorizationServiceImpl(
          httpClient: HttpClientDioImpl.instance,
        ),
        authStore: authStore,
      ),
    ),
    ProxyProvider<AuthStore, DeleteAuthorizationStore>(
      update: (_, authStore, __) => DeleteAuthorizationStore(
        authorizationService: AuthorizationServiceImpl(
          httpClient: HttpClientDioImpl.instance,
        ),
        authStore: authStore,
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
    Provider<DeleteMedicalReminderStore>(
      create: (_) => DeleteMedicalReminderStore(
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
  ];
}
