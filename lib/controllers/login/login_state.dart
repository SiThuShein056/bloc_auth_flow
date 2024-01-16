/// Initial State
/// Loading State
/// Success State
/// Fail State

abstract class LoginBaseState {
  const LoginBaseState();
}

class LoginInitialState extends LoginBaseState {
  const LoginInitialState();
}

class LoginLoadingState extends LoginBaseState {
  const LoginLoadingState();
}

class LoginSuccessState extends LoginBaseState {
  const LoginSuccessState();
}

class LoginFailState extends LoginBaseState {
  final String error;
  const LoginFailState(this.error);
}
