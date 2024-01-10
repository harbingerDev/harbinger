// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:chips_choice/chips_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectPopup extends StatefulWidget {
  final Function(Map<String, dynamic> projectObject) onClickedDone;
  final bool isAdd;
  final String projectPath;
  const ProjectPopup(
      {super.key,
      required this.onClickedDone,
      required this.isAdd,
      required this.projectPath});

  @override
  State<ProjectPopup> createState() => _ProjectPopupState();
}

class _ProjectPopupState extends State<ProjectPopup> {
  final formKey = GlobalKey<FormState>();
  final projectNameController = TextEditingController();
  final defaultTimeOutController = TextEditingController();
  final environmentNameController = TextEditingController();
  final environmentValueController = TextEditingController();
  final workerNumberController = TextEditingController();
  final gitUrlController = TextEditingController();
  final apitokenUrlController = TextEditingController();
  final jenkinsUrlController = TextEditingController();
  final jenkinsUsernameController = TextEditingController();

  
  Map<String, dynamic> projectObject = {};

  List<String> tags = [];
  List<String> options = ['Chrome', 'Safari', 'Edge'];
  Map<String, String> environments = {};
  bool parallel = false;

  ChipsChoice getChips() {
    return ChipsChoice<String>.multiple(
      choiceCheckmark: true,
      choiceStyle: C2ChipStyle.filled(
        disabledStyle: C2ChipStyle(
          backgroundColor: Colors.grey,
        ),
        selectedStyle: C2ChipStyle(
          backgroundColor: Color(0xffE95622),
        ),
      ),
      value: tags,
      onChanged: (val) => setState(() => tags = val),
      choiceItems: C2Choice.listFrom<String, String>(
        source: options,
        value: (i, v) => v,
        label: (i, v) => v,
      ),
    );
  }

  @override
  void dispose() {
    projectNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isAdd ? 'Add project' : 'Import project';
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.all(10),
      backgroundColor: Colors.white,
      title: Text(title,
          style: GoogleFonts.roboto(
              color: Colors.black87, fontWeight: FontWeight.bold)),
      content: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            new Divider(
              color: Color(0xffE95622),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Project path: ",
                    style: GoogleFonts.roboto(
                        color: Colors.black87, fontSize: 14)),
                Text('${widget.projectPath}/harbingerProjects',
                    style: GoogleFonts.roboto(  
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 14)),
              ],
            ),
            SizedBox(height: 8),
            buildField(projectNameController, "Enter project name"),
            SizedBox(height: 8),
            buildField(
              gitUrlController,
                 "Enter git url (https://github.com/username/repo.git)",
                    ),
                    SizedBox(height: 8),
            Row(
              children: [
                 Expanded(
                   child: buildEnvironmentField(
                     jenkinsUrlController,
                     "Enter jenkins url (http://localhost:8080)",
                   ),
                 ),
                  SizedBox(width: 10),
                    Expanded(
                      child: buildEnvironmentField(
                       jenkinsUsernameController,
                        "Enter jenkins username"
                      ),
                    ),
                     SizedBox(width: 10),
                    Expanded(
                      child: buildEnvironmentField(
                        apitokenUrlController,
                        "Enter jenkins api token"
                      ),
                    ),
 
              ],
            ),
            SizedBox(height: 8),
            buildField(
                defaultTimeOutController, "Enter default timeout (in ms)"),
            environments.isNotEmpty
                ? SizedBox(height: 16)
                : SizedBox(height: 8),
            Column(
              children: [
                Row(
                    children: environments.entries
                        .map((e) => Tooltip(
                              message: e.value,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Chip(
                                  deleteIcon: Icon(
                                    Icons.close,
                                    size: 14,
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      environments.remove(e.key);
                                    });
                                  },
                                  label: Text(e.key,
                                      style: GoogleFonts.roboto(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      )),
                                ),
                              ),
                            ))
                        .toList()),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 3,
                      child: buildEnvironmentField(environmentNameController,
                          "Enter environment name (qa,dev etc.)"),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: buildEnvironmentField(environmentValueController,
                          "Enter environment url (http://www.google.com)"),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            environments[environmentNameController.text] =
                                environmentValueController.text;
                            environmentNameController.clear();
                            environmentValueController.clear();
                          });
                        },
                        child: Text('Add',
                            style: GoogleFonts.roboto(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text("Parallel execution? : ",
                              style: GoogleFonts.roboto(
                                  color: Colors.black87, fontSize: 14)),
                          FlutterSwitch(
                            inactiveColor: Colors.grey[300]!,
                            activeColor: Color(0xffE95622),
                            width: 55.0,
                            height: 22.0,
                            valueFontSize: 14.0,
                            toggleSize: 15.0,
                            value: parallel,
                            borderRadius: 30.0,
                            padding: 8.0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                parallel = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    parallel
                        ? Expanded(
                            flex: 2,
                            child: buildField(workerNumberController,
                                "Enter number of workers"))
                        : Container(),
                    SizedBox(
                      width: 100,
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Browsers: ",
                    style: GoogleFonts.roboto(
                        color: Colors.black87, fontSize: 14)),
                SizedBox(width: 600, child: getChips())
              ],
            ),
            SizedBox(height: 8),
            //buildProjectPath()
          ],
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context),
      ],
    );
  }

  Widget buildEnvironmentField(
          TextEditingController editingController, String hintText) =>
      TextFormField(
        style: GoogleFonts.roboto(
            color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
        controller: editingController,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      );
  Widget buildField(TextEditingController editingController, String hintText) =>
      TextFormField(
        style: GoogleFonts.roboto(
            color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
        controller: editingController,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a project name' : null,
      );
  Widget buildProjectPath() => TextButton(
      onPressed: () async => {
            await FilePicker.platform
                .getDirectoryPath(
                    dialogTitle: "Select folder to create project")
                .then(((value) => setState(() => {})))
          },
      child: Text('Chose a file'));
  Widget buildAddButton(BuildContext context) {
    final text = widget.isAdd ? 'Add project' : 'Import';
    return TextButton(
      child: Text(text,
          style: GoogleFonts.roboto(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          projectObject["project_name"] = projectNameController.text;
          projectObject["github_url"]=gitUrlController.text ;
          projectObject["project_path"] ='${widget.projectPath}/harbingerProjects';
          projectObject["default_timeout"] = defaultTimeOutController.text;
          projectObject["environments"] = environments;
          projectObject["parallel_execution"] = parallel.toString();
          projectObject["browsers"] = tags;
          projectObject["jenkins_api_token"] = apitokenUrlController.text;
          projectObject["jenkins_url"] = jenkinsUrlController.text;
          projectObject["jenkins_username"] = jenkinsUsernameController.text;
          widget.onClickedDone(projectObject);
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel',
            style: GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.of(context).pop(),
      );
}
