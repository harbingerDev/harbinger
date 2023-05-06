// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        // Handle menu item selection
        print('Selected: $value');
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'action',
            child: Text('Add action'),
          ),
          PopupMenuItem<String>(
            value: 'verification',
            child: Text('Add verification'),
          ),
        ];
      },
    );
  }
}
