// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/project_popup.dart';
import 'package:process_run/shell.dart';

class CreateImportButtons extends StatelessWidget {
  const CreateImportButtons(
      {super.key, required this.onClickDone, required this.projectDataLength});
  final Function(String projectName, String projectPath) onClickDone;
  final int projectDataLength;

  @override
  Widget build(BuildContext context) {
    var shell = Shell();
    return Row(
      mainAxisAlignment: projectDataLength > 0
          ? MainAxisAlignment.end
          : MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => ProjectPopup(
                    onClickedDone: onClickDone,
                    isAdd: true,
                  )),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff285981),
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
            backgroundColor: Color(0xff285981),
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
          onPressed: () async => {
            await shell.run('''
npx playwright codegen -o "C:\\playwright_check\\tests\\first_script.spec.js" http:\\www.google.com
  ''')
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff285981),
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
