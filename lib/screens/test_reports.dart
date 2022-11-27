import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

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

  Future<dom.Document> parseHtml() async {
    return parse(
        await File('C:\\playwright_check\\playwright-report\\index.html')
            .readAsString());
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
