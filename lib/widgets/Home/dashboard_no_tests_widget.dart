// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/create_import_buttons.dart';
import 'package:harbinger/widgets/Home/greetings.dart';
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
    await projectsBox.close();
    getProjectData();
  }

  @override
  Widget build(BuildContext context) {
    return projectDataList.length > 0
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
                        padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
                        child: Chip(
                          elevation: 1,
                          backgroundColor: Colors.green.withOpacity(.2),
                          label: Text(
                            "Node version - 15.2",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Chip(
                          elevation: 1,
                          backgroundColor: Colors.green.withOpacity(.2),
                          label: Text("Git version - 2.2"),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: CreateImportButtons(
                      onClickDone: onClickDone,
                      projectDataLength: projectDataList.length,
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
                      childAspectRatio: .8,
                      crossAxisCount: MediaQuery.of(context).size.width > 1300
                          ? 5
                          : MediaQuery.of(context).size.width > 1200
                              ? 4
                              : 3,
                      crossAxisSpacing: 4),
                  children: projectDataList
                      .map((e) => ProjectCard(
                            projects: e,
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
              )
            ],
          );
  }
}
