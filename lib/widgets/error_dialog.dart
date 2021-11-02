import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String? content;

  const ErrorDialog({Key? key, this.title = 'Error', this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text(content!),
            actions: [
              CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop())
            ],
          )
        : AlertDialog(
            title: const Text('Error'),
            content: Text(content!),
            actions: [
              TextButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
  }
}
