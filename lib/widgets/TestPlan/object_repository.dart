// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ObjectRepository extends StatefulWidget {
  @override
  _ObjectRepositoryState createState() => _ObjectRepositoryState();
}

class _ObjectRepositoryState extends State<ObjectRepository> {
  late Map<String, dynamic> objectRepository = {};
  bool loaded = false;
  int activeProjectId = 0;
  late List<Map<String, dynamic>> activeProject;
  String dropDownPageName = "default";

  Future<void> getActiveProject() async {
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
    if (activeProjectId != 0) {
      var objectRepoURI =
          Uri.parse("http://localhost:1337/objectRepository/getObjectRepo");
      final response = await http.post(
        objectRepoURI,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "project_path": activeProject[0]["project_path"],
          "project_name": activeProject[0]["project_name"]
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          objectRepository = jsonDecode(response.body);
          loaded = true;
        });
      } else {
        // Handle error
        throw Exception('Failed to load objectRepository');
      }
    } else {
      setState(() {
        loaded = true;
      });
    }
  }

  void _showAddPageDialog(BuildContext context) async {
    String pageName = '';
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Page Name'),
          content: Form(
            key: formKey,
            child: TextFormField(
              onChanged: (value) => pageName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a page name';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Page Name',
                hintText: 'Page Name',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await addPage(pageName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Page'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addPage(String pageName) async {
    setState(() {
      loaded = false;
    });
    final Uri apiUri =
        Uri.parse("http://localhost:1337/objectRepository/addPage");
    final response = await http.post(
      apiUri,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "filePath":
            "${activeProject[0]["project_path"]}\\${activeProject[0]["project_name"]}\\objectRepository.js",
        "pageName": pageName
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        getActiveProject();
        loaded = true;
      });
    } else {
      throw Exception("Failed to add page: ${response.body}");
    }
  }

  Future<void> updateLocator({
    required String pageName,
    required String locatorName,
    required String locatorValue,
  }) async {
    setState(() {
      loaded = false;
    });
    final response = await http.put(
      Uri.parse('http://localhost:1337/objectRepository/updateLocator'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'filePath':
            "${activeProject[0]["project_path"]}\\${activeProject[0]["project_name"]}\\objectRepository.js",
        'pageName': pageName,
        'locatorName': locatorName,
        'locatorValue': locatorValue,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update locator.');
    }
    setState(() {
      getActiveProject();
      loaded = true;
    });
  }

  void _showUpdateLocatorPopup(BuildContext context) async {
    String locatorName = '';
    String locatorValue = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Locator'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  hint: Text('Select Page Name'),
                  value: dropDownPageName,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownPageName = newValue!;
                    });
                  },
                  items: objectRepository.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  onChanged: (value) => locatorName = value,
                  decoration: InputDecoration(labelText: 'Locator Name'),
                ),
                TextField(
                  onChanged: (value) => locatorValue = value,
                  decoration: InputDecoration(labelText: 'Locator Value'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await updateLocator(
                  pageName: dropDownPageName!,
                  locatorName: locatorName,
                  locatorValue: locatorValue,
                );
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> renameLocator({
    required String filePath,
    required String fileName,
    required String pageName,
    required String locatorOldName,
    required String locatorNewName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:1337/objectRepository/renameLocator'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'filePath': filePath,
          'fileName': fileName,
          'pageName': pageName,
          'locatorOldName': locatorOldName,
          'locatorNewName': locatorNewName,
        }),
      );

      if (response.statusCode == 200) {
      } else {
        final jsonResponse = jsonDecode(response.body);
        print('Failed to rename locator: ${jsonResponse['message']}');
      }
    } catch (error) {
      print('Failed to call API: $error');
    }
  }

  Future<void> showRenameLocatorDialog(
      {required BuildContext context,
      required String oldLocatorName,
      required String pageName}) async {
    final TextEditingController _newLocatorNameController =
        TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Locator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Old Locator Name: $oldLocatorName'),
              TextField(
                controller: _newLocatorNameController,
                decoration: InputDecoration(labelText: 'New Locator Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newLocatorName = _newLocatorNameController.text;
                if (newLocatorName.isNotEmpty) {
                  // Call the renameLocator function with the appropriate values
                  await renameLocator(
                    filePath:
                        "${activeProject[0]["project_path"]}\\${activeProject[0]["project_name"]}",
                    fileName: 'objectRepository.js',
                    pageName: pageName,
                    locatorOldName: oldLocatorName,
                    locatorNewName: newLocatorName,
                  );

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a new locator name.')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getActiveProject();
  }

  @override
  Widget build(BuildContext context) {
    return objectRepository == null
        ? Center(child: CircularProgressIndicator())
        : Column(children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Chip(label: Text("Pages:")),
                      SizedBox(width: 10),
                      Chip(label: Text("locators:")),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _showUpdateLocatorPopup(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          child: Text("Add new locator"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _showAddPageDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          child: Text("Add new page"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: objectRepository.keys.length,
                  itemBuilder: (context, index) {
                    String key = objectRepository.keys.elementAt(index);
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
                      child: ExpansionTile(
                        iconColor: Colors.black87,
                        textColor: Colors.black87,
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 0, right: 8, bottom: 0),
                              child: Chip(
                                label: Text("page"),
                              ),
                            ),
                            Text(key, style: GoogleFonts.roboto(fontSize: 18)),
                          ],
                        ),
                        children: objectRepository[key]
                            .entries
                            .map<Widget>((entry) => ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key),
                                      Row(
                                        children: [
                                          PopupMenuButton<String>(
                                            itemBuilder:
                                                (BuildContext context) => [
                                              PopupMenuItem<String>(
                                                value: 'rename',
                                                child: Text('Rename'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'change_locator_value',
                                                child: Text(
                                                    'Change locator value'),
                                              ),
                                            ],
                                            onSelected: (String value) {
                                              if (value == 'rename') {
                                                showRenameLocatorDialog(
                                                    context: context,
                                                    oldLocatorName: entry.key,
                                                    pageName: key);
                                                // Handle the Rename action here
                                              } else if (value ==
                                                  'change_locator_value') {
                                                // Handle the Change locator value action here
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(Icons.edit_outlined),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                                Icons.drive_file_move_outlined),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.delete_outline),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  subtitle: Text(entry.value),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            )
          ]);
  }
}
