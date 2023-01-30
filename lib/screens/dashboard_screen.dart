// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:flutter/material.dart';
import 'package:harbinger/screens/home_screen.dart';
import 'package:harbinger/screens/test_lab_screen.dart';
import 'package:harbinger/screens/test_plan_screen.dart';
import 'package:harbinger/screens/test_reports_screen.dart';

import '../assets/constants.dart';
import '../helpers/helper_functions.dart';
import '../widgets/Common/loader_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool loading = false;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: <Widget>[
          NavigationRail(
              useIndicator: true,
              indicatorColor: Colors.grey.withOpacity(.1),
              leading: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          "https://xsgames.co/randomusers/avatar.php?g=male",
                          height: 50,
                          width: 50,
                        )),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.grey[100],
                      height: 2,
                      width: 60,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          scale: 10,
                          "assets/images/logo.png",
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
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
                          : Expanded(child: TestLabScreen()),
        ],
      ),
    );
  }
}
