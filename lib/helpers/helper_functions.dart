// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbinger/assets/config.dart';

import './../assets/constants.dart';

List<NavigationRailDestination> getNavigationRailItems(role) {
  print(role);
  List<Map<String, dynamic>> railItems = [
    {
      "icon": Icons.home,
      "selectedIcon": Icons.home_filled,
      "selectedIconColor": themeColor,
      "text": "PA"
    },
    {
      "icon": Icons.account_tree_outlined,
      "selectedIcon": Icons.account_tree,
      "selectedIconColor": themeColor,
      "text": "Test plan"
    }
  ];
  if (role == AppConfig.PROJECTADMIN) {
    railItems = projectAdminNavigationRailItems;
  } else if (role == AppConfig.SUPERADMIN) {
    railItems = superAdminNavigationRailItems;
  } else if (role == AppConfig.ORGADMIN) {
    railItems = orgAdminNavigationRailItems;
  } else if (role == AppConfig.PROJECTMEMBER) {
    railItems = projectMemberNavigationRailItems;
  }

  List<NavigationRailDestination> navigationRailItemsArray = [];
  for (var element in railItems) {
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
