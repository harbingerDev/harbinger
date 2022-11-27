// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/create_import_buttons.dart';
import 'package:harbinger/widgets/Home/project_card.dart';
import 'package:harbinger/widgets/Home/project_popup.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../../assets/constants.dart';
import '../../models/projects.dart';

class NoTestsWidget extends StatefulWidget {
  const NoTestsWidget({super.key});

  @override
  State<NoTestsWidget> createState() => _NoTestsWidgetState();
}

class _NoTestsWidgetState extends State<NoTestsWidget> {
  late List<Projects> projectDataList;
  bool doProjectsExist = false;
  void getProjectData() async {
    var projectsBox = await Hive.openBox<Projects>('projects');
    var projectList = await Hive.box<Projects>('projects').values.toList();
    await projectsBox.close();
    setState(() {
      projectDataList = projectList;
    });
  }

  @override
  void initState() {
    super.initState();

    getProjectData();
  }

  void onClickDone(String projectName, String projectPath) async {
    var projectsBox = await Hive.openBox<Projects>('projects');
    final projects = Projects()
      ..isActive = true
      ..projectName = projectName
      ..projectPath = projectPath;
    projectsBox.add(projects);
    print(projectsBox.length);
    await projectsBox.close();
    getProjectData();
  }

  @override
  Widget build(BuildContext context) {
    return projectDataList.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                child: CreateImportButtons(
                  onClickDone: onClickDone,
                  projectDataLength: projectDataList.length,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: projectDataList
                        .map((e) => ProjectCard(
                              projects: e,
                            ))
                        .toList(),
                  ),
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
              )
            ],
          );
  }
}
