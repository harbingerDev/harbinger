// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../assets/constants.dart';

class NoTestsWidget extends StatelessWidget {
  const NoTestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.flag_circle_outlined, color: Colors.grey, size: 50),
        Text("No projects found. Start a new project or import a project",
            style: textStyle16WithoutBold),
        Row(
          children: <Widget>[],
        )
      ],
    );
  }
}
