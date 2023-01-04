// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:harbinger/widgets/Common/loader_widget.dart';
import 'package:harbinger/widgets/TestPlan/show_code.dart';
import 'package:harbinger/widgets/TestPlan/show_steps.dart';

class SpecCard extends StatefulWidget {
  const SpecCard({super.key, required this.script});
  final String script;

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
                    Tooltip(
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
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Tooltip(
                      message: "Edit script",
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.edit_note_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowSteps(
                                  filePath: widget.script,
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Tooltip(
                        message: "Execute script",
                        child: Icon(Icons.play_arrow_outlined))
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
