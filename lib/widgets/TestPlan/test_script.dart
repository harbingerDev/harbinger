// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, deprecated_member_use, prefer_collection_literals, prefer_const_literals_to_create_immutables
import 'package:file_picker/file_picker.dart';
import 'package:harbinger/models/Endpoint.dart';
import 'package:harbinger/widgets/TestPlan/choose_endpointspopup.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/assets/constants.dart';
import 'package:harbinger/widgets/TestPlan/spec_card.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import '../Common/loader_widget.dart';

class TestScript extends StatefulWidget {
  const TestScript({super.key, required this.tab});
  final String tab;

  @override
  State<TestScript> createState() => _TestScriptState();
}

class _TestScriptState extends State<TestScript> {
  List scriptArray = [];
  bool loaded = false;
  int activeProjectId = 0;
  late List<Map<String, dynamic>> activeProject;

  Future<void> executeScript(String scriptName) async {
    setState(() {
      loaded = false;
    });
    Map<String, String> executeScriptPayload = {
      "project_path": activeProject[0]["project_path"],
      "project_name": activeProject[0]["project_name"],
      "script_name": scriptName
    };
    final headers = {'Content-Type': 'application/json'};
    var executeScriptUrl =
        Uri.parse("http://localhost:1337/runs/executeScript");
    final executeScriptResponse = await Future.wait([
      http.post(
        executeScriptUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    setState(() {
      loaded = true;
    });
  }

  Future<void> executeScripts() async {
    setState(() {
      loaded = false;
    });
    Map<String, String> executeScriptPayload = {
      "project_path": activeProject[0]["project_path"],
      "project_name": activeProject[0]["project_name"],
    };
    final headers = {'Content-Type': 'application/json'};
    var executeScriptUrl =
        Uri.parse("http://localhost:1337/runs/executeScripts");
    final executeScriptResponse = await Future.wait([
      http.post(
        executeScriptUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    setState(() {
      loaded = true;
    });
  }

  Future<void> getActiveProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeProjectId = prefs.getInt('activeProject')!;
      String allProjects = prefs.getString('projectsObject')!;
      List<Map<String, dynamic>> allProjectsCasted =
          json.decode(allProjects).cast<Map<String, dynamic>>();
      activeProject = activeProjectId != 0
          ? allProjectsCasted
              .where((project) => project['id'] == activeProjectId)
              .toList()
          : [];
    });
    if (activeProjectId != 0) {
      Map<String, String> getScriptsPayload = {
        "project_path": activeProject[0]["project_path"],
        "project_name": activeProject[0]["project_name"]
      };
      final headers = {'Content-Type': 'application/json'};

      var getScriptsUrl = Uri.parse("http://localhost:1337/scripts/getScripts");
      final getScriptsResponse = await Future.wait([
        http.post(
          getScriptsUrl,
          body: json.encode(getScriptsPayload),
          encoding: Encoding.getByName('utf-8'),
          headers: headers,
        )
      ]);
      setState(() {
        scriptArray = json.decode(getScriptsResponse[0].body);
        loaded = true;
      });
    } else {
      setState(() {
        loaded = true;
      });
    }
  }

  late String scriptName;
  late String url;
  late String testName;
  late String tags;

  _showInitPopup() async {
    ValueNotifier<bool> isUiScript = ValueNotifier<bool>(true);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Script Type"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            height: MediaQuery.of(context).size.height * 0.34,
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Please select the type of script you'd like to work with:",style: TextStyle(fontSize: 13),),

                  ],
                ),
                   SizedBox(height: 5,),
                ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width * 0.218,
                  minHeight: MediaQuery.of(context).size.height * 0.17,
                  fontSize: 20.0,
                  initialLabelIndex: isUiScript.value ? 0 : 1,
                  labels: ["UI Script", "API Script"],
                  onToggle: (index) {
                    isUiScript.value = index == 0;
                  },
                  cornerRadius: 10,
                  activeBgColor: [Color(0xFFF3752E)],
                  inactiveBgColor: Color(0xFFE8E8E8),
                  activeFgColor: Colors.black,
                  inactiveFgColor: Colors.black,
                ),
                SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: isUiScript,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Close",
                                  selectionColor:
                                      const Color.fromARGB(255, 204, 204, 204),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                             
                              IconButton(
                                style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor:
                                        Color.fromARGB(255, 3, 129, 7)),
                                hoverColor: Color.fromARGB(255, 5, 152, 10),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showPopup(""); // Handle "Record Ui Script"
                                },
                                icon: Row(
                                  children: [
                                    Icon(Icons.fiber_manual_record,
                                        color: Colors.white),
                                    Text(
                                      "Record",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Close",
                                  selectionColor:
                                      const Color.fromARGB(255, 204, 204, 204),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              
                              IconButton(
                                style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor:
                                        Color.fromARGB(255, 3, 129, 7)),
                                hoverColor: Color.fromARGB(255, 5, 152, 10),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showUploadPopup(context);
                                },
                                icon: Row(
                                  children: [
                                    Icon(Icons.api,
                                        color: Colors.white),
                                    Text(
                                      "Use OpenApi template",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showUploadPopup(BuildContext context) async {
    bool showSpinner = false;
    FilePickerResult? result;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(title: Text("Upload file"),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.38,
                height: MediaQuery.of(context).size.height * 0.32,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.cloud_upload_outlined,
                            color: Color.fromARGB(255, 218, 216, 216),
                            size: 100.0),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Upload the project openapi.json file",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showInitPopup();
                          },
                          child: Row(
                            children: [
                              // Icon(Icons.arrow_back, color: const Color.fromARGB(255, 0, 0, 0)),
                              Text(
                                "Back",
                                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Color.fromARGB(255, 3, 129, 7)),
                          hoverColor: Color.fromARGB(255, 5, 152, 10),
                          onPressed: () async {
                            print("uploading....");
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['json'],
                            );
                            if (result != null && result.files.isNotEmpty) {
                              setState(() {
                                showSpinner = true;
                              });
                              String serverUrl =
                                  "http://127.0.0.1:8001/uploadapiinfo/";
                              final selectedFile = result.files.first;
                              // Create an HTTP request to your backend
                              final request = http.MultipartRequest(
                                  'POST', Uri.parse(serverUrl));

                              // Convert the Uint8List to List<int>
                              final byteList = selectedFile.bytes!.toList();

                              // Create a Stream from the List<int>
                              final fileStream =
                                  Stream<List<int>>.fromIterable([byteList]);
                              // Create a MultipartFile from the selected file
                              final multipartFile =
                                  http.MultipartFile.fromBytes('file', byteList,
                                      filename: selectedFile.name);

                              // Add the file to the request
                              request.files.add(multipartFile);

                              // Send the request
                              final response = await request.send();
                              print("response: $response");
                              if (response.statusCode == 200) {
                                //make to next screen and send the data u got
                                setState(() {
                                  showSpinner = true;
                                });

                                final List<dynamic> responseData = json.decode(
                                    await response.stream.bytesToString());
                                final List<Endpoint> endpoints = responseData
                                    .map((e) => Endpoint.fromJson(e))
                                    .toList();

                                Navigator.of(context).pop();
                                _showchooseendpointsPopup(endpoints);

                                print('image uploaded');
                              } else {
                                print('failed');
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            } else {
                              print("No file selected.");
                            }
                          },
                          icon: Row(
                            children: [
                              Icon(Icons.upload_rounded, color: Colors.white),
                              Text(
                                "Upload",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _showchooseendpointsPopup(List<Endpoint> endpoints) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return EndpointWidget(endpoints:endpoints);
        });
  }

  _showPopup(String specName) async {
    var controller = TextEditingController(text: specName);
    scriptName = controller.text;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Record script"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: specName == "" ? false : true,
                    controller: controller,
                    decoration: InputDecoration(hintText: "Enter spec name"),
                    onChanged: (value) {
                      scriptName = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Enter test name"),
                    onChanged: (value) {
                      testName = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText:
                            "Enter tags for test (eg. @smoke,@functionalComponent)"),
                    onChanged: (value) {
                      tags = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration:
                        InputDecoration(hintText: "Enter application url"),
                    onChanged: (value) {
                      url = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Color.fromARGB(255, 3, 129, 7)),
                hoverColor: Color.fromARGB(255, 5, 152, 10),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showInitPopup();
                },
                icon: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await recordScript();
                  },
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Colors.black87,
                  //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //   textStyle: GoogleFonts.roboto(
                  //       fontSize: 14,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  label: Text("Start recording"),
                  icon: Icon(Icons.fiber_manual_record)),
            ]),
          ],
        );
      },
    );
  }

