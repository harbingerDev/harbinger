import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final navigatorKey = GlobalKey<NavigatorState>();

class TestReportViewer extends StatefulWidget {
  final String type;
  const TestReportViewer({super.key, required this.type});

  @override
  State<TestReportViewer> createState() => _TestReportViewerState();
}

class _TestReportViewerState extends State<TestReportViewer> {
  bool isLoading = true;
  bool loaded = false;
  int activeProjectId = 0;
  late List<Map<String, dynamic>> activeProject;
  final _textController = TextEditingController();
  late html.IFrameElement _iframeElement;
  late Widget _iframeWidget;
  final _key = UniqueKey();
  String htmlFileContent = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeProjectId = prefs.getInt('activeProject')!;
      String allProjects = prefs.getString('projectsObject')!;
      List<Map<String, dynamic>> allProjectsCasted =
          json.decode(allProjects).cast<Map<String, dynamic>>();
      activeProject = activeProjectId != 0
          ? allProjectsCasted
              .where((project) => project['id'] == activeProjectId)
              .toList()
          : [];
    });
    final fileContent =
        await http.post(Uri.parse('http://localhost:1337/readFile'), body: {
      'path':
          '${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/playwright-report/index.html'
    });
    setState(() {
      htmlFileContent = fileContent.body;
    });
    if (widget.type != "local") {
      _iframeElement = html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = "http://10.10.90.150:8080/ui/#superadmin_personal/launches/all"
        ..style.border = 'none';
    } else {
      _iframeElement = html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..srcdoc = htmlFileContent
        ..style.border = 'none';
    }

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _key.toString(),
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      viewType: _key.toString(),
    );

    _textController.text = _iframeElement.src!;
    setState(() {
      isLoading = false;
    });
  }

  Widget compositeView() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            color: Colors.transparent,
            elevation: 0,
            child: Row(children: [
              Expanded(
                  child: Text("Playwright test report",
                      style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87))),
              IconButton(
                icon: Icon(Icons.refresh),
                splashRadius: 20,
                onPressed: () {
                  _iframeElement.src = _iframeElement.src!;
                },
              ),
            ]),
          ),
          Expanded(
              child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: _iframeWidget)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : compositeView(),
      ),
    );
  }
}
