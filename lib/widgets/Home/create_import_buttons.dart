// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/project_popup.dart';
import 'package:process_run/shell.dart';

class CreateImportButtons extends StatefulWidget {
  const CreateImportButtons(
      {super.key, required this.onClickDone, required this.projectDataLength});
  final Function(String projectName, String projectPath) onClickDone;
  final int projectDataLength;

  @override
  State<CreateImportButtons> createState() => _CreateImportButtonsState();
}

class _CreateImportButtonsState extends State<CreateImportButtons> {
  late String inputValue;
  var shell = Shell();
  _showPopup() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter script name"),
          content: TextField(
            onChanged: (value) {
              inputValue = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Start recording"),
              onPressed: () async {
                Navigator.of(context).pop();
                await shell.run('''
npx playwright codegen -o "C:\\playwright_check\\tests\\${inputValue}.spec.js" http:\\www.google.com
  ''');
              },
            ),
          ],
        );
      },
    );
  }

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
        ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          child: Text("Import existing project"),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () async => {_showPopup()},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            textStyle: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          child: Text("Create new script"),
        ),
      ],
    );
  }
}
