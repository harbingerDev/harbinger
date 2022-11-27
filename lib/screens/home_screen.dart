// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbinger/widgets/Home/dashboard_no_tests_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/projects.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool doesProjectExist = false;
  @override
  void initState() {
    super.initState();
    Hive.openBox<Projects>('projects');
  }

  @override
  void dispose() async {
    super.dispose();
    await Hive.box('projects').close();
  }

  @override
  Widget build(BuildContext context) {
    return doesProjectExist ? Container() : NoTestsWidget();
  }
}
