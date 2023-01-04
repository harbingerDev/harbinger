// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowCode extends StatefulWidget {
  final String filePath;
  ShowCode({required this.filePath});

  @override
  State<ShowCode> createState() => _ShowCodeState();
}

class _ShowCodeState extends State<ShowCode> {
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
                            child: SyntaxView(
                              code: fileContent.toString(), // Code text
                              syntax: Syntax.JAVASCRIPT, // Language
                              syntaxTheme: SyntaxTheme.vscodeLight(), // Theme
                              fontSize: 14.0, // Font size
                              withZoom:
                                  false, // Enable/Disable zoom icon controls
                              withLinesCount:
                                  true, // Enable/Disable line number
                              expanded:
                                  false, // Enable/Disable container expansion
                            ),
                          )
                          // HighlightView(
                          //   tabSize: 16,
                          //   language: "javascript",
                          //   theme: githubTheme,
                          //   padding: EdgeInsets.all(12),
                          //   textStyle: GoogleFonts.roboto(
                          //     fontSize: 16,
                          //   ),
                          //   fileContent.toString(),
                          // ),
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
