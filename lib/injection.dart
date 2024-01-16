import 'package:bloc_auth_flow/repositories/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase_options.dart';

final Injection = GetIt.instance;

Future<void> setup() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Injection.registerSingleton(
    AuthService(),
    dispose: (instance) => instance.dispose(),
  );
  Injection.registerLazySingleton<ImagePicker>(() => ImagePicker());
  Injection.registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage.instance);
  Injection.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );
}
