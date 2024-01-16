import 'package:bloc_auth_flow/controllers/note_create/note_create_cubit.dart';
import 'package:bloc_auth_flow/controllers/note_create/note_create_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NoteCreateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
        actions: [
          IconButton(
            onPressed: () {
              bloc.Save();
            },
            icon: BlocConsumer<NoteCreateCubit, NoteCreateCubitState>(
                builder: (_, state) {
              if (state is NoteCreateLoadingState) {
                return const CupertinoActivityIndicator();
              }
              return const Icon(Icons.save);
            }, listener: (_, state) {
              if (state is NoteCreateErrorState) {
                StarlightUtils.snackbar(SnackBar(content: Text(state.message)));
              }
              if (state is NoteCreateSuccessState) {
                StarlightUtils.pop();
                StarlightUtils.snackbar(const SnackBar(
                    content: Text("Successfully created your Note")));
              }
            }),
          )
        ],
      ),
      body: RichEditor(
        // getImageUrl: (file) async {
        //   final path = "notes/${DateTime.timestamp().toString()}";
        //   await bloc.storage.ref(path).putFile(file);
        //   return bloc.storage.ref(path).getDownloadURL();
        // },
        getImageUrl: ((image) async => await bloc.imageSave(image)),
        key: bloc.editorKey,
        editorOptions: RichEditorOptions(
          enableVideo: false,
          barPosition: BarPosition.TOP,
        ),
      ),
    );
  }
}
