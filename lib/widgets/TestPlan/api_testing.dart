// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'dart:convert';
import 'package:harbinger/models/requestBody.dart';
import 'package:harbinger/models/response_model.dart';
import 'package:harbinger/widgets/TestPlan/choose_endpointspopup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

class ApiTesting extends StatefulWidget {
  final String? page;
  final void Function(Map<String, dynamic>) onSave;
  final List<RequestParameter>? reqBody;
  final List<RequestParameter>? queryParam;
  final String? endpointPath;
  final String? httpMethod;
  final String? responseSchema;
  final String? baseUrl;
  final Map<String, dynamic>? headers;
  final List<RequestParameter>? extraheaders;

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
    required this.extraheaders,
    Key? key,
  }) : super(key: key);

  @override
  State<ApiTesting> createState() => ApiTestingState();
}

class ApiTestingState extends State<ApiTesting> {
  bool validateSchema = false;
  List<RequestBodyParameter> reqbodyList = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController urlController = TextEditingController();
  TextEditingController baseurlController = TextEditingController();
  int? status = 200;
  TextEditingController requestBodyController = TextEditingController();
  TextEditingController responseBodyController = TextEditingController();
  TextEditingController requestparamController = TextEditingController();
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

  bool isFakerChecked = false;
  bool isDirectTestChecked = false;

  getValue(value) {
    if (value == "integer") {
      keyofvalue = "1";
    } else if (value == "string")
      keyofvalue = "str";
    else if (value == "boolean")
      keyofvalue = "true";
    else if (value == "date-time")
      keyofvalue = "2023-12-04T09:01:53.703Z";
    else {
      keyofvalue = value;
    }

    return keyofvalue + "";
  }

  initialiseReqBodyList() {
    List<RequestParameter>? requestBody = widget.reqBody;
    int index = 0;

    if (requestBody != null) {
      for (RequestParameter parameter in requestBody) {
        RequestBodyParameter tempParameter =
            RequestBodyParameter(); // Instantiate the object

        tempParameter.isFakerEnabled = false;

        tempParameter.fakertype = "";
        tempParameter.paramkey = parameter.name;
        tempParameter.paramtype = parameter.type;
        tempParameter.paramvalue = getValue(tempParameter.paramtype!);
        reqbodyList.add(tempParameter); // Add the object to the list
        index++;
      }
    }
    print("reqbodyList in init method$reqbodyList");
  }

  @override
  void initState() {
    initialiseReqBodyList();
    urlController.text = widget.endpointPath!;
    responseBodyController.text = widget.responseSchema!;
    selectedHttpMethod = widget.httpMethod!;
    selectedBaseUrl = widget.baseUrl!;
    baseurlController.text = widget.baseUrl!;
    if (widget.queryParam!.length != 0) {
      urlController.text += "?";
      for (int i = 0; i < widget.queryParam!.length; i++) {
        if (i > 0) urlController.text += "&";
        urlController.text += widget.queryParam![i].name!;
        urlController.text += "=";
        print("111111111111111111111111111111111111111111");

        if (widget.queryParam![i].type == null) {
          widget.queryParam![i].type = "undefined";
        }
        urlController.text += getValue(widget.queryParam![i].type!);
        print("222222222222222222222222222222222222222222222222");
        widget.queryParam![i].placeholder =
            getValue(widget.queryParam![i].type!);
        print("333333333333333333333333333333333333333");

        print("checkinggggg${getValue(widget.queryParam![i].type!)}");
      }
    }
    // reqbodymap.add

    super.initState();
  }

  Map<String, String> header = {};

