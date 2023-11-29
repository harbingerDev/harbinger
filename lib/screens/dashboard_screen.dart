// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harbinger/assets/config.dart';
import 'package:harbinger/main.dart';
import 'package:harbinger/screens/home_screen.dart';
import 'package:harbinger/screens/test_lab_screen.dart';
import 'package:harbinger/screens/test_plan_screen.dart';
import 'package:harbinger/screens/test_reports_screen.dart';
import 'package:harbinger/widgets/organisation/org_admin_dashboard.dart';
import 'package:harbinger/widgets/Admin/superadmin_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../assets/constants.dart';
import '../helpers/helper_functions.dart';
import '../widgets/TestPlan/show_code_updated.dart';
import '../widgets/Admin/superadmin_adminstrate_screen.dart';
class DashboardScreen extends ConsumerWidget {
  final selectedIndexProvider = StateProvider<int>((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleBasedNavigatorProvider);
    final screenIndicator = ref.watch(screenProvider);
    final filePath = ref.watch(filePathProvider);
    int selectedIndex = ref.watch(selectedIndexProvider);

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
                  child: Icon(
                    Icons.account_box,
                    size: 50,
                  ),
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
                      child: SizedBox(
                        height: 35,
                        width: 60,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              ref.read(screenProvider.notifier).state = "Nothing";
              ref.read(selectedIndexProvider.notifier).state = index;
              print(index);
              print(selectedIndex);
              if (index == 5) {
                cleartoken();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    title: 'Harbinger - your own automation copilot',
                  ),
                ));
              }
            },
            labelType: NavigationRailLabelType.selected,
            destinations: getNavigationRailItems(role),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: NavigateToSpecificScreenInDashboard(
              selectedIndex: selectedIndex,
              role: role,
              filePath: filePath,
              screenIndicator: screenIndicator,
              parentContext: context,
            ),
          )
        ],
      ),
    );
  }

  static void cleartoken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}

class NavigateToSpecificScreenInDashboard extends StatefulWidget {
  final int selectedIndex;
  final String role;
  final String filePath;
  final String screenIndicator;
  final BuildContext parentContext;

  const NavigateToSpecificScreenInDashboard({
    Key? key,
    required this.selectedIndex,
    required this.role,
    required this.filePath,
    required this.screenIndicator,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<NavigateToSpecificScreenInDashboard> createState() =>
      _NavigateToSpecificScreenInDashboardState();
}

class _NavigateToSpecificScreenInDashboardState
    extends State<NavigateToSpecificScreenInDashboard> {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = widget.selectedIndex;
    final String role = widget.role;
    final String screenIndicator = widget.screenIndicator;

    if (role == AppConfig.PROJECTADMIN) {
      if (selectedIndex == 0) {
        return HomeScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Nothing") {
        return TestPlanScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Code") {
        return ShowCodeUpdated(filePath: widget.filePath);
      } else if (selectedIndex == 3) {
        return TestReports();
      } else if (selectedIndex == 4) {
        return TestLabScreen();
      } else {
        // Handle other cases as needed
        return Container(); // Placeholder, replace with appropriate widget
      }
    } else if (role == AppConfig.SUPERADMIN) {
      if (selectedIndex == 0) {
        return SuperadminDashboardOverviewScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Nothing") {
        return SuperAdminAdminstrate();
      } else if (selectedIndex == 1 && screenIndicator == "Code") {
        return ShowCodeUpdated(filePath: widget.filePath);
      } else if (selectedIndex == 3) {
        return TestReports();
      } else if (selectedIndex == 4) {
        return TestLabScreen();
      } else {
        return Container();
      }
    } else if (role == AppConfig.ORGADMIN) {
      if (selectedIndex == 0) {
        return OrgAdminDashboardScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Nothing") {
        return HomeScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Code") {
        return ShowCodeUpdated(filePath: widget.filePath);
      } else if (selectedIndex == 3) {
        return TestReports();
      } else if (selectedIndex == 4) {
        return TestLabScreen();
      } else {
        return Container();
      }
    } else if (role == AppConfig.PROJECTMEMBER) {
      if (selectedIndex == 0) {
        return HomeScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Nothing") {
        return TestPlanScreen();
      } else if (selectedIndex == 1 && screenIndicator == "Code") {
        return ShowCodeUpdated(filePath: widget.filePath);
      } else if (selectedIndex == 3) {
        return TestReports();
      } else if (selectedIndex == 4) {
        return TestLabScreen();
      } else {
        return Container();
      }
    }
    return Placeholder();
  }
}









 // selectedIndex == 0
          //     ? Expanded(child: HomeScreen())
          //     : selectedIndex == 1 && screenIndicator == "Nothing"
          //         ? Expanded(child: TestPlanScreen())
          //         : selectedIndex == 1 && screenIndicator == "Code"
          //             ? Expanded(
          //                 child: ShowCodeUpdated(
          //                 filePath: filePath,
          //               ))
          //             : selectedIndex == 3
          //                 ? Expanded(child: TestReports())
          //                 : Expanded(child: TestLabScreen()),