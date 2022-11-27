// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, deprecated_member_use, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:process_run/shell.dart';

class TestSpec extends StatefulWidget {
  const TestSpec({super.key, required this.specName});
  final String specName;

  @override
  State<TestSpec> createState() => _TestSpecState();
}

class _TestSpecState extends State<TestSpec> {
  List<String> browserList = ["chrome", "edge", "safari"];
  var shell = Shell(workingDirectory: "C:\\playwright_check");
  _showExecutionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select execution browser"),
            content: MultiSelectChip(browserList),
            actions: <Widget>[
              TextButton(
                  child: Text("Execute"),
                  onPressed: () async => {
                        await shell.run('''

npm install -D @playwright/test
npx playwright test tests\\first_script.spec.js --headed --project=chromium
  '''),
                        Navigator.of(context).pop()
                      })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.specName.split("\\")[1].replaceAll("'", ""),
                  style: GoogleFonts.roboto(
                      fontSize: 18, color: Color(0xff285981)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => {_showExecutionDialog()},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff285981),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      child: Text("Run spec file"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff285981),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      child: Text("View spec file"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff285981),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      child: Text("View code"),
                    ),
                  ),
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> browserList;
  MultiSelectChip(
    this.browserList,
  );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  bool isSelected = false;
  String selectedChoice = "";
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.browserList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