  String selectedAuthorizationType = 'JWT Bearer'; // Default value
// List of authorization types for the dropdown
  List<String> authorizationTypes = ['JWT Bearer', 'Basic Auth', 'OAuth'];

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
                                        ),
                                      ]),
                                  Row(
                                    children: [
                                      Checkbox(
                                        fillColor: MaterialStateProperty.all(
                                          const Color.fromARGB(
                                              255, 235, 234, 234),
                                        ),
                                        value: validateSchema,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            validateSchema = value!;
                                          });
                                        },
                                        activeColor: const Color.fromARGB(
                                            255,
                                            236,
                                            234,
                                            234), // Color when checkbox is checked
                                        checkColor: Colors
                                            .green, // Color of the checkmark
                                      ),
                                      !validateSchema
                                          ? Text(
                                              "Wanna Validate the schemas enable the checkbox")
                                          : Text(
                                              "Dont Want to Validate the schemas disable the checkbox"),
                                    ],
                                  ),
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
                                      child: Column(
                                        children: [
                                          ////////////////
                                          Container(
                                            height: 100,
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("       Authorization"),
                                                  // DropdownButton(
                                                  //   value:
                                                  //       selectedAuthorizationType,
                                                  //   items: authorizationTypes
                                                  //       .map((String type) {
                                                  //     return DropdownMenuItem(
                                                  //       value: type,
                                                  //       child: Text(type),
                                                  //     );
                                                  //   }).toList(),
                                                  //   onChanged:
                                                  //       (String? newValue) {
                                                  //     setState(() {
                                                  //       selectedAuthorizationType =
                                                  //           newValue!;
                                                  //     });
                                                  //   },
                                                  // ),
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      if (widget.headers!
                                                              .length ==
                                                          0) {
                                                        setState(() {
                                                          widget.headers![
                                                                  "Authorization"] =
                                                              "`Bearer \${token}`";
                                                        });
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      widget.headers?.length ??
                                                          0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final headerKey = widget
                                                        .headers?.keys
                                                        .elementAt(index);
                                                    final headerValue = widget
                                                        .headers?[headerKey];

                                                    return Card(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextField(
                                                                readOnly: true,
                                                                decoration:
                                                                    InputDecoration(
                                                                        labelText:
                                                                            'Key'),
                                                                controller:
                                                                    TextEditingController(
                                                                  text:
                                                                      headerKey,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  // Nothing changed, as the key is read-only
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                        labelText:
                                                                            'Value'),
                                                                controller:
                                                                    TextEditingController(
                                                                  text: headerValue
                                                                      .toString(),
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  widget.headers?[
                                                                          headerKey!] =
                                                                      value;
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
                                          /////////////////////////////////////
                                          Container(
                                            height: 100,
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text("       Custom Headers"),
                                                ],
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: widget.extraheaders
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
                                                              child: TextField(
                                                                readOnly: true,
                                                                decoration:
                                                                    InputDecoration(
                                                                        labelText:
                                                                            'Header Key'),
                                                                controller:
                                                                    TextEditingController(
                                                                  text: widget
                                                                      .extraheaders?[
                                                                          index]
                                                                      .name,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  //nothing changed
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Expanded(
                                                              child: TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                        labelText:
                                                                            'Header Value'),
                                                                controller:
                                                                    TextEditingController(
                                                                  text: getValue(widget
                                                                      .extraheaders?[
                                                                          index]
                                                                      .type),
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  //on value changed
                                                                  widget
                                                                      .extraheaders?[
                                                                          index]
                                                                      .placeholder = value;
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
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    widget.queryParam?.length == 0
                                        ? Expanded(
                                            child: Container(
                                              height: 200,
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
                                                    maxLines: 8,
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: Row(
                                  children: [
                                    widget.reqBody?.length != 0
                                        ? Expanded(
                                            child: SizedBox(
                                              height: 200,
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          "Request Body              Want to enable Faker? Enable the checkbox!"),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount:
                                                        reqbodyList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      String selectedValue =
                                                          reqbodyList[index]
                                                                      .fakertype ==
                                                                  ""
                                                              ? 'Name'
                                                              : reqbodyList[
                                                                      index]
                                                                  .fakertype!;
                                                      List<String>
                                                          dropdownItems = [
                                                        'Name',
                                                        'Address',
                                                        'Email',
                                                        'UserName',
                                                        'Password',
                                                        'Number',
                                                        'FutureDate',
                                                        'CompanyName'
                                                      ];

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
                                                                  readOnly:
                                                                      true,
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          'Key'),
                                                                  controller:
                                                                      TextEditingController(
                                                                    text: reqbodyList[
                                                                            index]
                                                                        .paramkey,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    //key cant be changed
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              reqbodyList[index]
                                                                      .isFakerEnabled!
                                                                  ? Expanded(
                                                                      child:
                                                                          DropdownButton(
                                                                        value:
                                                                            selectedValue,
                                                                        items: dropdownItems.map((String
                                                                            value) {
                                                                          return DropdownMenuItem(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                Text(value),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (newValue) {
                                                                          print(
                                                                              'Selected Value 111: $newValue');
                                                                          print(
                                                                              'Index 111: $index');
                                                                          print(
                                                                              'reqbodyList 111: $reqbodyList');
                                                                          selectedValue =
                                                                              newValue!;
                                                                          setState(
                                                                              () {
                                                                            selectedValue =
                                                                                newValue!;
                                                                            reqbodyList[index].fakertype =
                                                                                selectedValue;
                                                                          });
                                                                        },
                                                                      ),
                                                                    )
                                                                  : Expanded(
                                                                      child:
                                                                          TextField(
                                                                        decoration:
                                                                            InputDecoration(labelText: 'Value'),
                                                                        controller:
                                                                            TextEditingController(
                                                                          text:
                                                                              reqbodyList[index].paramvalue!,
                                                                        ),
                                                                        onChanged:
                                                                            (value) {
                                                                          // setState(
                                                                          //     () {
                                                                          reqbodyList[index].paramvalue =
                                                                              value;
                                                                          // });
                                                                        },
                                                                      ),
                                                                    ),
                                                              Checkbox(
                                                                semanticLabel:
                                                                    "Enable Faker",
                                                                fillColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      235,
                                                                      234,
                                                                      234),
                                                                ),
                                                                value: reqbodyList[
                                                                        index]
                                                                    .isFakerEnabled!,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  setState(() {
                                                                    reqbodyList[index]
                                                                            .isFakerEnabled =
                                                                        value!;
                                                                  });
                                                                },
                                                                activeColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        236,
                                                                        234,
                                                                        234), // Color when checkbox is checked
                                                                checkColor: Colors
                                                                    .green, // Color of the checkmark
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
                                          )
                                        : Expanded(
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 223, 222, 222),
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
                                                      requestBodyController,
                                                  maxLines:
                                                      8, // Make it multiline (expanded)
                                                  decoration:
                                                      const InputDecoration(
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
                                            controller: responseBodyController,
                                            maxLines:
                                                10, // Make it multiline (expanded)
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'Expected Response Schema',
                                              //labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            onChanged: ((value) => {
                                                  setState(() {
                                                    responseBodyController
                                                        .text = value!;
                                                  })
                                                }),
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
                      Row(
                        children: [
                          !isDirectTestChecked
                              ? Text("Wanna test directly?")
                              : Text("Wanna create scripts? Uncheck it!"),
                          Checkbox(
                            fillColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 235, 234, 234),
                            ),
                            value: isDirectTestChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isDirectTestChecked = value!;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 236, 234,
                                234), // Color when checkbox is checked
                            checkColor: Colors.green, // Color of the checkmark
                          ),
                          isDirectTestChecked
                              ? ElevatedButton(
                                  onPressed: () async {
                                    Map<String, dynamic> convertedMap =
                                        convertListToMap(reqbodyList);

                                    String jsonString =
                                        json.encode(convertedMap);

                                    String responseBody =
                                        await performApiRequest(
                                      selectedHttpMethod,
                                      baseurlController.text +
                                          urlController.text,
                                      jsonString,
                                    );
                                    setState(() {
                                      responseBodyController.text =
                                          responseBody;
                                    });
                                  },
                                  child: Text("Test"))
                              : ElevatedButton(
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  createMapAndAdd() {
    print(validateSchema);
    print(widget.headers);
    String httpMethod = selectedHttpMethod;
    String url = baseurlController.text + urlController.text;
    String requestBody = requestBodyController.text;
    String path = urlController.text;
    Map<String, String> headers = {};
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

// Map<String, String> headers = {};

// Assuming widget.headers is Map<String, dynamic>?
// and widget.extraheaders is List<RequestParameter>?

    print("netx${widget.headers}");
    print("netx1${widget.extraheaders}");

    if (widget.headers != null && widget.extraheaders != null) {
      print("netx2${widget.headers}");

      // Add entries from widget.headers to headers
      headers.addAll(
        (widget.headers as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value?.toString() ?? '')),
      );
      print("netx3${widget.headers}  nectcc3 ${widget.extraheaders}");

      // Add entries from widget.extraheaders to headers
      for (int index = 0; index < widget.extraheaders!.length; index++) {
        final requestParameter = widget.extraheaders![index];
        if (requestParameter.name != null) {
          // Assuming requestParameter.placeholder is a non-null String
          headers[requestParameter.name!] = requestParameter.placeholder!;
        }
      }
      print("netx4${widget.headers}  nectcc4 ${widget.extraheaders}");
    }
    print("netx5${widget.headers}  nectcc5 ${widget.extraheaders}");

// Print the resulting headers map
    print('Headers: $headers');

    Map<String, dynamic> map = {
      "method": httpMethod,
      "url": url,
      "path": path,
      "requestBody": RequestBodyParameter.listToJson(reqbodyList),
      "responseSchema": responseBodyController.text,
      "headers": headers,
      "queryParams": queryParams,
      "isStatusValidation": isStatusValidation,
      "isKeyValueValidation": isKeyValueValidation,
      "isExtractkeyValidation": isExtractkeyValidation,
      "validateSchema": validateSchema,
      "expectedStatusCode": expectedStatusCode,
      "expectedKeyValue": {expectedkey: expectedvalue},
      "expectedkeyAndVariableName": {expectedkeyOfVariable: expectedvariable},
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

  Map<String, dynamic> convertListToMap(List<RequestBodyParameter> list) {
    Map<String, dynamic> result = {};
    for (var entry in list) {
      result[entry.paramkey!] = entry.paramvalue;
    }
    return result;
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

Future<String> performApiRequest(
    String httpMethod, String url, String requestBody) async {
  print(
      "Making API request with method: $httpMethod, URL: $url, and request body: $requestBody");

  Map<String, String> queryParams = {'method': httpMethod, 'url': url};
  Map<String, dynamic> parsedreqbody = parseJsonString(requestBody);
  print("parsedreqbody$parsedreqbody");

  String reqBodyJson = jsonEncode(parsedreqbody);
  // Encode the query parameters into a query string
  String queryString = Uri(queryParameters: queryParams).query;

  String serverUrl = "http://127.0.0.1:8000/env/makerequest/?$queryString";

  // Make the API call with the query parameters in the URL
  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: reqBodyJson,
  );

  if (response.statusCode == 200) {
    // Successful response
    final responseData = json.decode(response.body);
    print(responseData['response_body']);
    print(responseData['status']);
    return responseData['response_body'];
  }
  return "";
}
