import 'package:bloc_auth_flow/injection.dart';
import 'package:bloc_auth_flow/repositories/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginBaseEvent, LoginBaseState> {
  final AuthService _auth = Injection<AuthService>();

  LoginBloc() : super(const LoginInitialState()) {
    on<OnLoginEvent>((event, emit) async {
      if (state is LoginLoadingState ||
          formKey?.currentState?.validate() != true) {
        return;
      }

      ///Login State
      emit(const LoginLoadingState());
      final result =
          await _auth.login(emailController.text, passwordController.text);
      if (result.isError) {
        ///Error State
        return emit(LoginFailState(result.error!));
      }

      ///Success State
      emit(const LoginSuccessState());
    });
  }

  final ValueNotifier<bool> isShow = ValueNotifier(false);
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode(), passwordFocusNode = FocusNode();
  GlobalKey<FormState>? formKey = GlobalKey<FormState>(debugLabel: "LoginForm");

  void toggle() {
    isShow.value = !isShow.value;
  }

  @override
  Future<void> close() {
    formKey = null;
    isShow.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
