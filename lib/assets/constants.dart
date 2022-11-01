import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const themeColor = Color(0xff285981);
List<Map<String, dynamic>> navigationRailItems = [
  {
    "icon": Icons.home,
    "selectedIcon": Icons.home_filled,
    "selectedIconColor": themeColor
  },
  {
    "icon": Icons.account_tree_outlined,
    "selectedIcon": Icons.account_tree,
    "selectedIconColor": themeColor
  },
  {
    "icon": Icons.science_outlined,
    "selectedIcon": Icons.science,
    "selectedIconColor": themeColor
  },
  {
    "icon": Icons.bar_chart_outlined,
    "selectedIcon": Icons.bar_chart,
    "selectedIconColor": themeColor
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
