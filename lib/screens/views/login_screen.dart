import 'package:bloc_auth_flow/controllers/login/login_bloc.dart';
import 'package:bloc_auth_flow/controllers/login/login_event.dart';
import 'package:bloc_auth_flow/controllers/login/login_state.dart';
import 'package:bloc_auth_flow/routes/router.dart';
import 'package:bloc_auth_flow/screens/widgets/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = context.read<LoginBloc>();

    void login() {
      loginBloc.passwordFocusNode.unfocus();
      loginBloc.add(const OnLoginEvent());
    }

    return Scaffold(
      body: Form(
        key: loginBloc.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: TextFormField(
                  focusNode: loginBloc.emailFocusNode,
                  onEditingComplete: loginBloc.passwordFocusNode.requestFocus,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) return "Email is required";
                    return value.isEmail ? null : "Invalid email";
                  },
                  controller: loginBloc.emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter your email",
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: loginBloc.isShow,
                builder: (_, value, child) {
                  return TextFormField(
                    focusNode: loginBloc.passwordFocusNode,
                    onEditingComplete: login,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) return "Password is required";
                      return value.isStrongPassword(
                        minLength: 6,
                        checkSpecailChar: false,
                      );
                    },
                    controller: loginBloc.passwordController,
                    obscureText: !value,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: loginBloc.toggle,
                          icon: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey.shade500,
                          )),
                      labelText: "Enter your password",
                    ),
                  );
                },
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 20),
                width: context.width,
                child: ElevatedButton(
                  onPressed: login,
                  child: BlocConsumer<LoginBloc, LoginBaseState>(
                    listener: (_, state) {
                      if (state is LoginFailState) {
                        StarlightUtils.dialog(ErrorDialog(
                            message: state.error, title: "Fail to login"));
                      }
                      if (state is LoginSuccessState) {
                        StarlightUtils.pushReplacementNamed(RouteNames.home);
                      }
                    },
                    builder: (_, state) {
                      if (state is LoginLoadingState) {
                        return const CupertinoActivityIndicator();
                      }
                      return const Text("Login");
                    },
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    StarlightUtils.pushNamed(RouteNames.forgetPassword);
                  },
                  child: const Text("Forget Password")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New User?"),
                  TextButton(
                      onPressed: () {
                        StarlightUtils.pushReplacementNamed(
                            RouteNames.register);
                      },
                      child: const Text("Sign Up"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
