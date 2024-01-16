import 'package:bloc_auth_flow/controllers/forgetPassword/forget_password_state.dart';
import 'package:bloc_auth_flow/injection.dart';
import 'package:bloc_auth_flow/repositories/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordBaseState> {
  ForgetPasswordCubit() : super(const ForgetPasswordInitialState());
  final AuthService _auth = Injection<AuthService>();
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  Future<void> sentResetLink() async {
    if (formKey?.currentState?.validate() != true ||
        state is ForgetPasswordLoadingState) {
      return;
    }

    emit(const ForgetPasswordLoadingState());
    final result = await _auth.sentResetLink(emailController.text);

    if (result.isError) {
      return emit(ForgetPasswordFailState(result.error!));
    }

    emit(const ForgetPasswordSuccessState());
  }

  @override
  Future<void> close() {
    formKey = null;

    emailController.dispose();
    return super.close();
  }
}
