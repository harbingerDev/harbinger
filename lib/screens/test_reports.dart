import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:path_provider/path_provider.dart';

class TestReports extends StatefulWidget {
  const TestReports({super.key});

  @override
  State<TestReports> createState() => _TestReportsState();
}

class _TestReportsState extends State<TestReports> {
  @override
  void initState() {
    parseHtml();
    super.initState();
  }

  Future<String> _read() async {
    String text = "";
    try {
      final File file =
          File('C:\\playwright_check\\playwright-report\\index.html');
      text = await file.readAsString();
    } catch (e) {
      print(e.toString());
    }

    return text;
  }

  Future<dom.Document> parseHtml() async {
    return parse(await _read());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<dom.Document>(
              future: parseHtml(),
              builder:
                  (BuildContext context, AsyncSnapshot<dom.Document> snapshot) {
                if (snapshot.hasData) {
                  return Html(data: snapshot.data?.outerHtml);
                } else {
                  return const Center(
                    child: Text("Loading"),
                  );
                }
              }),
        )
      ],
    );
  }
}
