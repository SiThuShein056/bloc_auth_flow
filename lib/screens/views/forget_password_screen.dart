import 'package:bloc_auth_flow/controllers/forgetPassword/forget_password_cubit.dart';
import 'package:bloc_auth_flow/controllers/forgetPassword/forget_password_state.dart';
import 'package:bloc_auth_flow/screens/widgets/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit =
        context.read<ForgetPasswordCubit>();
    return Scaffold(
      body: Form(
        key: forgetPasswordCubit.formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Forget Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) return "Email is required";
                    return value.isEmail ? null : "Invalid email";
                  },
                  controller: forgetPasswordCubit.emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter your email",
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 20),
                width: context.width,
                child: ElevatedButton(
                  onPressed: forgetPasswordCubit.sentResetLink,
                  child: BlocConsumer<ForgetPasswordCubit,
                      ForgetPasswordBaseState>(builder: (_, state) {
                    if (state is ForgetPasswordLoadingState) {
                      return const CupertinoActivityIndicator();
                    }
                    return const Text("Sent Reset Link");
                  }, listener: (_, state) {
                    if (state is ForgetPasswordFailState) {
                      StarlightUtils.dialog(ErrorDialog(
                          message: state.error, title: "Fail to reste link"));
                    }
                  }),
                ),
              ),
              TextButton(
                  onPressed: () {
                    StarlightUtils.pop();
                  },
                  child: const Text("Back"))
            ],
          ),
        ),
      ),
    );
  }
}
