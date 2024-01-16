import 'package:firebase_auth/firebase_auth.dart';

class ResponsModel {
  final String? error;
  final User? data;
  bool get isError => error != null;
  ResponsModel({this.data, this.error});
  @override
  String toString() {
    if (error != null) return error!;
    return data.toString();
  }
}
