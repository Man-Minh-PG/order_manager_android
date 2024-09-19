import 'package:flutter/material.dart';

class AppWidgetsCommon {

  /*
   * Custom UI dialog
   * Common generate popup show Notification
   * If type == 1 - is show Notification
   * If type == 2 - is show Err
   * 
   */
  // ignore: unused_element
  static Widget generateDialog(context, String message, {int? type}) {
    return AlertDialog(
      title: Text(message),
      icon: Icon(
        type == 1 ? Icons.notifications : Icons.error,
        color: type == 1 ? Colors.green : Colors.red      
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}