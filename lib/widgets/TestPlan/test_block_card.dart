// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_desktop_audio_recorder/flutter_desktop_audio_recorder.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/models/testScriptModel.dart';
import 'package:harbinger/widgets/Common/loader_widget.dart';
import 'package:harbinger/widgets/TestPlan/edit_step_popup.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../assets/constants.dart';
import '../../models/form_data.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TestBlockCard extends StatefulWidget {
  final TestScriptModel testScriptModel;
  final int testIndex;
  final Function(int, int) moveUp;
  final Function(int, int) moveDown;
  final Function(int, int) deleteAt;
  final Function(int, int, TestStep) addStepAfterIndex;
  final List<String> objectList;
  const TestBlockCard({
    super.key,
    required this.testScriptModel,
    required this.testIndex,
    required this.moveUp,
    required this.moveDown,
    required this.deleteAt,
    required this.objectList,
    required this.addStepAfterIndex,
  });

  @override
  State<TestBlockCard> createState() => _TestBlockCardState();
}

class _TestBlockCardState extends State<TestBlockCard> {
  bool isLoaded = true;
  final _controller = TextEditingController();
  List<FormData> currentFormData = actionFormData;
  Map<String, dynamic> formValues = {};
  final _formKey = GlobalKey<FormState>();
  String? _selectedStepType;
  String? _selectedObject;
  String? _selectedAction;
  String? _selectedExtraction;
  String? _selectedVerification;
  String? _selectedVerificationType;
  final TextEditingController actionPageController =
      TextEditingController(text: "page");
  final TextEditingController actionArgumentController =
      TextEditingController(text: "");
  final TextEditingController extractionPageController =
      TextEditingController(text: "page");
  final TextEditingController extractArgumentController =
      TextEditingController(text: "");
  final TextEditingController extractVariableController =
      TextEditingController(text: "");
  final TextEditingController verificationVariableController =
      TextEditingController(text: "");
  final TextEditingController verificationArgumentController =
      TextEditingController(text: "");

  final List<String> _stepTypes = [
    'Add action',
    'Add extraction step',
    'Add Verification'
  ];

  final List<String> _actions = availableActions;
  final List<String> _extractions = availableExtractions;
  final List<String> _verifications = assertions;

  void _updateFormData(List<FormData> formData) {
    setState(() {
      currentFormData = formData;
    });
  }

  Future<TestStep> getStatementSpecificTestStep(String addedStep) async {
    final url = 'http://localhost:1337/ast/getSpecificJSON';
    final headers = {"Content-type": "application/json"};
    final jsonBody = jsonEncode({"statement": addedStep});
    print(jsonBody);
    final response =
        await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    if (response.statusCode == 201) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      return TestStep.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to make request');
    }
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
                          ElevatedButton.icon(
                              onPressed: () {
                                print(formValues);
                                Navigator.of(context).pop();
                              },
                              label: Text('Save'),
                              icon: Icon(Icons.save)),
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

