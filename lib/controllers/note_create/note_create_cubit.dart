import 'package:bloc_auth_flow/controllers/note_create/note_create_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rich_editor/rich_editor.dart';

import '../../injection.dart';

class NoteCreateCubit extends Cubit<NoteCreateCubitState> {
  NoteCreateCubit() : super(const NoteCreateInitialState());

  final GlobalKey<RichEditorState> editorKey = GlobalKey<RichEditorState>();
  final FirebaseFirestore db = Injection<FirebaseFirestore>();
  final FirebaseStorage storage = Injection<FirebaseStorage>();

  Future<void> Save() async {
    emit(const NoteCreateInitialState());
    print("LOADING STATE ");
    try {
      final html = await editorKey.currentState?.getHtml();
      db.collection("notes").doc().set({
        "html": html,
      });
      emit(const NoteCreateSuccessState());
      print("SUCCESS STATE");
    } on FirebaseAuthException catch (e) {
      emit(NoteCreateErrorState(e.code));
    } catch (e) {
      emit(NoteCreateErrorState(e.toString()));
    }

    // server.collection("collectionPath").count();
    // server.collection("collectionPath").
    /// Folder
    /// Doc  Docs
    /// Notes > a
    /// Notes > 16 > General > 1
  }

  Future<String> imageSave(file) async {
    try {
      final path = "notes/${DateTime.timestamp().toString()}";
      await storage.ref(path).putFile(file);
      return storage.ref(path).getDownloadURL();
    } on FirebaseStorage catch (e) {
      print("ERRORS");
      return e.toString();
    }
  }
}
