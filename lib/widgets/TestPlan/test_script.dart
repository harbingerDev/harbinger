// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, deprecated_member_use, prefer_collection_literals

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/TestPlan/spec_card.dart';
import 'package:process_run/shell.dart';

class TestScript extends StatefulWidget {
  const TestScript({super.key, required this.specName});
  final String specName;

  @override
  State<TestScript> createState() => _TestScriptState();
}

class _TestScriptState extends State<TestScript> {
  List<String> getScripts() {
    Directory currentDir = Directory("C:\\playwright_check\\tests");
    List<FileSystemEntity> files = currentDir.listSync().toList();
    List<String> scriptList = [];
    for (var file in files) {
      scriptList.add(file.path);
    }
    return scriptList;
  }

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
    return Column(children: [
      SizedBox(
        height: 50,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: getScripts().length,
          itemBuilder: (context, i) {
            return SpecCard(
              script: getScripts()[i],
            );
          },
        ),
      ),
    ]);
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
