// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditableDataRepoScreen extends StatefulWidget {
  @override
  _EditableDataRepoScreenState createState() => _EditableDataRepoScreenState();
}

class _EditableDataRepoScreenState extends State<EditableDataRepoScreen> {
  Map<String, dynamic>? content;
  String? currentEnvironment;
  int activeProjectId = 0;
  late List<Map<String, dynamic>> activeProject;
  List<Map<String, String>> oldNewKeys = [];
  bool loaded = true;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      activeProjectId = prefs.getInt('activeProject')!;
      String allProjects = prefs.getString('projectsObject')!;
      List<Map<String, dynamic>> allProjectsCasted =
          json.decode(allProjects).cast<Map<String, dynamic>>();
      activeProject = activeProjectId != 0
          ? allProjectsCasted
              .where((project) => project['id'] == activeProjectId)
              .toList()
          : [];
    });
    var response = await http.post(
      Uri.parse('http://localhost:1337/dataRepository/getContent'),
      body: {
        'filePath':
            "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}"
      },
    );
    if (activeProjectId != 0) {
      if (response.statusCode == 200) {
        setState(() {
          content = json.decode(response.body);
          currentEnvironment = content!.keys.first;
        });
      }
    }
  }

  Future<void> _updateDataInDataRepoFile() async {
    setState(() {
      loaded = false;
    });
    Map<String, dynamic> dataPayload = {
      "path":
          "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/dataRepository.json",
      "data": content
    };
    final response = await http.post(
        Uri.parse('http://localhost:1337/dataRepository/updateData'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dataPayload));
  }

  Future<bool> updateDataFiles(
      String folderPath, List<Map<String, String>> oldNewKeys) async {
    final Uri endpoint =
        Uri.parse('http://localhost:1337/data/updateDataFiles');

    final response = await http.post(
      endpoint,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'folderPath': folderPath,
        'oldNewKeys': oldNewKeys,
      }),
    );

    if (response.statusCode == 200) {
      // Handle a successful response
      return true;
    } else {
      // Handle an unsuccessful response
      print('Failed to update data files: ${response.body}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return content == null
        ? CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DropdownButton<String>(
                value: currentEnvironment,
                onChanged: (value) {
                  setState(() {
                    currentEnvironment = value;
                  });
                },
                items: content!.keys.map((env) {
                  return DropdownMenuItem(
                    child: Text(env),
                    value: env,
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: content![currentEnvironment]!.length,
                  itemBuilder: (context, index) {
                    String key =
                        content![currentEnvironment]!.keys.elementAt(index);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.3),
                        border: Border(
                          left: BorderSide(
                            color: Color(0xffE95622),
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(key),
                        subtitle: Text(content![currentEnvironment]![key]),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, key,
                                content![currentEnvironment]![key]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  void _showEditDialog(BuildContext context, String oldKey, String oldValue) {
    String newKey = oldKey;
    String newValue = oldValue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit data repository entry"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: oldKey,
                  onChanged: (value) {
                    newKey = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: oldValue,
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                // Call backend to update
                // For demonstration purposes, we'll update the local state only
                // You can replace the following lines with the actual HTTP request
                if (oldKey != newKey) {
                  // Save the old key and the new key
                  oldNewKeys.add({'oldKey': oldKey, 'newKey': newKey});
                  content!.forEach((env, values) {
                    if (values.containsKey(oldKey)) {
                      // Save the value from the current environment and remove the old key
                      var value =
                          env == currentEnvironment ? newValue : values[oldKey];
                      values.remove(oldKey);
                      values[newKey] = value;
                    }
                  });
                  await _updateDataInDataRepoFile();
                  await updateDataFiles(
                    "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/tests",
                    oldNewKeys,
                  );
                } else {
                  content![currentEnvironment]![newKey] = newValue;
                }

                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
