// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/models/codeStructure.dart';
import 'package:harbinger/widgets/TestPlan/test_designGrid.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import '../Common/loader_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EditorViews extends StatefulWidget {
  const EditorViews({super.key, required this.filePath});
  final String filePath;

  @override
  State<EditorViews> createState() => _EditorViewsState();
}

class _EditorViewsState extends State<EditorViews> {
  int selectedTestIndex = 0;
  List<List<String>> testSteps = [];
  List<String> availableLocatorStrategies = [
    "getByRole",
    "getByLabel",
    "getByPlaceholder",
    "getByText",
    "getByAltText",
    "getByTitle",
    "getByTestId",
    "filter",
    "frameLocator",
    "locator",
    "nth"
  ];
  List<String> testNames = [];
  List<PlutoRow> testRows = [];

  bool loaded = false;
  late String fileContent;
  late List<String> lineArray;
  late List<CodeStructure> codeStructure;
  late Map<String, List<List<dynamic>>> tableData = {};
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
      final List intermediate = json.decode(getASTResponse[0].body);
      codeStructure =
          intermediate.map((val) => CodeStructure.fromJson(val)).toList();
    });

    return File(widget.filePath).readAsString();
  }

  prepareData() {
    codeStructure.forEach((element) {
      testNames.length != codeStructure.length
          ? testNames.add(element.name!)
          : null;
    });
    CodeStructure element = codeStructure[selectedTestIndex];
    List<List<dynamic>> codeDataArrayOfArray = [];
    element.statements?.forEach((val) {
      if (val.type == "AwaitExpression") {
        var statement = "";

        for (var i = val.start! - 1; i < (val.end!); i++) {
          statement = "${statement}${lineArray[i]}";
        }

        List<dynamic> codeDataArray = [];
        codeDataArray.add("AwaitExpression");
        codeDataArray
            .add(statement.trim().replaceAll("await", "").split(".")[0]);
        codeDataArray.insert(1, "null");
        List<String> strategies = statement
            .trim()
            .replaceAll("await", "")
            .replaceAll("page.", "")
            .replaceAll("page1.", "")
            // ignore: valid_regexps
            .split(").");

        for (var i = 0; i < strategies.length; i++) {
          if (strategies.length == 1) {
            strategies[i].split("(").forEach((str) {
              codeDataArray.add(str.trim().replaceAll(");", "").trim());
            });
          } else {
            if (!(i == strategies.length - 1)) {
              String requiredValue = availableLocatorStrategies.firstWhere(
                  (element) => strategies[i].contains(element),
                  orElse: () => "");
              codeDataArray.add(requiredValue.trim());
              codeDataArray
                  .add(strategies[i].replaceAll("${requiredValue}(", ""));
            } else {
              strategies[i].split("(").forEach((str) {
                codeDataArray.add(str.trim().replaceAll(");", "").trim());
              });
            }
          }
        }
        if (codeDataArray.length == 7) {
          codeDataArray.insert(5, "null");
          codeDataArray.insert(6, "null");
          codeDataArray.insert(7, "null");
          codeDataArray.insert(8, "null");
        } else if (codeDataArray.length == 9) {
          codeDataArray.insert(7, "null");
          codeDataArray.insert(8, "null");
        } else if (codeDataArray.length == 5) {
          codeDataArray.insert(3, "null");
          codeDataArray.insert(4, "null");
          codeDataArray.insert(5, "null");
          codeDataArray.insert(6, "null");
          codeDataArray.insert(7, "null");
          codeDataArray.insert(8, "null");
        }
        codeDataArrayOfArray.add(codeDataArray);
      }
    });

    tableData[element.name!] = codeDataArrayOfArray;
    tableData[testNames[selectedTestIndex]]!.forEach((insideArray) {
      List<String> intermediateArray = [];
      insideArray.forEach((element) {
        intermediateArray.add(element);
      });
      testSteps.add(intermediateArray);
    });
  }

  @override
  void initState() {
    super.initState();
    readFileAsString(widget.filePath).then((content) {
      setState(() {
        fileContent = content;
        var splitter = LineSplitter();
        lineArray = splitter.convert(fileContent);
      });
    }).then((content) {
      setState(() {
        prepareData();
        loaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
      body: loaded
          ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Please select the test to edit: "),
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: testNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedTestIndex == index
                                      ? Color(0xffE95622)
                                      : Colors.black87,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  textStyle: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                child: Text(testNames[index]),
                                onPressed: () {
                                  setState(() {
                                    selectedTestIndex = index;
                                    testSteps = [];
                                    prepareData();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: TestDesignGrid(testSteps: testSteps))
              ],
            )
          : LoaderWidget(),
    );
  }
}
