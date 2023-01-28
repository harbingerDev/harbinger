// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../widgets/TestPlan/test_script.dart';

class TestPlanScreen extends StatefulWidget {
  const TestPlanScreen({super.key});

  @override
  State<TestPlanScreen> createState() => _TestPlanScreenState();
}

class _TestPlanScreenState extends State<TestPlanScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TestScript(tab: "plan");
  }
}
