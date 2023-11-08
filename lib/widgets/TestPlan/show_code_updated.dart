// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/main.dart';
import 'package:harbinger/models/testScriptModel.dart';
import 'package:harbinger/widgets/TestPlan/test_block_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowCodeUpdated extends ConsumerStatefulWidget {
  final String filePath;
  ShowCodeUpdated({required this.filePath});

  @override
  ConsumerState<ShowCodeUpdated> createState() => _ShowCodeUpdatedState();
}

class _ShowCodeUpdatedState extends ConsumerState<ShowCodeUpdated> {
  bool isLoaded = false;
  late String fileContent;
  late TestScriptModel testScriptModel;
  List<String> objectsList = [];
  Future<String> readFileAsString(String filePath) async {
    Map<String, String> executeScriptPayload = {"path": widget.filePath};
    final headers = {'Content-Type': 'application/json'};
    var getGodJSONUrl = Uri.parse("http://localhost:1337/ast/getGodJSON");
    final getGodJSONResponse = await Future.wait([
      http.post(
        getGodJSONUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      ),
      http.post(Uri.parse('http://localhost:1337/readFile'),
          body: {'path': widget.filePath})
    ]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int activeProjectId = prefs.getInt('activeProject')!;
    String allProjects = prefs.getString('projectsObject')!;
    List<Map<String, dynamic>> allProjectsCasted =
        json.decode(allProjects).cast<Map<String, dynamic>>();
    List<Map<String, dynamic>> activeProject = activeProjectId != 0
        ? allProjectsCasted
            .where((project) => project['id'] == activeProjectId)
            .toList()
        : [];
    objectsList = await getObjectPaths(
        "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/objectRepository.js");
    setState(() {
      final testScriptModelResponse = json.decode(getGodJSONResponse[0].body);
      testScriptModel = TestScriptModel.fromJson(testScriptModelResponse);
      ref.read(godJSONProvider.notifier).state = testScriptModel;
    });
    return getGodJSONResponse[0].body;
  }

  Future<List<String>> getObjectPaths(String path) async {
    final response = await http.post(
      Uri.parse('http://localhost:1337/objectRepository/getObjectsForUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'filePath': path,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return List<String>.from(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load paths');
    }
  }

  @override
  void initState() {
    super.initState();
    readFileAsString(widget.filePath).then((content) => {
          setState((() {
            fileContent = content;
            isLoaded = true;
          }))
        });
  }

  @override
  Widget build(BuildContext context) {
    final _testScriptModel = ref.watch(godJSONProvider);
    return isLoaded
        ? Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Chip(
                            label: Text(
                                "Spec file name: ${widget.filePath.split("/")[widget.filePath.split("/").length - 1].split(".")[0]}")),
                        SizedBox(
                          width: 10,
                        ),
                        Chip(
                            label: Text(
                                "Number of test cases: ${testScriptModel.testBlockArray!.length}")),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                            onPressed: () async {
                              ref.read(screenProvider.notifier).state =
                                  "Nothing";

                              print(
                                  "model1${testScriptModel!.testBlockArray![0].testStepsArray}");
                              const url =
                                  'http://localhost:1337/ast/addTestStepInScriptFile';
                              final headers = {
                                "Content-type": "application/json"
                              };
                              final jsonBody = jsonEncode({
                                "godJson": testScriptModel
                                    .toJson(), // Use toJson to serialize the object
                                "filePath": widget.filePath
                              });

                              final response = await http.post(Uri.parse(url),
                                  headers: headers, body: jsonBody);

                              if (response.statusCode == 200) {
                                print(response.body);
                              }
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: Colors.green,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 10, vertical: 10),
                            //   textStyle: GoogleFonts.roboto(
                            //       fontSize: 14,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.normal),
                            // ),
                            label: Text("Save"),
                            icon: Icon(Icons.save)),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () => {
                                  ref.read(screenProvider.notifier).state =
                                      "Nothing"
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              textStyle: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            label: Text("Back to spec file"),
                            icon: Icon(Icons.arrow_back_ios)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _testScriptModel!.testBlockArray?.length,
                  itemBuilder: (context, i) {
                    return TestBlockCard(
                        testScriptModel: _testScriptModel,
                        testIndex: i,
                        moveUp: moveUp,
                        moveDown: moveDown,
                        deleteAt: deleteAt,
                        objectList: objectsList,
                        addStepAfterIndex: addStepAfterIndex);
                  },
                ),
              ),
            ],
          )
        : Text("Loading");
  }

  void moveUp(int testIndex, int index) {
    if (index > 0 &&
        index <
            ref
                .read(godJSONProvider.notifier)
                .state!
                .testBlockArray![testIndex]
                .testStepsArray!
                .length) {
      TestScriptModel? updatedTestScriptModel =
          ref.read(godJSONProvider.notifier).state;
      TestStep temp = updatedTestScriptModel!
          .testBlockArray![testIndex].testStepsArray![index];
      updatedTestScriptModel.testBlockArray![testIndex].testStepsArray![index] =
          updatedTestScriptModel
              .testBlockArray![testIndex].testStepsArray![index - 1];
      updatedTestScriptModel
          .testBlockArray![testIndex].testStepsArray![index - 1] = temp;
      setState(() {
        ref.read(godJSONProvider.notifier).state = updatedTestScriptModel;
      });
    }
  }

  void addStepAfterIndex(int testIndex, int index, TestStep newStep) {
    TestScriptModel? updatedTestScriptModel =
        ref.read(godJSONProvider.notifier).state;


    if (index >= 0 &&
        index <
            updatedTestScriptModel!
                .testBlockArray![testIndex].testStepsArray!.length) {
      // Increment index by 1 to add after the specific index
      updatedTestScriptModel.testBlockArray![testIndex].testStepsArray!
          .insert(index + 1, newStep);
      setState(() {
        ref.read(godJSONProvider.notifier).state = updatedTestScriptModel;
      });
    }
  }

  void moveDown(int testIndex, int index) {
    if (index >= 0 &&
        index <
            ref
                    .read(godJSONProvider.notifier)
                    .state!
                    .testBlockArray![testIndex]
                    .testStepsArray!
                    .length -
                1) {
      TestScriptModel? updatedTestScriptModel =
          ref.read(godJSONProvider.notifier).state;
      TestStep temp = updatedTestScriptModel!
          .testBlockArray![testIndex].testStepsArray![index];
      updatedTestScriptModel.testBlockArray![testIndex].testStepsArray![index] =
          updatedTestScriptModel
              .testBlockArray![testIndex].testStepsArray![index + 1];
      updatedTestScriptModel
          .testBlockArray![testIndex].testStepsArray![index + 1] = temp;
      setState(() {
        ref.read(godJSONProvider.notifier).state = updatedTestScriptModel;
      });
    }
  }

  void deleteAt(int testIndex, int index) {
    if (index >= 0 &&
        index <
            ref
                    .read(godJSONProvider.notifier)
                    .state!
                    .testBlockArray![testIndex]
                    .testStepsArray!
                    .length -
                1) {
      TestScriptModel? updatedTestScriptModel =
          ref.read(godJSONProvider.notifier).state;
      updatedTestScriptModel!.testBlockArray![testIndex].testStepsArray!
          .removeAt(index);
      setState(() {
        ref.read(godJSONProvider.notifier).state = updatedTestScriptModel;
      });
    }
  }
}
