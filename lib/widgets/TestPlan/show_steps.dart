// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_new
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/models/test_structure.dart';
import 'package:harbinger/widgets/Common/loader_widget.dart';
import 'package:http/http.dart' as http;

class ShowSteps extends StatefulWidget {
  final String filePath;
  ShowSteps({required this.filePath});

  @override
  State<ShowSteps> createState() => _ShowStepsState();
}

class _ShowStepsState extends State<ShowSteps> {
  bool isLoaded = false;
  var astJson;
  late String fileContent;
  List<String> importStatements = [];
  List<Steps> stepList = [];
  TestStructure test = TestStructure();

  Future<String> readFileAsString(String filePath) async {
    Map<String, String> executeScriptPayload = {"path": widget.filePath};
    final headers = {'Content-Type': 'application/json'};
    var getASTUrl = Uri.parse("http://localhost:1337/ast/getASTFromFile");
    final getASTResponse = await Future.wait([
      http.post(
        getASTUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    setState(() {
      // astJson = json.decode(source)
    });
    return File(widget.filePath).readAsString();
  }

  @override
  void initState() {
    super.initState();
    readFileAsString(widget.filePath).then((content) {
      setState(() {
        fileContent = content;
        isLoaded = true;
      });
    }).then((content) {
      setState(() {
        prepareDisplayInput();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Color(0xffE95622),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "X",
          style: GoogleFonts.roboto(fontSize: 18),
        ),
      ),
      body: isLoaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide.none,
                          top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide.none
                          // (
                          //     color: Color(0xffE95622),
                          //     style: BorderStyle.solid,
                          //     width: 10),
                          ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                backgroundColor: Color(0xffE95622),
                                label: Text(test.testName!,
                                    style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ExpansionPanelList(
                                  expansionCallback:
                                      (int index, bool isExpanded) {
                                    setState(() {
                                      stepList[index].isExpanded = !isExpanded;
                                    });
                                  },
                                  children: stepList
                                      .map<ExpansionPanel>((Steps item) {
                                    return ExpansionPanel(
                                      headerBuilder: (BuildContext context,
                                          bool isExpanded) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide.none,
                                                top: BorderSide.none,
                                                right: BorderSide.none,
                                                left: BorderSide(
                                                    color: Color(0xffE95622),
                                                    style: BorderStyle.solid,
                                                    width: 4),
                                              ),
                                              color:
                                                  Colors.white.withOpacity(.3),
                                            ),
                                            child: ListTile(
                                              trailing: Card(
                                                color: Colors.black87,
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Tooltip(
                                                        message:
                                                            "Add step after this step",
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Tooltip(
                                                        message:
                                                            "Add verification point after the step",
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.add_task,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Tooltip(
                                                        message: "Move step up",
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.move_up,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Tooltip(
                                                        message:
                                                            "Move step down",
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.move_down,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Tooltip(
                                                        message: "Delete step",
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.delete,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              title: Text(item.stepName!,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 18,
                                                      color: Colors.black87)),
                                            ),
                                          ),
                                        );
                                      },
                                      body: Container(
                                        padding: EdgeInsets.all(15.0),
                                        width: double.infinity,
                                        child: Text(item.action!),
                                      ),
                                      isExpanded: item.isExpanded!,
                                    );
                                  }).toList(),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : LoaderWidget(),
    );
  }

  void prepareDisplayInput() {
    var splitter = LineSplitter();
    var lines = splitter.convert(fileContent);
    for (var element in lines) {
      if (element.startsWith('import ')) {
        importStatements.add(element);
      } else if (element.trim().isEmpty) {
      } else if (element.startsWith('test(')) {
        test.testName = element.split("'")[1];
      } else if (element.trim().startsWith('await') && element.endsWith(';')) {
        if (element.contains('.goto(')) {
          Steps steps = Steps();
          steps.action = "navigation";
          steps.operatedOn = element.split('.')[0].replaceAll('await ', '');
          steps.stepName = 'naviage to ${element.split("'")[1]}';
          steps.input = element.split("'")[1];
          stepList.add(steps);
        } else if (element.contains('fill(') ||
            element.contains('click(') ||
            element.contains('press(')) {
          Steps steps = Steps();
          steps.action = element.contains('fill(')
              ? 'fill'
              : element.contains('click(')
                  ? 'click'
                  : 'press';
          steps.operatedOn = element.split('.')[0].replaceAll('await ', '');
          steps.input = getValueInFillAndClick(element);
          steps.stepName = element.contains('fill(')
              ? 'enter ${getValueInFillAndClick(element)} in ${getControlNameData(element)}'
              : element.contains('click(')
                  ? 'click on ${getControlNameData(element)}'
                  : 'press ${getValueInFillAndClick(element)} on ${getControlNameData(element)}';
          stepList.add(steps);
          print(steps.stepName);
        }
      }
    }
  }

  String getControlNameData(String line) {
    String controlNameAndData = '';
    if (line.contains('getByRole')) {
      RegExp pattern =
          RegExp(r"getByRole\('(.*?)'\).filter\(\{ hasText: '(.*?)'\ }\)");
      RegExpMatch? match = pattern.firstMatch(line);
      if (match != null) {
        String? value1 = match.group(1);
        String? value2 = match.group(2);
        controlNameAndData = '${value1} with name ${value2}';
      } else {
        RegExp exp = new RegExp(r"getByRole\('([^']*)',\s*{ name: '(.*?)' }\)");
        Queue matches = Queue();
        for (Match m in exp.allMatches(line)) {
          matches.add([m[1], m[2]]);
          controlNameAndData =
              '${matches.last[0]} with name ${matches.last[1]}';
        }
      }
    } else if (line.contains('locator')) {
      RegExp exp = new RegExp(r"locator\('([^']*)'\)");
      Queue values = Queue();
      for (Match m in exp.allMatches(line)) {
        values.add(m[1]);
      }
      controlNameAndData = 'control with locator ${values.last}';
    } else if (line.contains('getByPlaceholder')) {
      RegExp exp = new RegExp(r"getByPlaceholder\('([^']*)'\)");
      Queue values = Queue();
      for (Match m in exp.allMatches(line)) {
        values.add(m[1]);
      }
      controlNameAndData = 'control with placeholder ${values.last}';
    } else if (line.contains('getByText')) {
      RegExp exp = new RegExp(r"getByText\('([^']*)'\)");
      Queue values = Queue();
      for (Match m in exp.allMatches(line)) {
        values.add(m[1]);
      }
      controlNameAndData = 'control with text ${values.last}';
    } else if (line.contains('getByLabel')) {
      RegExp exp = new RegExp(r"getByLabel\('(.*?)'\)");
      Queue values = Queue();
      for (Match m in exp.allMatches(line)) {
        values.add(m[1]);
      }
      controlNameAndData = 'control with label ${values.last}';
    }
    return controlNameAndData;
  }

  String? getValueInFillAndClick(String line) {
    RegExp exp = new RegExp(r"'(.*?)'");

    Queue values = Queue();
    for (Match m in exp.allMatches(line)) {
      values.add(m[1]);
    }

    String? valueInQuotes = values.last;
    return valueInQuotes;
  }
}
