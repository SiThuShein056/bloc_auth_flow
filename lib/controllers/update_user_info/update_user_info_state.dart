abstract class UpdateUserInfoCubitState {
  const UpdateUserInfoCubitState();
}

class UpdateUserInfoInitialState extends UpdateUserInfoCubitState {
  const UpdateUserInfoInitialState();
}

class UpdateUserInfoLoadingState extends UpdateUserInfoCubitState {
  const UpdateUserInfoLoadingState();
}

class UpdateUserInfoSuccessState extends UpdateUserInfoCubitState {
  const UpdateUserInfoSuccessState();
}

class UpdateUserInfoErrorState extends UpdateUserInfoCubitState {
  final String message;

  const UpdateUserInfoErrorState(this.message);
}
