// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GitOperationsScreen extends StatefulWidget {
  @override
  _GitOperationsScreenState createState() => _GitOperationsScreenState();
}

class _GitOperationsScreenState extends State<GitOperationsScreen> {
  late SharedPreferences prefs;
  String gitStatus = "Fetching status...";
  late String folderPath;
  List<Map<String, dynamic>>? activeProject;

  @override
  void initState() {
    super.initState();
    _initializePreferences().then((_) => _gitStatus());
  }

  Future<void> _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int activeProjectId = prefs.getInt('activeProject')!;
    String allProjects = prefs.getString('projectsObject')!;
    List<Map<String, dynamic>> allProjectsCasted =
        json.decode(allProjects).cast<Map<String, dynamic>>();
    activeProject = activeProjectId != 0
        ? allProjectsCasted
            .where((project) => project['id'] == activeProjectId)
            .toList()
        : [];

    folderPath =
        "${activeProject![0]["project_path"]}/${activeProject![0]["project_name"]}";
  }

  Future<void> _gitStatus() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:1337/git/status'),
      body: jsonEncode({"folderPath": folderPath}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      setState(() {
        gitStatus = json.decode(response.body)['result'];
      });
    }
  }

  Future<void> _gitAdd() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:1337/git/add'),
      body: jsonEncode({"folderPath": folderPath}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      _gitStatus();
    }
  }

  Future<void> _gitCommit() async {
    final TextEditingController controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Commit Message'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter your commit message'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final commitMessage = controller.text;
                print(commitMessage);
                if (commitMessage.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse('http://127.0.0.1:1337/git/commit'),
                    body: jsonEncode({
                      "folderPath": folderPath,
                      "commitMessage": commitMessage
                    }),
                    headers: {"Content-Type": "application/json"},
                  );
                  if (response.statusCode == 200) {
                    _gitStatus();
                  }
                }
                Navigator.of(context).pop(true);
              },
              child: Text('Commit'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _gitPushBranch(String branchName) async {
    
  // }

    Future<void> _gitPush() async {
    final TextEditingController branchcontroller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Branch Name'),
          content: TextField(
            controller: branchcontroller,
            decoration: InputDecoration(hintText: 'Enter your branch name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final branchName = branchcontroller.text;
                print(branchName);
                if (branchName.isNotEmpty) {
                final response = await http.post(
      Uri.parse('http://127.0.0.1:1337/git/push'),
      body: jsonEncode({"folderPath": folderPath,"branch": branchName}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
          Navigator.of(context).pop(true);
      _gitStatus();
    }
    else{
        Navigator.of(context).pop(true);
    }

                }
              },
              child: Text('Push'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(
                        color: Color(0xffE95622),
                        style: BorderStyle.solid,
                        width: 4),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(gitStatus)),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _gitAdd,
                  child: Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _gitCommit();
                  },
                  child: Text('Commit'),
                ),
                ElevatedButton(
                  onPressed: () async {
                   _gitPush();
                  },
                  child: Text('Push'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
