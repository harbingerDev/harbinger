import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const themeColor = Colors.black87;
List<Map<String, dynamic>> projectAdminNavigationRailItems = [
  {
    "icon": Icons.home,
    "selectedIcon": Icons.home_filled,
    "selectedIconColor": themeColor,
    "text": ""
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
  },
  {
    "icon": Icons.logout_outlined,
    "selectedIcon": Icons.logout_rounded,
    "selectedIconColor": themeColor,
    "text": "Logout"
  },
];

List<Map<String, dynamic>> superAdminNavigationRailItems = [
  {
    "icon": Icons.home,
    "selectedIcon": Icons.home_filled,
    "selectedIconColor": themeColor,
    "text": "SA"
  },
  {
    "icon": Icons.admin_panel_settings_sharp,
    "selectedIcon": Icons.admin_panel_settings_outlined,
    "selectedIconColor": themeColor,
    "text": "Adminstrate"
  },
  {
    "icon": Icons.supervised_user_circle_sharp,
    "selectedIcon": Icons.supervised_user_circle_outlined,
    "selectedIconColor": themeColor,
    "text": "Users"
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
  },
  {
    "icon": Icons.logout_outlined,
    "selectedIcon": Icons.logout_rounded,
    "selectedIconColor": themeColor,
    "text": "Logout"
  },
];

List<Map<String, dynamic>> orgAdminNavigationRailItems = [
  {
    "icon": Icons.dashboard_customize_outlined,
    "selectedIcon": Icons.dashboard_customize_sharp,
    "selectedIconColor": themeColor,
    "text": "OA"
  },
  {
    "icon": Icons.checklist_sharp,
    "selectedIcon": Icons.checklist_rtl_sharp,
    "selectedIconColor": themeColor,
    "text": "Projects"
  },
  {
    "icon": Icons.people_outline_outlined,
    "selectedIcon": Icons.people_alt,
    "selectedIconColor": themeColor,
    "text": "Employees"
  },
  {
    "icon": Icons.add_moderator_outlined,
    "selectedIcon": Icons.admin_panel_settings,
    "selectedIconColor": themeColor,
    "text": "Profile"
  },
  {
    "icon": Icons.settings_outlined,
    "selectedIcon": Icons.settings,
    "selectedIconColor": themeColor,
    "text": "Settings"
  },
  {
    "icon": Icons.logout_outlined,
    "selectedIcon": Icons.logout_rounded,
    "selectedIconColor": themeColor,
    "text": "Logout"
  },
];
List<Map<String, dynamic>> projectMemberNavigationRailItems = [
  {
    "icon": Icons.home,
    "selectedIcon": Icons.home_filled,
    "selectedIconColor": themeColor,
    "text": "PM"
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
  },
  {
    "icon": Icons.logout_outlined,
    "selectedIcon": Icons.logout_rounded,
    "selectedIconColor": themeColor,
    "text": "Logout"
  },
];

TextStyle textStyle12WithoutBold = GoogleFonts.roboto(
  fontSize: 12,
  color: themeColor,
);
TextStyle textStyle16WithoutBold = GoogleFonts.roboto(
  fontSize: 16,
  color: themeColor,
);
TextStyle textStyle16WithBold = GoogleFonts.roboto(
    fontSize: 16, color: themeColor, fontWeight: FontWeight.bold);

const standardPadding = EdgeInsets.all(8.0);
const backgroundColor = Color(0xFFE8E8E8);

List<String> availableLocatorStrategies = [
  "getByRole",
  "getByLabel",
  "getByPlaceholder",
  "getByText",
  "getByAltText",
  "getByTitle",
  "getByTestId",
  "filter",
  "frameLocator",
  "locator",
  "nth",
  "null"
];
List<String> availableStepTypes = [
  "AwaitExpression",
  "VariableDeclaration",
  "IfLoop",
  "ForLoop",
  "VerificationStatement",
  "TestOptions"
];
List<String> availableActions = [
  "goto",
  "click",
  "tap",
  "fill",
  "selectOption",
  "selectText",
  "check",
  "setChecked",
  "uncheck",
  "hover",
  "dispatchEvent",
  "type",
  "press",
  "setInputFiles",
  "waitForEvent",
  "waitFor",
  "waitForTimeout",
  "dragTo",
  "clear",
  "dblclick",
  "toBe",
  "first",
  "last",
  "focus",
  "highlight",
  "scrollIntoViewIfNeeded",
  "null"
];

List<String> availableExtractions = [
  "count",
  "all",
  "allInnerTexts",
  "allTextContents",
  "boundingBox",
  "getAttribute",
  "innerHTML",
  "innerText",
  "inputValue",
  "isChecked",
  "isDisabled",
  "isEditable",
  "isEnabled",
  "textContent",
  "null"
];
List<String> assertions = [
  "toBe",
  "toEqual",
  "toBeTruthy",
  "toBeFalsy",
  "toBeGreaterThan",
  "toBeLessThan",
  "toBeGreaterThanOrEqual",
  "toBeLessThanOrEqual",
  "toContain"
];
