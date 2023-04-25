// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/main.dart';
import 'package:harbinger/models/testScriptModel.dart';
import 'package:harbinger/widgets/TestPlan/editor_views.dart';
import 'package:harbinger/widgets/TestPlan/show_code.dart';
import 'package:harbinger/widgets/TestPlan/show_code_GPT.dart';
import 'package:harbinger/widgets/TestPlan/show_steps.dart';
import 'package:harbinger/widgets/TestPlan/show_steps_updated.dart';

class TestBlockCard extends StatefulWidget {
  final TestScriptModel testScriptModel;
  final int testIndex;
  final Function(int, int) moveUp;
  final Function(int, int) moveDown;
  const TestBlockCard({
    super.key,
    required this.testScriptModel,
    required this.testIndex,
    required this.moveUp,
    required this.moveDown,
  });

  @override
  State<TestBlockCard> createState() => _TestBlockCardState();
}

class _TestBlockCardState extends State<TestBlockCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide.none,
                top: BorderSide.none,
                right: BorderSide.none,
                left: BorderSide(
                    color: Color(0xffE95622),
                    style: BorderStyle.solid,
                    width: 2),
              ),
              color: Colors.white.withOpacity(.3),
              // borderRadius: BorderRadius.all(
              //   Radius.circular(20),
              // ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.testScriptModel!
                                .testBlockArray![widget.testIndex].testName!,
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Wrap(
                        spacing: 10.0, // space between each chip
                        children: List<Widget>.generate(
                            widget
                                .testScriptModel
                                .testBlockArray![widget.testIndex]
                                .testTags!
                                .length, (int index) {
                          return Chip(
                            label: Text(
                              widget
                                  .testScriptModel
                                  .testBlockArray![widget.testIndex]
                                  .testTags![index],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          child: Text("Change test script name"),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: widget.testScriptModel.testBlockArray![widget.testIndex]
              .testStepsArray!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(
                        color: Color(0xffE95622).withOpacity(.2),
                        style: BorderStyle.solid,
                        width: 50),
                  ),
                  color: Colors.white.withOpacity(.3),
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(20),
                  // ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .6,
                              child: Text(
                                widget
                                    .testScriptModel
                                    .testBlockArray![widget.testIndex]
                                    .testStepsArray![index]
                                    .humanReadableStatement!,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(widget
                                          .testScriptModel
                                          .testBlockArray![widget.testIndex]
                                          .testStepsArray![index]
                                          .humanReadableStatement!),
                                      content: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                widget
                                                    .testScriptModel
                                                    .testBlockArray![
                                                        widget.testIndex]
                                                    .testStepsArray![index]
                                                    .statement!,
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  })
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "View code",
                                  child: Icon(Icons.code_outlined)),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                {widget.moveUp(widget.testIndex, index)},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "Move up",
                                  child: Icon(Icons.move_up_outlined)),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                {widget.moveDown(widget.testIndex, index)},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "Move down",
                                  child: Icon(Icons.move_down_outlined)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                                message: "Add step",
                                child: Icon(Icons.add_outlined)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                                message: "Edit step",
                                child: Icon(Icons.edit_outlined)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                                message: "Delete step",
                                child: Icon(Icons.delete_outline)),
                          )
                        ],
                      )
                    ]),
              ),
            );
          },
        ),
      ],
    );
  }
}
