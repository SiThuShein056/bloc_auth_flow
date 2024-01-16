import 'package:bloc_auth_flow/controllers/register/register_event.dart';
import 'package:bloc_auth_flow/controllers/register/register_state.dart';
import 'package:bloc_auth_flow/injection.dart';
import 'package:bloc_auth_flow/repositories/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterBaseEvent, RegisterBaseState> {
  final AuthService _auth = Injection<AuthService>();

  RegisterBloc() : super(const RegisterInitialState()) {
    on<OnReisterEvent>((event, emit) async {
      if (state is RegisterLoadingState ||
          formKey?.currentState?.validate() != true) {
        return;
      }

      ///Login State
      emit(const RegisterLoadingState());
      final result =
          await _auth.register(emailController.text, passwordController.text);
      if (result.isError) {
        ///Error State
        return emit(RegisterErrorState(result.error!));
      }

      ///Success State
      emit(const RegisterSuccessState());
    });
  }

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      passwordController = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode(),
      confirmPasswordFocusNode = FocusNode();
  final ValueNotifier<bool> passwordIsShow = ValueNotifier(false),
      confirmPasswordIsShow = ValueNotifier(false);

  void passwordIsShowToggle() {
    passwordIsShow.value = !passwordIsShow.value;
  }

  void confirmPasswordIsShowToggle() {
    confirmPasswordIsShow.value = !confirmPasswordIsShow.value;
  }

  @override
  Future<void> close() {
    formKey = null;

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    passwordIsShow.dispose();
    confirmPasswordIsShow.dispose();

    return super.close();
  }
}
