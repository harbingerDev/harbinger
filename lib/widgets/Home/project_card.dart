// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/projects.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.projects});
  final Projects projects;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide.none,
            top: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(
                color: Color(0xffE95622), style: BorderStyle.solid, width: 4),
          ),
          color: Colors.white.withOpacity(.3),
          // borderRadius: BorderRadius.all(
          //   Radius.circular(20),
          // ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform(
                      transform: Matrix4.identity()..scale(0.8),
                      child: Chip(
                        elevation: 1,
                        label: Text(
                          "Playwright",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              color: Colors.black, fontSize: 15),
                        ),
                        backgroundColor: Colors.black87.withOpacity(.2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform(
                      transform: Matrix4.identity()..scale(0.8),
                      child: Chip(
                        elevation: 1,
                        label: Text(
                          "Active",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        backgroundColor: Colors.green.withOpacity(.2),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  projects.projectName,
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white.withOpacity(.2),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Browsers: ",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500)),
                              Text("Chrome, Edge, Safari")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Parallel: ",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500)),
                              Text("True")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Environments: ",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500)),
                              Text("QA, Staging, UAT")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          child: Row(
                            children: [
                              Text("Path: ",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500)),
                              Expanded(
                                child: Tooltip(
                                  message: projects.projectPath,
                                  child: Text(
                                    projects.projectPath,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Default folder: ",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500)),
                              Text("/tests")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
