// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, unnecessary_new
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/models/test_structure.dart';
import 'package:harbinger/widgets/Common/loader_widget.dart';
import 'package:harbinger/widgets/TestPlan/test_script.dart';
import 'package:http/http.dart' as http;

import '../../models/testScriptModel.dart';

class ShowStepsUpdated extends StatefulWidget {
  final String filePath;
  ShowStepsUpdated({required this.filePath});

  @override
  State<ShowStepsUpdated> createState() => _ShowStepsUpdatedState();
}

class _ShowStepsUpdatedState extends State<ShowStepsUpdated> {
  bool isLoaded = false;
  var astJson;
  late String fileContent;
  List<String> importStatements = [];
  List<Steps> stepList = [];
  TestStructure test = TestStructure();
  late TestScriptModel testScriptModel;
  Map<int, bool> _expandedMap = {};

  Future<String> readFileAsString(String filePath) async {
    Map<String, String> executeScriptPayload = {"path": widget.filePath};
    final headers = {'Content-Type': 'application/json'};
    var getGodJSONUrl = Uri.parse("http://localhost:1337/ast/getGodJSON");
    var getASTUrl = Uri.parse("http://localhost:1337/ast/getASTFromFile");
    final getASTResponse = await Future.wait([
      http.post(
        getASTUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    final getGodJSONResponse = await Future.wait([
      http.post(
        getGodJSONUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    setState(() {
      final testScriptModelResponse = json.decode(getGodJSONResponse[0].body);
      testScriptModel = TestScriptModel.fromJson(testScriptModelResponse);
      _expandedMap = Map.fromEntries(testScriptModel.testBlockArray!
          .asMap()
          .entries
          .map((entry) => MapEntry(entry.key, false)));
      for (var i = 0; i < testScriptModel.testBlockArray!.length; i++) {
        _expandedMap.addAll(Map.fromEntries(testScriptModel
            .testBlockArray![i].testStepsArray!
            .asMap()
            .entries
            .map((entry) => MapEntry(entry.key + i, false))));
      }
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
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the pre-test block
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 4, color: Color(0xffE95622)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pre-Test Block',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        for (var statement in testScriptModel.preTestBlock!)
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(statement['statement']),
                          ),
                      ],
                    ),
                  ),
                  // Display the test blocks
                  for (var testBlock in testScriptModel.testBlockArray!)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 4, color: Color(0xffE95622)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Test: ${testBlock.testName ?? 'Untitled'}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          if (testBlock.testTags!.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children: [
                                for (var tag in testBlock.testTags!)
                                  if (tag.trim().isNotEmpty)
                                    Chip(
                                      label: Text(tag.trim()),
                                    ),
                              ],
                            ),
                          SizedBox(height: 16),
                          ExpansionPanelList(
                            expansionCallback:
                                (int panelIndex, bool isExpanded) {
                              setState(() {
                                _expandedMap[panelIndex] = !isExpanded;
                              });
                            },
                            children: testBlock.testStepsArray!
                                .asMap()
                                .entries
                                .map((entry) {
                              final stepIndex = entry.key;
                              final step = entry.value;
                              final panelIndex = stepIndex +
                                  testScriptModel.testBlockArray!
                                      .indexOf(testBlock);

                              return ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(step.humanReadableStatement!),
                                  );
                                },
                                body: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var i = 0;
                                          i < step.tokens!.length;
                                          i++)
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Token ${i + 1}',
                                            hintText: 'Enter token value',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                isExpanded: _expandedMap[panelIndex] ?? false,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          : LoaderWidget(),
    );
  }

  Widget _buildStepCard(TestStep step, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(step.humanReadableStatement!),
            trailing: IconButton(
              icon: Icon(_expandedMap[index] == true
                  ? Icons.expand_less
                  : Icons.expand_more),
              onPressed: () =>
                  setState(() => _expandedMap[index] = !_expandedMap[index]!),
            ),
          ),
          if (_expandedMap[index] == true)
            ...step.tokens!.map((token) => _buildInputField(token)).toList(),
        ],
      ),
    );
  }

  Widget _buildInputField(String token) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        initialValue: token,
        decoration: InputDecoration(
          labelText: 'Token',
          border: OutlineInputBorder(),
        ),
      ),
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
