import 'package:firebase_auth/firebase_auth.dart';

class HomeBaseState {
  final User? user;
  const HomeBaseState(this.user);
}

class HomeInitialState extends HomeBaseState {
  const HomeInitialState(super.user);
}

class HomeLoadingState extends HomeBaseState {
  const HomeLoadingState(super.user);
}

class HomeFailState extends HomeBaseState {
  const HomeFailState(super.user);
}

class HomeSuccessState extends HomeBaseState {
  const HomeSuccessState(super.user);
}

class HomeUserSignOutState extends HomeBaseState {
  const HomeUserSignOutState([super.user]);
}

class HomeUserChangedState extends HomeBaseState {
  const HomeUserChangedState(super.user);
}

class HomeImageUploadLoadingState extends HomeBaseState {
  const HomeImageUploadLoadingState(super.user);
}
