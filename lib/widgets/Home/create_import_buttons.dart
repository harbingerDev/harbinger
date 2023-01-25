// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/project_popup.dart';

class CreateImportButtons extends StatefulWidget {
  const CreateImportButtons(
      {super.key,
      required this.onClickDone,
      required this.projectDataLength,
      required this.calledFrom});
  final Function(Map<String, dynamic> projectObject) onClickDone;
  final int projectDataLength;
  final String calledFrom;

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
        ElevatedButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => ProjectPopup(
                    onClickedDone: widget.onClickDone,
                    isAdd: true,
                  )),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          child: Text("Create new project"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
