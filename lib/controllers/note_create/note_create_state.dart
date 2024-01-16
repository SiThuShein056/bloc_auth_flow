abstract class NoteCreateCubitState {
  const NoteCreateCubitState();
}

class NoteCreateInitialState extends NoteCreateCubitState {
  const NoteCreateInitialState();
}

class NoteCreateLoadingState extends NoteCreateCubitState {
  const NoteCreateLoadingState();
}

class NoteCreateSuccessState extends NoteCreateCubitState {
  const NoteCreateSuccessState();
}

class NoteCreateErrorState extends NoteCreateCubitState {
  final String message;
  const NoteCreateErrorState(this.message);
}
