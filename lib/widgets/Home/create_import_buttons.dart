// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/project_popup.dart';

class CreateImportButtons extends StatefulWidget {
  const CreateImportButtons(
      {super.key,
      required this.onClickDone,
      required this.projectDataLength,
      required this.calledFrom,
      required this.projectPath});
  final Function(Map<String, dynamic> projectObject) onClickDone;
  final int projectDataLength;
  final String calledFrom;
  final String projectPath;

  @override
  State<CreateImportButtons> createState() => _CreateImportButtonsState();
}

class _CreateImportButtonsState extends State<CreateImportButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.projectDataLength > 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => ProjectPopup(
                    projectPath: widget.projectPath,
                    onClickedDone: widget.onClickDone,
                    isAdd: true,
                  )),
          // style: ElevatedButton.styleFrom(
          //   backgroundColor: Colors.black87,
          //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //   textStyle: GoogleFonts.roboto(
          //       fontSize: 14,
          //       color: Colors.white,
          //       fontWeight: FontWeight.normal),
          // ),
          label: Text("Create new project"),
          icon: Icon(Icons.add),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
