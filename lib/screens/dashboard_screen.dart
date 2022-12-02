// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/screens/home_screen.dart';
import 'package:harbinger/screens/test_plan_screen.dart';
import 'package:harbinger/screens/test_reports.dart';
import 'package:harbinger/widgets/loader_widget.dart';
import 'package:process_run/shell.dart';

import '../assets/constants.dart';
import '../helpers/helper_functions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool loading = true;
  bool isFirstTime = true;
  var shell = Shell();
  var nodeVersion;

  getNodeVersion() async {
    await shell.run('''
    node -v
    ''').then((result) => {
          setState(() {
            nodeVersion = result.first.outText;
            loading = false;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    getNodeVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: <Widget>[
          NavigationRail(
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IconButton(
                        icon: const Icon(Icons.rocket_launch,
                            color: themeColor, size: 25),
                        onPressed: () {}),
                  ),
                ),
              ),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: getNavigationRailItems()),
          VerticalDivider(thickness: 1, width: 1),
          //Navigation rail handler
          loading
              ? LoaderWidget()
              : _selectedIndex == 0
                  ? Expanded(child: HomeScreen())
                  : _selectedIndex == 1
                      ? Expanded(child: TestPlanScreen())
                      : _selectedIndex == 3
                          ? Expanded(child: TestReports())
                          : Container(),
        ],
      ),
    );
  }
}
