import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeBaceEvent {
  const HomeBaceEvent();
}

class UploadProfileEvent extends HomeBaceEvent {
  const UploadProfileEvent();
}

class HomeUserChangedEvent extends HomeBaceEvent {
  final User user;
  const HomeUserChangedEvent(this.user);
}

class HomeDisplayNameChangeEvent extends HomeBaceEvent {
  const HomeDisplayNameChangeEvent();
}

class HomeMailChangeEvent extends HomeBaceEvent {
  const HomeMailChangeEvent();
}

class HomePasswordUpdate extends HomeBaceEvent {
  const HomePasswordUpdate();
}

class HomeSignOutEvent extends HomeBaceEvent {
  const HomeSignOutEvent();
}
