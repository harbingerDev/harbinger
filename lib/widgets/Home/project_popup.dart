// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/projects.dart';

class ProjectPopup extends StatefulWidget {
  final Function(String projectName, String projectPath) onClickedDone;
  final bool isAdd;
  const ProjectPopup(
      {super.key, required this.onClickedDone, required this.isAdd});

  @override
  State<ProjectPopup> createState() => _ProjectPopupState();
}

class _ProjectPopupState extends State<ProjectPopup> {
  final formKey = GlobalKey<FormState>();
  final projectNameController = TextEditingController();
  String? projectPath = "";

  @override
  void dispose() {
    projectNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isAdd ? 'Add project' : 'Import project';
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildProjectName(),
              SizedBox(height: 8),
              buildProjectPath()
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context),
      ],
    );
  }

  Widget buildProjectName() => TextFormField(
        controller: projectNameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter project name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a project name' : null,
      );
  Widget buildProjectPath() => TextButton(
      onPressed: () async => {
            await FilePicker.platform
                .getDirectoryPath(
                    dialogTitle: "Select folder to create project")
                .then(((value) => setState(() => {projectPath = value})))
          },
      child: Text('Chose a file'));
  Widget buildAddButton(BuildContext context) {
    final text = widget.isAdd ? 'Add' : 'Import';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final projectName = projectNameController.text;

          widget.onClickedDone(projectName, projectPath!);

          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );
}
