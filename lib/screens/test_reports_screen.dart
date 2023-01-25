import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/TestReport/test_report_viewer.dart';

class TestReports extends StatefulWidget {
  const TestReports({super.key});

  @override
  State<TestReports> createState() => _TestReportsState();
}

class _TestReportsState extends State<TestReports> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: TestReportViewer()),
      ],
    );
  }
}
