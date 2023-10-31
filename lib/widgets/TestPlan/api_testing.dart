import 'dart:convert';
import 'package:harbinger/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiTesting extends StatefulWidget {
  final String? reqBody;
  final List<RequestParameter>? queryParam;
  final String? endpointPath;
  final String? httpMethod;

  const ApiTesting({
    required this.reqBody,
    required this.queryParam,
    required this.endpointPath,
    required this.httpMethod,
    Key? key,
  }) : super(key: key);

  @override
  State<ApiTesting> createState() => _ApiTestingState();
}

class _ApiTestingState extends State<ApiTesting> {
  TextEditingController urlController = TextEditingController();
  TextEditingController baseurlController = TextEditingController();
  int? status = 200;
  TextEditingController requestBodyController = TextEditingController();
  TextEditingController responseBodyController = TextEditingController();
  TextEditingController requestparamController = TextEditingController();
  TextEditingController headersController = TextEditingController();
  String selectedHttpMethod = 'get'; // Default HTTP method
  String selectedBaseUrl = 'https://example.com'; // Default BASEURL

  String expandedSection = "";

  @override
  void initState() {
    urlController.text = widget.endpointPath!;
    requestBodyController.text = widget.reqBody!;
    selectedHttpMethod = widget.httpMethod!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
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
                          color: const Color.fromARGB(255, 216, 215, 215),
                          width: 2.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
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
                              value: selectedBaseUrl,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedBaseUrl = newValue!;
                                });
                              },
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'BASEURL',
                                  child: Text('BASEURL'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'https://example.com',
                                  child: Text('https://example.com'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'https://example2.com',
                                  child: Text('https://example2.com'),
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
                              decoration:
                                  const InputDecoration(labelText: 'URL'),
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
                              color: Color.fromARGB(255, 34, 197, 40)),
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
                                color: const Color.fromARGB(255, 212, 211, 211),
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
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
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 224, 223, 223),
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: requestparamController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Request param',
                                  // labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
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
                                color: const Color.fromARGB(255, 223, 222, 222),
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: requestBodyController,
                                maxLines: 8, // Make it multiline (expanded)
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
                                color: const Color.fromARGB(255, 224, 223, 223),
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: responseBodyController,
                                maxLines: 10, // Make it multiline (expanded)
                                decoration: const InputDecoration(
                                  labelText: 'Response Body',
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
      ),
    );
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
