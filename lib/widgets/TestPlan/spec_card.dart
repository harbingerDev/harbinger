// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/main.dart';
import 'package:harbinger/widgets/TestPlan/editor_views.dart';
import 'package:harbinger/widgets/TestPlan/show_code.dart';
import 'package:harbinger/widgets/TestPlan/show_code_GPT.dart';
import 'package:harbinger/widgets/TestPlan/show_steps.dart';
import 'package:harbinger/widgets/TestPlan/show_steps_updated.dart';

class SpecCard extends StatefulWidget {
  const SpecCard(
      {super.key,
      required this.script,
      required this.tab,
      required this.activeProject,
      required this.executeScript,
      required this.showPopup});
  final String script;
  final String tab;
  final List<Map<String, dynamic>> activeProject;
  final Function(String scriptName) executeScript;
  final Function(String specName) showPopup;

  @override
  State<SpecCard> createState() => _SpecCardState();
}

class _SpecCardState extends State<SpecCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide.none,
            top: BorderSide.none,
            right: BorderSide.none,
            left: BorderSide(
                color: Color(0xffE95622), style: BorderStyle.solid, width: 2),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.script.split("\\").last,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // widget.tab == "plan"
                    //     ? Tooltip(
                    //         message: "View script GPT",
                    //         child: IconButton(
                    //             padding: EdgeInsets.zero,
                    //             icon: Icon(Icons.code),
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => ShowCodeGPT(
                    //                     filePath: widget.script,
                    //                   ),
                    //                 ),
                    //               );
                    //             }),
                    //       )
                    //     : Container(),
                    widget.tab == "plan"
                        ? Tooltip(
                            message: "View script",
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.code),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowCode(
                                        filePath: widget.script,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                    widget.tab == "plan"
                        ? Consumer(
                            builder: (_, WidgetRef ref, __) {
                              return Tooltip(
                                message: "View script updated",
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.code),
                                    onPressed: () {
                                      ref.read(screenProvider.notifier).state =
                                          "Code";
                                      ref
                                          .read(filePathProvider.notifier)
                                          .state = widget.script;
                                    }),
                              );
                            },
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    widget.tab == "plan"
                        ? Tooltip(
                            message: "new edit view",
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.edit_note_outlined),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowStepsUpdated(
                                        filePath: widget.script,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    widget.tab == "plan"
                        ? Tooltip(
                            message: "Edit script",
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.edit_note_outlined),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditorViews(
                                        filePath: widget.script,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    widget.tab == "plan"
                        ? Tooltip(
                            message: "add test",
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add_task_outlined),
                                onPressed: () async {
                                  await widget.showPopup(widget.script
                                      .split("\\")
                                      .last
                                      .split(".")
                                      .first);
                                }),
                          )
                        : Container(),
                    widget.tab != "plan"
                        ? Tooltip(
                            message: "Execute script",
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.play_arrow_outlined),
                                onPressed: () async {
                                  await widget.executeScript(
                                      widget.script.split("\\").last);
                                }))
                        : Container()
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
