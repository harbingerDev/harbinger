// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditableDataRepoScreen extends StatefulWidget {
  const EditableDataRepoScreen({Key? key}) : super(key: key);

  @override
  _EditableDataRepoScreenState createState() => _EditableDataRepoScreenState();
}

class _EditableDataRepoScreenState extends State<EditableDataRepoScreen> {
  late Map<String, dynamic> dataRepo = {};
  bool loaded = false;
  int activeProjectId = 0;
  late List<Map<String, dynamic>> activeProject;

  Future<void> _getDataRepoContent() async {
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
      final response = await http.post(
        Uri.parse('http://localhost:1337/dataRepository/getContent'),
        body: {
          'filePath':
              "${activeProject[0]["project_path"]}\\${activeProject[0]["project_name"]}"
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          dataRepo = Map<String, dynamic>.from(jsonDecode(response.body));
          loaded = true;
        });
      } else {
        throw Exception('Failed to load dataRepository');
      }
    } else {
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataRepoContent();
  }

  @override
  Widget build(BuildContext context) {
    return dataRepo.isNotEmpty
        ? ListView.builder(
            itemCount: dataRepo.keys.length,
            itemBuilder: (BuildContext context, int index) {
              final key = dataRepo.keys.elementAt(index);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.3),
                        border: Border(
                          left: BorderSide(
                            color: Color(0xffE95622),
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dataRepo[key].length,
                          itemBuilder: (BuildContext context, int index) {
                            final dataKey = dataRepo[key].keys.elementAt(index);

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter data parameter name',
                                      labelText: 'Enter data parameter name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xffE95622),
                                        ),
                                      ),
                                    ),
                                    initialValue: dataKey,
                                    onChanged: (newValue) {
                                      setState(() {
                                        dataRepo[key][newValue] =
                                            dataRepo[key][dataKey];
                                        dataRepo[key].remove(dataKey);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: dataRepo[key][dataKey],
                                    decoration: InputDecoration(
                                      hintText: 'Enter data parameter value',
                                      labelText: 'Enter data parameter value',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xffE95622),
                                        ),
                                      ),
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        dataRepo[key][dataKey] = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
