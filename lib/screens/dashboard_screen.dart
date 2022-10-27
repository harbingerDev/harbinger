// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/widgets/loader_widget.dart';
import 'package:process_run/shell.dart';
import 'dart:developer';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      backgroundColor: Color(0xFFE8E8E8),
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
                          color: Color(0xff285981), size: 25),
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
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home_filled, color: Color(0xff285981)),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Home',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Color(0xff285981),
                    ),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_tree_outlined),
                selectedIcon:
                    Icon(Icons.account_tree, color: Color(0xff285981)),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Test plan',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Color(0xff285981),
                    ),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.science_outlined),
                selectedIcon: Icon(Icons.science, color: Color(0xff285981)),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Test lab',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Color(0xff285981),
                    ),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart, color: Color(0xff285981)),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reports',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Color(0xff285981),
                    ),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings, color: Color(0xff285981)),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Settings',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Color(0xff285981),
                    ),
                  ),
                ),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          loading
              ? LoaderWidget()
              : Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  // // border: Border.all(
                                  // //   color: Color(0xff285981),
                                  // ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2.0,
                                    ),
                                  ]),
                              width: MediaQuery.of(context).size.width * .1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Node version",
                                      style: GoogleFonts.roboto(
                                        fontSize: 10,
                                        color: Color(0xff285981),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      nodeVersion,
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff285981),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
