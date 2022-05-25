import 'package:flutter/material.dart';

class SnackbarUtils {
  static void textSnackbar(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Action',
          onPressed: () {},
        ),
      ),
    );
  }
}
