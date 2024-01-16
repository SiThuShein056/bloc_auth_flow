import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ErrorDialog extends StatelessWidget {
  final String title, message;
  const ErrorDialog({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      actionsPadding: const EdgeInsets.only(
        bottom: 10,
        right: 20,
        left: 20,
      ),
      actions: const [
        TextButton(
          onPressed: StarlightUtils.pop,
          child: Text("Ok"),
        )
      ],
      title: Text(title),
      content: Text(message),
    );
  }
}
