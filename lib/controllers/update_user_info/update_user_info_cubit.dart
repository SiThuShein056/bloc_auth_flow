import 'package:bloc_auth_flow/controllers/update_user_info/update_user_info_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserInfoCubit extends Cubit<UpdateUserInfoCubitState> {
  final User user;

  final Function(User, TextEditingController) init;

  final Future Function(User, String, String) onSave;

  UpdateUserInfoCubit(
    this.user,
    this.onSave,
    this.init,
  ) : super(const UpdateUserInfoInitialState()) {
    init(user, controller);
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController(),
      passwordController = TextEditingController();

  final FocusNode focusNode = FocusNode(), passwordFocusNode = FocusNode();

  @override
  Future<void> close() {
    focusNode.dispose();
    passwordFocusNode.dispose();
    controller.dispose();
    passwordController.dispose();
    return super.close();
  }

  Future<void> update() async {
    focusNode.unfocus();
    passwordFocusNode.unfocus();
    if (formKey.currentState?.validate() != true) return;
    if (state is UpdateUserInfoLoadingState) return;

    emit(const UpdateUserInfoLoadingState());
    try {
      // await user.updateDisplayName(controller.text);
      await onSave(user, controller.text, passwordController.text);

      emit(const UpdateUserInfoSuccessState());
    } on FirebaseAuthException catch (e) {
      print("Error is $e");
      emit(UpdateUserInfoErrorState(e.code));
    } catch (e) {
      print("Error is $e");

      emit(UpdateUserInfoErrorState(e.toString()));
    }
  }
}