  Future<void> recordScript() async {
    setState(() {
      loaded = false;
    });
    Map<String, String> recordPayload = {
      "project_path": activeProject[0]["project_path"],
      "project_name": activeProject[0]["project_name"],
      "script_name": "${scriptName.replaceAll(" ", "_")}.spec.js",
      "url": url,
      "test_name": testName,
      "tags": tags
    };
    final headers = {'Content-Type': 'application/json'};
    var recordScriptUrl =
        Uri.parse("http://localhost:1337/scripts/createScript");
    final recordScriptsResponse = await Future.wait([
      http.post(
        recordScriptUrl,
        body: json.encode(recordPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    await getActiveProject();
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getActiveProject();
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? LoaderWidget()
        : activeProjectId > 0 && scriptArray.isNotEmpty
            ? Column(children: [
                SizedBox(
                  height: 10,
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
                                  "Project: ${activeProject[0]["project_name"]}")),
                          SizedBox(width: 10),
                          Chip(
                              label: Text(
                                  "Number of scripts: ${scriptArray.length}")),
                        ],
                      ),
                      widget.tab == "plan"
                          ? ElevatedButton.icon(
                              onPressed: () async => {_showInitPopup()},
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: Colors.black87,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 10, vertical: 10),
                              //   textStyle: GoogleFonts.roboto(
                              //       fontSize: 14,
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.normal),
                              // ),
                              label: Text("Create new script"),
                              icon: Icon(Icons.add))
                          : widget.tab == "lab"
                              ? ElevatedButton.icon(
                                  onPressed: () async =>
                                      {await executeScripts()},
                                  // style: ElevatedButton.styleFrom(
                                  //   backgroundColor: Colors.black87,
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: 10, vertical: 10),
                                  //   textStyle: GoogleFonts.roboto(
                                  //       fontSize: 14,
                                  //       color: Colors.white,
                                  //       fontWeight: FontWeight.normal),
                                  // ),
                                  label: Text("Execute scripts"),
                                  icon: Icon(Icons.play_arrow))
                              : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: scriptArray.length,
                    itemBuilder: (context, i) {
                      print(
                          "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/tests/${scriptArray[i]}");
                      return SpecCard(
                        script:
                            "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/tests/${scriptArray[i]}",
                        tab: widget.tab,
                        activeProject: activeProject,
                        executeScript: executeScript,
                        showPopup: _showPopup,
                      );
                    },
                  ),
                ),
              ])
            : scriptArray.isEmpty && activeProjectId > 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset('assets/images/noProjectFound.json',
                          width: 100, height: 100),
                      Text("No scripts found.", style: textStyle16WithBold),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "It seems you have not created any script yet.",
                        style: textStyle16WithoutBold,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async => {_showInitPopup()},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          textStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                        child: Text("Create new script"),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset('assets/images/noProjectFound.json',
                          width: 100, height: 100),
                      Text("No scripts found.", style: textStyle16WithBold),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "It seems that either you do not have a project created \nor no project has been set as active.",
                        style: textStyle16WithoutBold,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
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
    for (var item in widget.browserList) {
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
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
