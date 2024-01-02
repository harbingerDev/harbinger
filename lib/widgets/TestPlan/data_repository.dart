// ignore_for_file: prefer_const_constructors, prefer_for_elements_to_map_fromiterable, unused_field, unnecessary_new, prefer_final_fields, prefer_collection_literals

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditableDataRepoOldScreen extends StatefulWidget {
  const EditableDataRepoOldScreen({Key? key}) : super(key: key);

  @override
  _EditableDataRepoOldScreenState createState() => _EditableDataRepoOldScreenState();
}

class _EditableDataRepoOldScreenState extends State<EditableDataRepoOldScreen> {
  Map<String, List<TextEditingController>> _dataParameterNameControllers = {};
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> dataRepo = {};
  bool loaded = false;
  int activeProjectId = 0;
  late List<Map<String, dynamic>> activeProject;
  String? dropdownValue;
  Map<String, dynamic> renamingMap = {};

  Future<void> _updateDataInDataRepoFile() async {
    setState(() {
      loaded = false;
    });
    Map<String, dynamic> dataPayload = {
      "path":
          "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/dataRepository.json",
      "data": dataRepo
    };
    final response = await http.post(
        Uri.parse('http://localhost:1337/dataRepository/updateData'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dataPayload));
    if (response.statusCode == 200) {
      Map<String, dynamic> replaceDataPayload = {
        "path":
            "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}/tests",
        "data": renamingMap
      };

      final replaceResponse = await http.post(
        Uri.parse('http://localhost:1337/dataRepository/replaceValues'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(replaceDataPayload),
      );
      if (replaceResponse.statusCode == 200) {
        _getDataRepoContent();
      } else {
        print(replaceResponse.body);
        setState(() {
          loaded = true;
        });
      }
    } else {
      print(response.body);
      setState(() {
        loaded = true;
      });
    }
  }

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
              "${activeProject[0]["project_path"]}/${activeProject[0]["project_name"]}"
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          dataRepo =
              Map<String, Map<String, dynamic>>.from(jsonDecode(response.body));
          Set intermediateSet = dataRepo.values.expand((v) => v.keys).toSet();
          renamingMap = Map.fromIterable(intermediateSet,
              key: (v) => v, value: (v) => null);
          dropdownValue = dataRepo.keys.first;
          for (var i = 0; i < dataRepo.keys.length; i++) {
            List<TextEditingController> controllersIntermediate = [];
            for (var j = 0;
                j < dataRepo[dataRepo.keys.elementAt(i)].keys.length;
                j++) {
              TextEditingController dataParameterInternalController =
                  TextEditingController(
                      text: dataRepo[dataRepo.keys.elementAt(i)]
                          .keys
                          .elementAt(j));
              dataParameterInternalController.addListener(() {
                setState(
                  () {
                    final text = dataParameterInternalController.text;
                  },
                );
              });
              controllersIntermediate.add(dataParameterInternalController);
            }
            _dataParameterNameControllers[dataRepo.keys.elementAt(i)] =
                controllersIntermediate;
          }
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

  void renameParameterName(String oldValue, String newValue) {
    for (var env in dataRepo.keys) {
      if (dataRepo[env]!.containsKey(oldValue)) {
        // Save the value under the old key
        var tempValue = dataRepo[env]![oldValue];

        // Remove the old key-value pair
        dataRepo[env]!.remove(oldValue);

        // Insert a new key-value pair
        dataRepo[env]![newValue] = tempValue;
      }
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
        ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: DropdownButton<String>(
                        enableFeedback: true,
                        hint: Text("Select environment"),
                        focusColor: Colors.transparent,
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: GoogleFonts.roboto(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Color(0xffE95622),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: dataRepo.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            await _updateDataInDataRepoFile();
                          },
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: Colors.green,
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 10),
                          //   textStyle: GoogleFonts.roboto(
                          //       fontSize: 14,
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.normal),
                          // ),
                          label: Text("Save"),
                          icon: Icon(Icons.save)),
                    )
                  ],
                ),
                if (dropdownValue != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dropdownValue!,
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
                              itemCount: dataRepo[dropdownValue].length,
                              itemBuilder: (BuildContext context, int index) {
                                final dataKey = dataRepo[dropdownValue]
                                    .keys
                                    .elementAt(index);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: 'Data parameter name',
                                            labelText: 'Data parameter name',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xffE95622),
                                              ),
                                            ),
                                          ),
                                          initialValue: dataKey,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: TextFormField(
                                          controller:
                                              _dataParameterNameControllers[
                                                      dropdownValue]!
                                                  .elementAt(index),
                                          decoration: InputDecoration(
                                            hintText: 'New data parameter name',
                                            labelText:
                                                'New data parameter name',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xffE95622),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            renameParameterName(
                                                dataKey,
                                                _dataParameterNameControllers[
                                                        dropdownValue]!
                                                    .elementAt(index)
                                                    .text);

                                            renamingMap[dataKey] =
                                                _dataParameterNameControllers[
                                                        dropdownValue]!
                                                    .elementAt(index)
                                                    .text;
                                          },
                                          icon: Icon(Icons.check,
                                              color:
                                                  _dataParameterNameControllers[
                                                                  dropdownValue]!
                                                              .elementAt(index)
                                                              .text !=
                                                          dataKey
                                                      ? Colors.green
                                                      : Colors.grey)),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: dataRepo[dropdownValue]
                                              [dataKey],
                                          decoration: InputDecoration(
                                            hintText: 'Value',
                                            labelText: 'Value',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xffE95622),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
