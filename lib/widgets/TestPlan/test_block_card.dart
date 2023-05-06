// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/main.dart';
import 'package:harbinger/models/testScriptModel.dart';
import 'package:harbinger/widgets/TestPlan/edit_step_popup.dart';
import 'package:harbinger/widgets/TestPlan/editor_views.dart';
import 'package:harbinger/widgets/TestPlan/show_code.dart';
import 'package:harbinger/widgets/TestPlan/show_code_GPT.dart';
import 'package:harbinger/widgets/TestPlan/show_steps.dart';
import 'package:harbinger/widgets/TestPlan/show_steps_updated.dart';

import '../../models/form_data.dart';

class TestBlockCard extends StatefulWidget {
  final TestScriptModel testScriptModel;
  final int testIndex;
  final Function(int, int) moveUp;
  final Function(int, int) moveDown;
  final Function(int, int) deleteAt;
  const TestBlockCard({
    super.key,
    required this.testScriptModel,
    required this.testIndex,
    required this.moveUp,
    required this.moveDown,
    required this.deleteAt,
  });

  @override
  State<TestBlockCard> createState() => _TestBlockCardState();
}

class _TestBlockCardState extends State<TestBlockCard> {
  List<FormData> currentFormData = actionFormData;
  Map<String, dynamic> formValues = {};

  void _updateFormData(List<FormData> formData) {
    setState(() {
      currentFormData = formData;
    });
  }

  void _showFormEdit(List<String> steps) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit step'),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < currentFormData.length; i++)
                        if (currentFormData[i]
                            .name
                            .startsWith('Locator strategy'))
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormField(
                                    currentFormData[i], setState),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildFormField(
                                    currentFormData[i + 1], setState),
                              ),
                            ],
                          )
                        else if (!currentFormData[i]
                            .name
                            .startsWith('Locator value'))
                          _buildFormField(currentFormData[i], setState),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print(formValues);
                              Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green, // Set the button color
                              onPrimary: Colors.white, // Set the text color
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                            style: TextButton.styleFrom(
                              primary: Colors.white, // Set the text color
                              backgroundColor:
                                  Colors.black, // Set the button color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add step'),
          contentPadding: EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < currentFormData.length; i++)
                        if (currentFormData[i]
                            .name
                            .startsWith('Locator strategy'))
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormField(
                                    currentFormData[i], setState),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildFormField(
                                    currentFormData[i + 1], setState),
                              ),
                            ],
                          )
                        else if (!currentFormData[i]
                            .name
                            .startsWith('Locator value'))
                          _buildFormField(currentFormData[i], setState),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print(formValues);
                              Navigator.of(context).pop();
                            },
                            child: Text('Save'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green, // Set the button color
                              onPrimary: Colors.white, // Set the text color
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                            style: TextButton.styleFrom(
                              primary: Colors.white, // Set the text color
                              backgroundColor:
                                  Colors.black, // Set the button color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(FormData field, StateSetter setState) {
    if (field.type == 'text') {
      return TextFormField(
        initialValue: field.defaultValue,
        onChanged: (value) {
          formValues[field.name] = value;
        },
        decoration: InputDecoration(
          labelText: field.name,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xffE95622)), // Set the focused border color
          ),
        ),
      );
    }

    if (field.type == 'list') {
      return DropdownButtonFormField(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        menuMaxHeight: 300,
        value: formValues[field.name] ?? field.defaultValue,
        onChanged: (dynamic value) {
          setState(() {
            formValues[field.name] = value;
          });
        },
        items: field.values!
            .map<DropdownMenuItem>((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        decoration: InputDecoration(
          labelText: field.name,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xffE95622)), // Set the focused border color
          ),
        ),
      );
    }

    if (field.type == 'checkbox') {
      return CheckboxListTile(
        title: Text(field.name),
        value: formValues[field.name] ?? field.defaultValue == 'checked',
        onChanged: (bool? value) {
          setState(() {
            formValues[field.name] = value!;
          });
        },
        activeColor: Color(0xffE95622), // Set the selected checkbox color
      );
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide.none,
                top: BorderSide.none,
                right: BorderSide.none,
                left: BorderSide(
                    color: Color(0xffE95622),
                    style: BorderStyle.solid,
                    width: 2),
              ),
              color: Colors.white.withOpacity(.3),
              // borderRadius: BorderRadius.all(
              //   Radius.circular(20),
              // ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color(0xffE95622),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                            child: Text(
                                widget.testScriptModel
                                    .testBlockArray![widget.testIndex].type!
                                    .toUpperCase(),
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.testScriptModel
                                .testBlockArray![widget.testIndex].testName!,
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Wrap(
                        spacing: 10.0, // space between each chip
                        children: List<Widget>.generate(
                            widget
                                .testScriptModel
                                .testBlockArray![widget.testIndex]
                                .testTags!
                                .length, (int index) {
                          return Chip(
                            label: Text(
                              widget
                                  .testScriptModel
                                  .testBlockArray![widget.testIndex]
                                  .testTags![index],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            textStyle: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          child: Text("Change test script name"),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: widget.testScriptModel.testBlockArray![widget.testIndex]
              .testStepsArray!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(
                        color: Color(0xffE95622).withOpacity(.2),
                        style: BorderStyle.solid,
                        width: 50),
                  ),
                  color: Colors.white.withOpacity(.3),
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(20),
                  // ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
                                child: Text("STEP",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .6,
                              child: Text(
                                widget
                                    .testScriptModel
                                    .testBlockArray![widget.testIndex]
                                    .testStepsArray![index]
                                    .humanReadableStatement!,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(widget
                                          .testScriptModel
                                          .testBlockArray![widget.testIndex]
                                          .testStepsArray![index]
                                          .humanReadableStatement!),
                                      content: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                widget
                                                    .testScriptModel
                                                    .testBlockArray![
                                                        widget.testIndex]
                                                    .testStepsArray![index]
                                                    .statement!,
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  })
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "View code",
                                  child: Icon(Icons.code_outlined)),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                {widget.moveUp(widget.testIndex, index)},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "Move up",
                                  child: Icon(Icons.move_up_outlined)),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                {widget.moveDown(widget.testIndex, index)},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "Move down",
                                  child: Icon(Icons.move_down_outlined)),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.add),
                            onSelected: (String value) {
                              if (value == "action") {
                                _updateFormData(actionFormData);
                              } else if (value == "verification") {
                                _updateFormData(verificationFormData);
                              }
                              _showForm();
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'action',
                                  child: Text('Add action'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'verification',
                                  child: Text('Add verification'),
                                ),
                              ];
                            },
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => showEditForm(
                                    context,
                                    widget
                                        .testScriptModel
                                        .testBlockArray![widget.testIndex]
                                        .testStepsArray![index]
                                        .tokens!),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "Edit step",
                                  child: Icon(Icons.edit_outlined)),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                {widget.deleteAt(widget.testIndex, index)},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tooltip(
                                  message: "Delete step",
                                  child: Icon(Icons.delete_outline)),
                            ),
                          )
                        ],
                      )
                    ]),
              ),
            );
          },
        ),
      ],
    );
  }
}
