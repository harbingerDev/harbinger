// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/TestReport/test_report_viewer.dart';

class TestReports extends StatefulWidget {
  const TestReports({super.key});

  @override
  State<TestReports> createState() => _TestReportsState();
}

class _TestReportsState extends State<TestReports> {
  @override
  @override
  Widget build(BuildContext context) {
    // return TestScript(tab: "plan");
    return DefaultTabController(
      length: 2, // The number of tabs
      child: Column(
        children: [
          Container(
            color: Colors.black38,
            child: TabBar(
              dividerColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              indicatorColor: Color(0xffE95622),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xffE95622),
              ),
              tabs: [
                Tab(
                    icon: Text("Local report",
                        style: GoogleFonts.roboto(fontSize: 16))),
                Tab(
                    icon: Text("Report portal",
                        style: GoogleFonts.roboto(fontSize: 16))),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                TestReportViewer(
                  type: "local",
                ),
                TestReportViewer(type: "web"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
