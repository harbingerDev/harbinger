// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbinger/widgets/Home/dashboard_no_tests_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoTestsWidget();
  }
}
