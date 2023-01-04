// ignore_for_file: prefer_const_constructors

import 'dart:io' as io;
import 'package:harbinger/widgets/TestPlan/test_spec.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import '../widgets/TestPlan/test_script.dart';

class TestPlanScreen extends StatefulWidget {
  const TestPlanScreen({super.key});

  @override
  State<TestPlanScreen> createState() => _TestPlanScreenState();
}

class _TestPlanScreenState extends State<TestPlanScreen> {
  late String directory;
  // ignore: deprecated_member_use
  late List file;
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    setState(() {
      file = io.Directory("C:/playwright_check/tests").listSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TestScript(
      specName: "x",
    );
  }
}
