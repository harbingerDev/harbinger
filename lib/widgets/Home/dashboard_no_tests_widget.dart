// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:harbinger/widgets/Common/loader_widget.dart';
import 'package:harbinger/widgets/Home/create_import_buttons.dart';
import 'package:harbinger/widgets/Home/project_card.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../assets/constants.dart';
import '../../models/project.dart';

class NoTestsWidget extends StatefulWidget {
  const NoTestsWidget({super.key});

  @override
  State<NoTestsWidget> createState() => _NoTestsWidgetState();
}

class _NoTestsWidgetState extends State<NoTestsWidget> {
  bool loaded = false;
  var projects;
  var activeProject;
  var gitVersion;
  List<Project> projectDataList = [];
  bool doProjectsExist = false;
  void activateProjectCallback(String projectId) {
    activateProject(projectId);
  }

  Future<void> activateProject(String projectId) async {
    setState(() {
      loaded = false;
    });
    final url = Uri.parse('http://localhost:1337/projects/activate/$projectId');
    final response = await http.put(url);

    if (response.statusCode == 200) {
      // Success: the API call was successful
      print('Project $projectId has been activated');
      await _getData();
      setState(() {
        loaded = true;
      });
    } else {
      // Error: the API call failed
      print('Failed to activate project $projectId: ${response.reasonPhrase}');
    }
  }

  Future<void> _getData() async {
    projectDataList = [];
    var projectsUrl = Uri.parse("http://127.0.0.1:1337/projects/getProjects");
    var activeProjectUrl =
        Uri.parse("http://127.0.0.1:1337/projects/getActiveProject");
    var gitUrl = Uri.parse("http://127.0.0.1:1337/system/checkGitVersion");
    final responses = await Future.wait(
        [http.get(projectsUrl), http.get(activeProjectUrl), http.get(gitUrl)]);
    if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('projectsObject', responses[0].body);
      await prefs.setInt(
          'activeProject',
          json.decode(responses[1].body).length > 0
              ? json.decode(responses[1].body)[0]['id']
              : 0);
      setState(() {
        if (responses[0].body.isEmpty) {
          loaded = true;
        } else {
          (jsonDecode(responses[0].body)).forEach((element) {
            projectDataList.add(Project.fromJson(element));
          });
          activeProject = json.decode(responses[1].body).length > 0
              ? json.decode(responses[1].body)[0]['id']
              : 0;
          gitVersion = json.decode(responses[2].body)["gitVersion"];
          loaded = true;
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _postAndGetProject(Map<String, dynamic> projectObject) async {
    setState(() {
      loaded = false;
    });
    final headers = {'Content-Type': 'application/json'};
    var projectCreationUrl =
        Uri.parse("http://127.0.0.1:1337/projects/createProject");
    var projectsUrl = Uri.parse("http://127.0.0.1:1337/projects/getProjects");
    final creationResponse = await Future.wait([
      http.post(
        projectCreationUrl,
        body: json.encode(projectObject),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    var activateProjectUrl = Uri.parse(
        "http://127.0.0.1:1337/projects/activate/${json.decode(creationResponse[0].body)['id']}");
    await http.put(activateProjectUrl);
    await _getData();
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onClickDone(Map<String, dynamic> projectObject) async {
    await _postAndGetProject(projectObject);
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? LoaderWidget()
        : projectDataList.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Chip(
                              elevation: 1,
                              backgroundColor: Colors.green.withOpacity(.2),
                              label: Text("$gitVersion"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: CreateImportButtons(
                          onClickDone: onClickDone,
                          projectDataLength: projectDataList.length,
                          calledFrom: "home",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: .65,
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 1300
                                  ? 5
                                  : MediaQuery.of(context).size.width > 1200
                                      ? 4
                                      : 3,
                          crossAxisSpacing: 4),
                      children: projectDataList
                          .map((e) => ProjectCard(
                                projects: e,
                                activeProject: activeProject,
                                activateProject: activateProjectCallback,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/images/noProjectFound.json',
                      width: 100, height: 100),
                  Text("No projects found.", style: textStyle16WithoutBold),
                  SizedBox(
                    height: 40,
                  ),
                  CreateImportButtons(
                    onClickDone: onClickDone,
                    projectDataLength: projectDataList.length,
                    calledFrom: "home",
                  )
                ],
              );
  }
}