  void _showForm(stepIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add step',
            style: TextStyle(color: Color(0xffE95622)),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          value: _selectedStepType,
                          items: _stepTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedStepType = newValue as String?;
                              _selectedObject = null;
                              _selectedAction = null;
                              _selectedExtraction = null;
                              _selectedVerification = null;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Select step type",
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffE95622)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a step type';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_selectedStepType == 'Add action') ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedObject,
                            items: widget.objectList.map((object) {
                              return DropdownMenuItem(
                                value: object,
                                child: Text(object),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedObject = newValue as String?;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select Object",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: actionPageController,
                            decoration: InputDecoration(
                              labelText: "Enter page",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedAction,
                            items: _actions.map((action) {
                              return DropdownMenuItem(
                                value: action,
                                child: Text(action),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedAction = newValue as String?;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select Action",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: actionArgumentController,
                            decoration: InputDecoration(
                              labelText: "Enter Action Arguments",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_selectedStepType == 'Add extraction step') ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: extractVariableController,
                            decoration: InputDecoration(
                              labelText: "Enter Variable Name",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedObject,
                            items: widget.objectList.map((object) {
                              return DropdownMenuItem(
                                value: object,
                                child: Text(object),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedObject = newValue as String?;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select Object",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: extractionPageController,
                            decoration: InputDecoration(
                              labelText: "Enter page",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedExtraction,
                            items: _extractions.map((extraction) {
                              return DropdownMenuItem(
                                value: extraction,
                                child: Text(extraction),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedExtraction = newValue as String?;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select Extraction",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: extractArgumentController,
                            decoration: InputDecoration(
                              labelText: "Enter Arguments",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_selectedStepType == 'Add Verification') ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedVerificationType,
                            items:
                                ["expect", "expect.soft"].map((verification) {
                              return DropdownMenuItem(
                                value: verification,
                                child: Text(verification),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedVerificationType = newValue as String?;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select verification type",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: verificationVariableController,
                            decoration: InputDecoration(
                              labelText: "Enter Variable",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            value: _selectedVerification,
                            items: _verifications.map((verification) {
                              return DropdownMenuItem(
                                value: verification,
                                child: Text(verification),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedVerification = newValue as String?;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Select verification strategy",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: verificationArgumentController,
                            decoration: InputDecoration(
                              labelText: "Enter Expected Values",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffE95622)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            ElevatedButton.icon(
              label: Text('Add'),
              icon: Icon(Icons.add),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_selectedStepType == "Add action") {
                    String addedStep =
                        '${_selectedObject}(${actionPageController.text}).${_selectedAction}(${actionArgumentController.text});';
                    TestStep newStep =
                        await getStatementSpecificTestStep(addedStep);

                    widget.addStepAfterIndex(
                        widget.testIndex, stepIndex, newStep);
                    setState(() {
                      _selectedStepType = null;
                      _selectedObject = null;
                      _selectedAction = null;
                      _selectedExtraction = null;
                      _selectedVerification = null;
                    });
                    _formKey.currentState!.reset();
                  } else if (_selectedStepType == "Add extraction step") {
                    String addedStep =
                        'const ${extractVariableController.text} =${_selectedObject}(${extractionPageController.text}).${_selectedExtraction}(${extractArgumentController.text});';
                    TestStep newStep =
                        await getStatementSpecificTestStep(addedStep);

                    widget.addStepAfterIndex(
                        widget.testIndex, stepIndex, newStep);
                    setState(() {
                      _selectedStepType = null;
                      _selectedObject = null;
                      _selectedAction = null;
                      _selectedExtraction = null;
                      _selectedVerification = null;
                    });
                    _formKey.currentState!.reset();
                  } else {
                    String addedStep =
                        '${_selectedVerificationType}(${verificationVariableController.text}).${_selectedVerification}(${verificationArgumentController.text});';
                    print(addedStep);
                    TestStep newStep =
                        await getStatementSpecificTestStep(addedStep);

                    widget.addStepAfterIndex(
                        widget.testIndex, stepIndex, newStep);
                    setState(() {
                      _selectedStepType = null;
                      _selectedObject = null;
                      _selectedAction = null;
                      _selectedExtraction = null;
                      _selectedVerification = null;
                    });
                    _formKey.currentState!.reset();
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  _selectedStepType = null;
                  _selectedObject = null;
                  _selectedAction = null;
                  _selectedExtraction = null;
                  _selectedVerification = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormField(FormData field, StateSetter setState) {
    if (field.type == 'text') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
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
        ),
      );
    }

    if (field.type == 'list') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField(
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
        ),
      );
    }

    if (field.type == 'checkbox') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CheckboxListTile(
          title: Text(field.name),
          value: formValues[field.name] ?? field.defaultValue == 'checked',
          onChanged: (bool? value) {
            setState(() {
              formValues[field.name] = value!;
            });
          },
          activeColor: Color(0xffE95622), // Set the selected checkbox color
        ),
      );
    }

    return SizedBox.shrink();
  }

  void showGeneratedCodeDialog(
      BuildContext context, Future<String> generatedCode) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<String>(
              future: generatedCode,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 200,
                      width: 200,
                      child: LoadingAnimationWidget.hexagonDots(
                          color: Color(0xffE95622), size: 50),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    content: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return AlertDialog(
                    title: Text('Generated Code'),
                    content: HighlightView(
                      snapshot.data!,
                      language: 'javascript',
                      theme: githubTheme,
                      padding: EdgeInsets.all(12),
                      textStyle: TextStyle(
                        fontFamily: 'My-Flutter-Font',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Icon(Icons.copy, color: Color(0xffE95622)),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: snapshot.data!));
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              });
        });
  }

  Future<String> processTextInput(String userPrompt, String stepContext) async {
    String userInput = _controller.text;

    // Define the API endpoint
    String url = 'https://api.openai.com/v1/completions';

    // Define the headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer',
    };
    String prompt = "${userPrompt} ${stepContext}";
    final body = json.encode({
      'model': "text-davinci-003",
      'prompt': prompt,
      'max_tokens': 100,
      'n': 1,
      'stop': null,
      'temperature': 0.5,
    });

    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final generatedCode = responseData['choices'][0]['text'].trim();
      return generatedCode;
    } else {
      throw Exception('Failed to generate code. ${response.reasonPhrase}');
    }
  }

  void showTextInputDialog(BuildContext context, String stepContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What would you like to do?'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Instructions'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit', style: TextStyle(color: Color(0xffE95622))),
              onPressed: () async {
                Future<String> generatedCode =
                    processTextInput(_controller.text, stepContext);
                _controller.text = "";
                Navigator.of(context).pop();
                showGeneratedCodeDialog(context, generatedCode);
              },
            ),
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                                      title: Text(
                                        widget
                                            .testScriptModel
                                            .testBlockArray![widget.testIndex]
                                            .testStepsArray![index]
                                            .humanReadableStatement!,
                                      ),
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
                                          child: Text('Copy'),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: widget
                                                    .testScriptModel
                                                    .testBlockArray![
                                                        widget.testIndex]
                                                    .testStepsArray![index]
                                                    .statement!));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content:
                                                    Text('Copied to clipboard'),
                                              ),
                                            );
                                          },
                                        ),
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
                                _showForm(index);
                              } else if (value == "verification") {
                                _updateFormData(verificationFormData);
                              } else if (value == "createAI") {
                                showTextInputDialog(
                                    context,
                                    widget
                                        .testScriptModel
                                        .testBlockArray![widget.testIndex]
                                        .testStepsArray![index]
                                        .statement!);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'action',
                                  child: Text('Add action'),
                                ),
                                // PopupMenuItem<String>(
                                //   value: 'verification',
                                //   child: Text('Add verification'),
                                // ),
                                PopupMenuItem<String>(
                                  value: 'createAI',
                                  child: Text('AI - step generator'),
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
