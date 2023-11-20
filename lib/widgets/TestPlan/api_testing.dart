// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'dart:convert';
import 'package:harbinger/models/response_model.dart';
import 'package:harbinger/widgets/TestPlan/choose_endpointspopup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

class ApiTesting extends StatefulWidget {
  final String? page;
  final void Function(Map<String, dynamic>) onSave;
  final String? reqBody;
  final List<RequestParameter>? queryParam;
  final String? endpointPath;
  final String? httpMethod;
  final String? responseSchema;
  final String? baseUrl;
  final String? headers;

  const ApiTesting({
    required this.page,
    required this.onSave,
    required this.reqBody,
    required this.queryParam,
    required this.endpointPath,
    required this.httpMethod,
    required this.responseSchema,
    required this.baseUrl,
    required this.headers,
    Key? key,
  }) : super(key: key);

  @override
  State<ApiTesting> createState() => ApiTestingState();
}

class ApiTestingState extends State<ApiTesting> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController urlController = TextEditingController();
  TextEditingController baseurlController = TextEditingController();
  int? status = 200;
  TextEditingController requestBodyController = TextEditingController();
  TextEditingController responseBodyController = TextEditingController();
  TextEditingController requestparamController = TextEditingController();
  TextEditingController headersController = TextEditingController();
  String selectedHttpMethod = 'get'; // Default HTTP method
  String selectedBaseUrl = 'https://example.com';

  // Default BASEURL

  String expandedSection = "";
  TextEditingController statusController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController keyOfVariableController = TextEditingController();
  TextEditingController variableController = TextEditingController();
  String keyofvalue = "";

  getValue(value) {
    if (value == "integer") {
      keyofvalue = "1";
    } else if (value == "string")
      keyofvalue = "str";
    else if (value == "boolean")
      keyofvalue = "true";
    else {
      keyofvalue = value;
    }

    return keyofvalue;
  }

  @override
  void initState() {
    urlController.text = widget.endpointPath!;
    requestBodyController.text = widget.reqBody!;
    responseBodyController.text = widget.responseSchema!;
    selectedHttpMethod = widget.httpMethod!;
    selectedBaseUrl = widget.baseUrl!;
    baseurlController.text = widget.baseUrl!;
    headersController.text = widget.headers!;
    if (widget.queryParam!.length != 0) {
      print("check1");
      urlController.text += "?";
      for (int i = 0; i < widget.queryParam!.length; i++) {
        print("check2");
        if (i > 0) urlController.text += "&";
        print("check2.0${widget.queryParam![i].name!}");
        urlController.text += widget.queryParam![i].name!;
        print("check2.1${widget.queryParam![i].type!}");
        urlController.text += "=";
        urlController.text += getValue(widget.queryParam![i].type!);
        print("check3");

        widget.queryParam![i].placeholder =
            getValue(widget.queryParam![i].type!);
        print("checkinggggg${getValue(widget.queryParam![i].type!)}");
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .6,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Accordion(
                        // rightIcon: ,
                        headerBackgroundColor: Color(0xFFE8E8E8),
                        rightIcon: const Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        contentBorderColor: Color(0xFFE8E8E8),
                        children: [
                          AccordionSection(
                            header: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  const Text("Select here to give validation"),
                            ),
                            isOpen: false,
                            content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Accordion(
                                      contentBorderColor: Color(0xFFE8E8E8),
                                      headerBorderColor: Color(0xFFE8E8E8),
                                      rightIcon: const Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      children: [
                                        AccordionSection(
                                          headerBackgroundColor:
                                              Color(0xFFE8E8E8),
                                          header: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                const Text("Status Validation"),
                                          ),
                                          isOpen: false,
                                          content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextField(
                                                  controller: statusController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Enter the expected Status Code'),
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                              ]),
                                        ),
                                        AccordionSection(
                                          headerBackgroundColor:
                                              Color(0xFFE8E8E8),
                                          header: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text(
                                                "Key-Value Validation"),
                                          ),
                                          isOpen: false,
                                          content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextField(
                                                  controller: keyController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Enter the Key for which value to be validated'),
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextField(
                                                  controller: valueController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Enter the Expected Value'),
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                              ]),
                                        ),
                                        AccordionSection(
                                          headerBackgroundColor:
                                              Color(0xFFE8E8E8),
                                          headerBorderColor: Color(0xFFE8E8E8),
                                          header: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text(
                                                "Extract Key and Set in Variable"),
                                          ),
                                          isOpen: false,
                                          content: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextField(
                                                  controller:
                                                      keyOfVariableController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Enter the Key to be extracted'),
                                                  style: TextStyle(
                                                      color: Colors.black26),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextField(
                                                  controller:
                                                      variableController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Enter the Variable Name in which you want to store'),
                                                  style: TextStyle(
                                                      color: Colors.black26),
                                                ),
                                              ]),
                                        )
                                      ]),
                                ]),
                          )
                        ]),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Navigation bar or method selection
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 216, 215, 215),
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      DropdownButton<String>(
                                        value: selectedHttpMethod,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedHttpMethod = newValue!;
                                          });
                                        },
                                        items: const [
                                          DropdownMenuItem<String>(
                                            value: 'get',
                                            child: Text('GET'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'post',
                                            child: Text('POST'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'put',
                                            child: Text('PUT'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'delete',
                                            child: Text('DELETE'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'patch',
                                            child: Text('PATCH'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: baseurlController.text,
                                          onChanged: (newValue) {
                                            setState(() {
                                              baseurlController.text =
                                                  newValue!;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<String>(
                                              value: 'BASEURL',
                                              child: Text('BASEURL'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: selectedBaseUrl,
                                              child: Text(selectedBaseUrl),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: 'https://example1.com',
                                              child:
                                                  Text('https://example1.com'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: urlController,
                                          decoration: const InputDecoration(
                                              labelText: 'URL'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 19.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      ' ',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 34, 197, 40)),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 212, 211, 211),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: headersController,
                                            maxLines: 4,
                                            decoration: const InputDecoration(
                                              labelText: 'Headers',
                                              //labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    widget.queryParam?.length == 0
                                        ? Expanded(
                                            child: Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 224, 223, 223),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                              ),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller:
                                                        requestparamController,
                                                    maxLines: 4,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Request param',
                                                      // labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  )),
                                            ),
                                          )
                                        : Expanded(
                                            child: Container(
                                              height: 150,
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("Request param"),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount: widget.queryParam
                                                            ?.length ??
                                                        0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Card(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          'Key'),
                                                                  controller:
                                                                      TextEditingController(
                                                                    text: widget
                                                                        .queryParam?[
                                                                            index]
                                                                        .name,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    urlController
                                                                            .text =
                                                                        widget
                                                                            .endpointPath!;
                                                                    // Update the name when the text changes
                                                                    widget
                                                                        .queryParam?[
                                                                            index]
                                                                        .name = value;
                                                                    if (widget
                                                                            .queryParam!
                                                                            .length !=
                                                                        0) {
                                                                      urlController
                                                                              .text +=
                                                                          "?";
                                                                      for (int i =
                                                                              0;
                                                                          i < widget.queryParam!.length;
                                                                          i++) {
                                                                        if (i >
                                                                            0) {
                                                                          urlController.text +=
                                                                              "&";
                                                                        }
                                                                        urlController.text += widget
                                                                            .queryParam![i]
                                                                            .name!;
                                                                        urlController.text +=
                                                                            "=";
                                                                        urlController.text += widget
                                                                            .queryParam![i]
                                                                            .placeholder!;
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          'Value'),
                                                                  controller:
                                                                      TextEditingController(
                                                                    text: widget
                                                                        .queryParam?[
                                                                            index]
                                                                        .placeholder,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    urlController
                                                                            .text =
                                                                        widget
                                                                            .endpointPath!;
                                                                    widget
                                                                        .queryParam![
                                                                            index]
                                                                        .placeholder = value;
                                                                    if (widget.queryParam !=
                                                                            null ||
                                                                        widget.queryParam!.length !=
                                                                            0) {
                                                                      urlController
                                                                              .text +=
                                                                          "?";
                                                                      for (int i =
                                                                              0;
                                                                          i < widget.queryParam!.length;
                                                                          i++) {
                                                                        if (i >
                                                                            0) {
                                                                          urlController.text +=
                                                                              "&";
                                                                        }
                                                                        urlController.text += widget
                                                                            .queryParam![i]
                                                                            .name!;
                                                                        urlController.text +=
                                                                            "=";
                                                                        urlController.text += widget
                                                                            .queryParam![i]
                                                                            .placeholder!;
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 223, 222, 222),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: requestBodyController,
                                            maxLines:
                                                8, // Make it multiline (expanded)
                                            decoration: const InputDecoration(
                                              labelText: 'Request Body',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height:
                                            200, // Adjust the height as needed to double the original size
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 224, 223, 223),
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            readOnly: true,
                                            controller: responseBodyController,
                                            maxLines:
                                                10, // Make it multiline (expanded)
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Expected Response Schema',
                                              //labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // if (widget.page != "next") {

                            // }
                            createMapAndAdd();

                            //  if(widget.page != "next")performApiRequest();
                          },
                          child: widget.page == "next"
                              ? Text("Next")
                              : Text("Generate")),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  createMapAndAdd() {
    String httpMethod = selectedHttpMethod;
    String url = baseurlController.text + urlController.text;
    String requestBody = requestBodyController.text;
    String path = urlController.text;
    String headers = headersController.text;
    String queryParams = requestparamController.text;
    String expectedStatusCode = statusController.text;
    String expectedkey = keyController.text;
    String expectedvalue = valueController.text;
    String expectedkeyOfVariable = keyOfVariableController.text;
    String expectedvariable = variableController.text;

    bool isStatusValidation = false;
    bool isKeyValueValidation = false;
    bool isExtractkeyValidation = false;

    if (expectedStatusCode != "" || expectedStatusCode.trim() != "") {
      isStatusValidation = true;
    }
    if (expectedkey != "" || expectedkey.trim() != "") {
      isKeyValueValidation = true;
    }
    if (expectedkeyOfVariable != "" || expectedkeyOfVariable.trim() != "") {
      isExtractkeyValidation = true;
    }

    Map<String, dynamic> map = {
      "method": httpMethod,
      "url": url,
      "path": path,
      "requestBody": requestBody,
      "headers": headers,
      "queryParams": queryParams,
      "isStatusValidation": isStatusValidation,
      "isKeyValueValidation": isKeyValueValidation,
      "isExtractkeyValidation": isExtractkeyValidation,
      "expectedStatusCode": expectedStatusCode,
      "expectedKeyValue": {expectedkey: expectedvalue},
      "expectedkeyAndVariableName": {expectedkeyOfVariable: expectedvariable}
    };
    widget.onSave(map);

    // return map;
  }

  Widget buildSectionButton(String sectionName) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          expandedSection = sectionName;
        });
      },
      child: Text(sectionName),
    );
  }

  Widget buildSectionContent(String sectionName, String content) {
    return Visibility(
      visible: expandedSection == sectionName,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(content),
      ),
    );
  }
}

Map<String, dynamic> parseJsonString(String jsonString) {
  try {
    final Map<String, dynamic> parsedJson = json.decode(jsonString);
    return parsedJson;
  } catch (e) {
    print('Error parsing JSON: $e');
    return <String, dynamic>{};
  }
}
