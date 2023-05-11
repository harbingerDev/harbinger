// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, deprecated_member_use, prefer_collection_literals, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/assets/constants.dart';
import 'package:harbinger/widgets/TestPlan/spec_card.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  _showPopup(String specName) async {
    var _controller = new TextEditingController(text: specName);
    scriptName = _controller.text;
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
                TextField(
                  readOnly: specName == "" ? false : true,
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Enter spec name"),
                  onChanged: (value) {
                    scriptName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: "Enter test name"),
                  onChanged: (value) {
                    testName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText:
                          "Enter tags for test (eg. @smoke,@functionalComponent)"),
                  onChanged: (value) {
                    tags = value;
                  },
                ),
                TextField(
                  decoration:
                      InputDecoration(hintText: "Enter application url"),
                  onChanged: (value) {
                    url = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await recordScript();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
              child: Text("Start recording"),
            ),
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
                          ? ElevatedButton(
                              onPressed: () async => {_showPopup("")},
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
                            )
                          : widget.tab == "lab"
                              ? ElevatedButton(
                                  onPressed: () async =>
                                      {await executeScripts()},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    textStyle: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  child: Text("Execute scripts"),
                                )
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
                      return SpecCard(
                        script:
                            "${activeProject[0]["project_path"]}\\${activeProject[0]["project_name"]}\\tests\\${scriptArray[i]}",
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
                        onPressed: () async => {_showPopup("")},
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
