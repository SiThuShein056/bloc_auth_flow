import 'dart:async';

import 'package:bloc_auth_flow/models/response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthService {
  final FirebaseAuth _auth;
  User? currentUser;
  StreamSubscription? _userSubscription;
  final StreamController<User?> _authStateController =
      StreamController.broadcast();
  Stream<User?> get authState => _authStateController.stream;

  AuthService() : _auth = FirebaseAuth.instance {
    _auth.userChanges().listen((user) {
      _authStateController.sink.add(user);
      currentUser = user;
    });
  }
  // AuthService._() : _auth = FirebaseAuth.instance;
  // static AuthService? _instance;
  // factory AuthService.instance() {
  //   _instance ??= AuthService._();
  //   return _instance!;
  // }

  ResponsModel? _isValid(String email, String password) {
    if (!email.isEmail) {
      return ResponsModel(error: "Email is invalid");
    }

    final result = password.isStrongPassword();
    if (result != null) {
      return ResponsModel(error: result);
    }
    return null;
  }

  Future<ResponsModel> _try(Future<ResponsModel> Function() callback) async {
    try {
      final result = await callback();
      return result;
    } on FirebaseAuthException catch (e) {
      return ResponsModel(error: e.message);
    } catch (e) {
      return ResponsModel(error: 'UnknownError');
    }
  }

  Future<ResponsModel> register(String email, String password) async {
    return _try(() async {
      final validate = _isValid(email, password);
      if (validate != null) {
        return validate;
      }

      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return ResponsModel(data: credential.user);
    });
  }

  Future<ResponsModel> login(String email, String password) async {
    return _try(() async {
      final validate = _isValid(email, password);
      if (validate != null) {
        return validate;
      }
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return ResponsModel(data: credential.user);
    });
  }

  Future<ResponsModel> signOut() {
    return _try(() async {
      await _auth.signOut();
      return ResponsModel();
    });
  }

  Future<ResponsModel> sentResetLink(String email) async {
    return _try(() async {
      await _auth.sendPasswordResetEmail(email: email);

      return ResponsModel();
    });
  }

  dispose() {
    _userSubscription?.cancel();
    _authStateController.close();
  }
}
