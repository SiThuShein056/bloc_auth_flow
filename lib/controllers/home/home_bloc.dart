import 'dart:async';

import 'package:bloc_auth_flow/controllers/home/home_event.dart';
import 'package:bloc_auth_flow/controllers/home/home_state.dart';
import 'package:bloc_auth_flow/injection.dart';
import 'package:bloc_auth_flow/repositories/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeBloc extends Bloc<HomeBaceEvent, HomeBaseState> {
  final TextEditingController _nameControler = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();

  final AuthService _auth = Injection<AuthService>();
  final ImagePicker _imagePicker = Injection<ImagePicker>();
  final FirebaseStorage _firebaseStorage = Injection<FirebaseStorage>();
  StreamSubscription? _authService;
  HomeBloc(super.initialState) {
    _auth.authState.listen((user) {
      if (user == null) {
        add(const HomeSignOutEvent());
      } else {
        add(HomeUserChangedEvent(user));
      }
    });

    on<HomeUserChangedEvent>((event, emit) {
      emit(HomeUserChangedState(event.user));
    });
    on<UploadProfileEvent>((event, emit) async {
      final userChoice = await StarlightUtils.dialog(AlertDialog(
        title: const Text("Choose Method"),
        content: SizedBox(
          height: 120,
          child: Column(children: [
            ListTile(
              onTap: () {
                StarlightUtils.pop(result: ImageSource.camera);
              },
              leading: const Icon(Icons.camera),
              title: const Text("Camera"),
            ),
            ListTile(
              onTap: () {
                StarlightUtils.pop(result: ImageSource.gallery);
              },
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
            )
          ]),
        ),
      ));
      if (userChoice == null) return;
      final XFile? image = await _imagePicker.pickImage(source: userChoice);
      if (image == null) return;
      emit(HomeImageUploadLoadingState(state.user));
      final point = _firebaseStorage.ref(
          "profile/${state.user?.uid}/${DateTime.now().toString().replaceAll(" ", "")}/${image.name.split(".").last}");
      final uploaded = await point.putFile(image.path.file);
      await _auth.currentUser?.updatePhotoURL(uploaded.ref.fullPath);
    });

    on<HomeSignOutEvent>((event, emit) {
      emit(const HomeUserSignOutState());
    });
  }

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> close() {
    _passWordController.dispose();
    _nameControler.dispose();
    _emailController.dispose();
    drawerKey.currentState?.dispose();
    _authService?.cancel();
    return super.close();
  }
}
