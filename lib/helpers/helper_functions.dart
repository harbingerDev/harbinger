// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './../assets/constants.dart';

List<NavigationRailDestination> getNavigationRailItems() {
  List<NavigationRailDestination> navigationRailItemsArray = [];
  for (var element in navigationRailItems) {
    navigationRailItemsArray.add(
      NavigationRailDestination(
        icon: Icon(element["icon"]),
        selectedIcon:
            Icon(element["selectedIcon"], color: element["selectedIconColor"]),
        label: Padding(
          padding: standardPadding,
          child: Text(element["text"], style: textStyle12WithoutBold),
        ),
      ),
    );
  }
  return navigationRailItemsArray;
}
