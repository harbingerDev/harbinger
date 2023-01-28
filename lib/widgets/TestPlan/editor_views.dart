// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/models/codeStructure.dart';
import 'package:http/http.dart' as http;
import '../Common/loader_widget.dart';

class EditorViews extends StatefulWidget {
  const EditorViews({super.key, required this.filePath});
  final String filePath;

  @override
  State<EditorViews> createState() => _EditorViewsState();
}

class _EditorViewsState extends State<EditorViews> {
  bool loaded = false;
  late String fileContent;
  late List<CodeStructure> codeStructure;
  late List<Map<String, List<List<dynamic>>>> tableData;
  Future<String> readFileAsString(String filePath) async {
    Map<String, String> executeScriptPayload = {"path": widget.filePath};
    final headers = {'Content-Type': 'application/json'};
    var getASTUrl = Uri.parse("http://localhost:1337/ast/getASTFromFile");
    final getASTResponse = await Future.wait([
      http.post(
        getASTUrl,
        body: json.encode(executeScriptPayload),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);
    setState(() {
      codeStructure = json.decode(getASTResponse[0].body);
    });
    return File(widget.filePath).readAsString();
  }

  prepareData() {
    codeStructure.forEach((element) {
      element.statements!.forEach((val) {
        for (var i = (val.start! - 1); i < (val.end! - 1); i++) {}
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readFileAsString(widget.filePath).then((content) {
      setState(() {
        fileContent = content;
        loaded = true;
      });
    }).then((content) {
      setState(() {
        prepareData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: loaded
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
                          left: BorderSide.none),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : LoaderWidget(),
    );
  }
}
