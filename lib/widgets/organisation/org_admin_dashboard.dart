// imports
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class OrgAdminDashboardScreen extends StatefulWidget {
  const OrgAdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OrgAdminDashboardScreen> createState() =>
      _OrgAdminDashboardScreenState();
}

class _OrgAdminDashboardScreenState extends State<OrgAdminDashboardScreen> {
  // Data for projects, team members, and performance
  // final List<Project> projects = [];
  // final List<TeamMember> teamMembers = [];
  // final PerformanceAnalytics performance = PerformanceAnalytics();

  @override
  void initState() {
    super.initState();
    // initialize data from a data source
    // for example, load from a server or local storage
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Chip(
                  elevation: 1,
                  backgroundColor: Colors.green.withOpacity(.2),
                  label: Text("Organisation Dashboard",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ),
            ],
          ),
          // Project Overview
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey[200],
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Project Overview',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const SizedBox(height: 200.0),

                    // _buildProjectsList(),
                  ],
                ),
              ),
            ),
          ),

          // Team Management
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey[200],
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Team Management',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const SizedBox(height: 200.0),

                    // _buildTeamMembersList(),
                  ],
                ),
              ),
            ),
          ),

          // Performance Analytics
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey[200],
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance Analytics',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const SizedBox(height: 800.0),

                    // _buildTeamMembersList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class OrgAdminDashboardScreen extends StatefulWidget {
//   const OrgAdminDashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<OrgAdminDashboardScreen> createState() => _OrgAdminDashboardScreenState();
// }

// class _OrgAdminDashboardScreenState extends State<OrgAdminDashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Project Overview
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Project Overview'),
//                     const SizedBox(height: 8.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             children: [
//                               const Text('Ongoing Projects'),
//                               const SizedBox(height: 8.0),
//                               ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: 3,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         const Text('Project Name:'),
//                                         const SizedBox(width: 16.0),
//                                         Text('Project ${index + 1}'),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               const Text('Completed Projects'),
//                               const SizedBox(height: 8.0),
//                               ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: 2,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         const Text('Project Name:'),
//                                         const SizedBox(width: 16.0),
//                                         Text('Project ${index + 4}'),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Team Management
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Team Management'),
//                     const SizedBox(height: 8.0),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               const Text('Team Member Name:'),
//                               const SizedBox(width: 16.0),
//                               Text('Team Member ${index + 1}'),
//                               const SizedBox(width: 16.0),
//                               Text('Role: Developer'),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Performance Analytics
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Performance Analytics'),
//                     const SizedBox(height: 8.0),
//                     // Insert charts and graphs here
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
