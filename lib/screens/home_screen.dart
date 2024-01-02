// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/Home/dashboard_no_tests_widget.dart';
import 'package:harbinger/widgets/TestPlan/git_operations.dart';
import 'package:harbinger/widgets/TestPlan/view_jenkins_jobs.dart';

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
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
                color: Colors.white,
                child: TabBar(
                  tabs: [
                    Tab(
                        icon: Text("Projects",
                            style: GoogleFonts.roboto(fontSize: 16))),
                    Tab(
                        icon: Text("Version control",
                            style: GoogleFonts.roboto(fontSize: 16))),
                    Tab(
                        icon: Text("CI/CD",
                            style: GoogleFonts.roboto(fontSize: 16))),
                  ],
                )),
            Expanded(
              child: TabBarView(
                children: [
                  NoTestsWidget(),
                  GitOperationsScreen(),
                  JenkinsJobsScreen()
                ],
              ),
            ),
          ],
        ));
  }
}
