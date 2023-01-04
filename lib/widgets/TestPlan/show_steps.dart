// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowSteps extends StatefulWidget {
  final String filePath;
  ShowSteps({required this.filePath});

  @override
  State<ShowSteps> createState() => _ShowStepsState();
}

class _ShowStepsState extends State<ShowSteps> {
  bool isLoaded = false;
  late String fileContent;

  Future<String> readFileAsString(String filePath) async {
    return File(widget.filePath).readAsString();
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
    return Scaffold(
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
      backgroundColor: Colors.white,
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
                        left: BorderSide(
                            color: Color(0xffE95622),
                            style: BorderStyle.solid,
                            width: 10),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stepper(
                              // Specify the type of stepper as horizontal
                              type: StepperType.vertical,
                              // List the steps you want to display
                              steps: [
                                Step(
                                  isActive: true,
                                  // Specify the title of the step
                                  title: Text('Step 1'),
                                  // Specify the content for the step
                                  content:
                                      Text('This is the content for step 1'),
                                ),
                                Step(
                                  title: Text('Step 2'),
                                  content:
                                      Text('This is the content for step 2'),
                                ),
                                Step(
                                  title: Text('Step 3'),
                                  content:
                                      Text('This is the content for step 3'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Text("Loading"),
    );
  }
}
