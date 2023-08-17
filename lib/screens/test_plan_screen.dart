// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/TestPlan/data_repository.dart';
import '../widgets/TestPlan/object_repository.dart';
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
    // return TestScript(tab: "plan");
    return DefaultTabController(
      length: 3, // The number of tabs
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              // dividerColor: Colors.white,
              // labelColor: Colors.white,
              // unselectedLabelColor: Colors.white.withOpacity(0.7),
              // indicatorColor: Color(0xffE95622),
              // indicator: BoxDecoration(
              //   borderRadius: BorderRadius.circular(4),
              //   color: Color(0xffE95622),
              // ),
              tabs: [
                Tab(
                    icon: Text("Scripts",
                        style: GoogleFonts.roboto(fontSize: 16))),
                Tab(
                    icon: Text("Object repository",
                        style: GoogleFonts.roboto(fontSize: 16))),
                Tab(
                    icon:
                        Text("Data", style: GoogleFonts.roboto(fontSize: 16))),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                TestScript(tab: "plan"),
                ObjectRepository(),
                EditableDataRepoScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
