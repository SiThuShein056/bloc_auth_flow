abstract class ForgetPasswordBaseState {
  const ForgetPasswordBaseState();
}

class ForgetPasswordInitialState extends ForgetPasswordBaseState {
  const ForgetPasswordInitialState();
}

class ForgetPasswordLoadingState extends ForgetPasswordBaseState {
  const ForgetPasswordLoadingState();
}

class ForgetPasswordFailState extends ForgetPasswordBaseState {
  final String error;
  const ForgetPasswordFailState(this.error);
}

class ForgetPasswordSuccessState extends ForgetPasswordBaseState {
  const ForgetPasswordSuccessState();
}
