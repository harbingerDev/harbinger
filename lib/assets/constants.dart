import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const themeColor = Color(0xff285981);
List<Map<String, dynamic>> navigationRailItems = [
  {
    "icon": Icons.home,
    "selectedIcon": Icons.home_filled,
    "selectedIconColor": themeColor,
    "text": "Home"
  },
  {
    "icon": Icons.account_tree_outlined,
    "selectedIcon": Icons.account_tree,
    "selectedIconColor": themeColor,
    "text": "Test plan"
  },
  {
    "icon": Icons.science_outlined,
    "selectedIcon": Icons.science,
    "selectedIconColor": themeColor,
    "text": "Test lab"
  },
  {
    "icon": Icons.bar_chart_outlined,
    "selectedIcon": Icons.bar_chart,
    "selectedIconColor": themeColor,
    "text": "Reports"
  },
  {
    "icon": Icons.settings_outlined,
    "selectedIcon": Icons.settings,
    "selectedIconColor": themeColor,
    "text": "Settings"
  }
];

TextStyle textStyle12WithoutBold = GoogleFonts.roboto(
  fontSize: 12,
  color: themeColor,
);
TextStyle textStyle16WithoutBold = GoogleFonts.roboto(
  fontSize: 16,
  color: themeColor,
);

const standardPadding = EdgeInsets.all(8.0);
const backgroundColor = Color(0xFFE8E8E8);
