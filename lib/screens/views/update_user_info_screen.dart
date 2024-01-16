import 'package:bloc_auth_flow/controllers/update_user_info/update_user_info_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../controllers/update_user_info/update_user_info_cubit.dart';

class UpdateUserInfoScreen extends StatelessWidget {
  final String title;
  final String labelText;
  final String? Function(String?)? validator;
  final bool requiredAuth;

  const UpdateUserInfoScreen({
    super.key,
    required this.title,
    required this.labelText,
    required this.validator,
    this.requiredAuth = false,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UpdateUserInfoCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              bloc.update();
            },
            icon: BlocConsumer<UpdateUserInfoCubit, UpdateUserInfoCubitState>(
              listener: (_, state) {
                if (state is UpdateUserInfoErrorState) {
                  StarlightUtils.snackbar(
                      SnackBar(content: Text(state.message)));
                }
                if (state is UpdateUserInfoSuccessState) {
                  StarlightUtils.pop();
                  StarlightUtils.snackbar(
                      const SnackBar(content: Text("Successfully updated!")));
                }
              },
              builder: (_, state) {
                if (state is UpdateUserInfoLoadingState) {
                  return const CupertinoActivityIndicator();
                }
                return const Icon(Icons.save);
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Form(
          key: bloc.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: bloc.controller,
                focusNode: bloc.focusNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator,
                decoration: InputDecoration(
                  labelText: labelText,
                ),
              ),
              if (requiredAuth)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: bloc.passwordController,
                    focusNode: bloc.passwordFocusNode,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => v?.isNotEmpty == true
                        ? null
                        : "Current Password is required",
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Current Password",
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
