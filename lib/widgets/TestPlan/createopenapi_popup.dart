// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:harbinger/models/Endpoint.dart';
import 'package:harbinger/models/analysisResult.dart';
import 'package:harbinger/widgets/TestPlan/choose_endpointspopup.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CreateOpenApiJsonFile extends StatefulWidget {
  final VoidCallback onBackButtonPressed;
  final String activeprojectpath;
  final VoidCallback? callback;
  const CreateOpenApiJsonFile(
      {Key? key,
      required this.onBackButtonPressed,
      required this.activeprojectpath,
      this.callback})
      : super(key: key);

  @override
  State<CreateOpenApiJsonFile> createState() => _CreateOpenApiJsonFileState();
}

class _CreateOpenApiJsonFileState extends State<CreateOpenApiJsonFile> {
  TextEditingController urlController = TextEditingController();
  String analysisResult = "";
  bool isAnalyzing = false;
  bool iscreate = true;
  String uploadpath = "";
  String projectName = "";
  String path = "";
  bool disableButton = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onBackButtonPressed();
                  },
                  icon: const Icon(Icons.arrow_back)),
              SizedBox(
                width: 30,
              ),
              const Text('Harbinger Analyser'),
            ],
          ),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            height: MediaQuery.of(context).size.height * 0.39,
            child: Column(
              children: [
                // Text(
                //     "Enter the project GitHub repository URL or the local path "),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: "GitHub Repository URL or Local Path",
                    hintText:
                        "e.g., https://github.com/username/repository.git or C:\\Users\\username\\Documents\\project",
                    helperText:
                        "Provide the project GitHub repository URL or the local path of your project",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                isAnalyzing
                    ? Text(analysisResult,
                        style:
                            // TextStyle(fontSize: 16, color: Color(0xffE95622)))
                            TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 54, 54, 54)))
                    : SizedBox.shrink(),
                SizedBox(height: 36),
                !disableButton
                    ? ElevatedButton(
                        onPressed: iscreate
                            ? () async {
                                String input = urlController.text;
                                setState(() {
                                  disableButton = true;
                                  isAnalyzing = true;
                                  analysisResult =
                                      "Harbinger Analyser is Analysing ...";
                                });
                                await Future.delayed(Duration(seconds: 3));
                                if (isGitHubRepo(urlController.text)) {
                                  setState(() {
                                    isAnalyzing = true;
                                    analysisResult =
                                        "Cloning project from github repository...";
                                  });
                                  await Future.delayed(Duration(seconds: 2));
                                  path = await cloneprojectfromgithub(
                                      urlController.text);
                                  print(path);
                                  setState(() {
                                    analysisResult =
                                        "Cloned project in $path ...";
                                  });
                                }
                                await Future.delayed(Duration(seconds: 3));

                                setState(() {
                                  isAnalyzing = true;
                                  analysisResult =
                                      "Analysing project language...";
                                });

                                // Perform analysis based on the entered URL or path
                                if (!isGitHubRepo(input)) {
                                  RegExp regex = RegExp(r'\\([^\\]+)$');

                                  Match match = regex.firstMatch(input)!;

                                  if (match != null) {
                                    String extractedString = match.group(1)!;
                                    setState((() {
                                      projectName = extractedString;
                                    }));

                                    print(
                                        extractedString); // Output: harbinger_backend
                                  } else {
                                    print('Pattern not found in the path');
                                  }
                                } else if (isGitHubRepo(input)) {
                                  RegExp regex = RegExp(
                                      r'https://github\.com/([^/]+/[^/]+)\.git');
                                  Match match = regex.firstMatch(input)!;

                                  if (match != null && match.groupCount >= 1) {
                                    projectName = match.group(1)!;
                                  } else {
                                    projectName = "demo";
                                  }
                                }
                                // Assuming there's a function for language analysis
                                if (isGitHubRepo(input)) {
                                  input = path;
                                }
                                AnalysisResult result =
                                    await analyzeLanguage(input);
                                print(result.maxLanguage);
                                String languagesprint = "";
                                // result.languages.forEach((key, value) {
                                //   languagesprint += "$key = $value files  ";
                                // });
                                if (result.maxLanguage == "NA") {
                                  setState(() {
                                    disableButton = true;

                                    analysisResult =
                                        "Sorry, Harbinger Analyser Failed to analyse the language";
                                  });
                                }
                                setState(() {
                                  analysisResult =
                                      "Harbinger Analyser analysed your project is with ${result.maxLanguage} language  ";
                                });
                                print("waiting for 3 sec");

                                await Future.delayed(Duration(seconds: 4));
                                print("after 3 sec");

                                // Hit the createopenapi.jsonfile API
                                if (result.maxLanguage != "Unknown") {
                                  setState(() {
                                    analysisResult =
                                        "Anaysing your ${result.maxLanguage} project to get endpoints ....";
                                  });
                                  String textresult =
                                      await createOpenApiJsonFile(
                                          input, result.maxLanguage);
                                  print("textresult$textresult");
                                  setState(() {
                                    analysisResult = textresult;
                                  });
                                } else {
                                  setState(() {
                                    disableButton = true;
                                    analysisResult =
                                        "Sorry, Harbinger Analyser Failed to analyse the language";
                                  });
                                }
                              }
                            : () async {
                                Map<String, String> queryParams = {
                                  'path': uploadpath,
                                };
                                String queryString =
                                    Uri(queryParameters: queryParams).query;

                                final Uri apiUri = Uri.parse(
                                    "http://localhost:1337/uploadFileWithPath?$queryString");

                                // You can perform the logic for language analysis here
                                final response = await http.post(
                                  apiUri,
                                  headers: {
                                    'Content-Type': 'application/json',
                                  },
                                );
                                if (response.statusCode == 200) {
                                  final List<dynamic> responseData =
                                      json.decode(response.body);
                                  final List<Endpoint> endpoints = responseData
                                      .map((e) => Endpoint.fromJson(e))
                                      .toList();

                                  Navigator.of(context).pop();
                                  _showchooseendpointsPopup(endpoints);
                                }
                              },
                        child: iscreate
                            ? Text("Create ")
                            : Text("Choose Endpoints"))
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isGitHubRepo(String input) {
    final RegExp gitHubRepoRegExp =
        RegExp(r'^https:\/\/github\.com\/[\w-]+\/[\w-]+\.git$');
    return gitHubRepoRegExp.hasMatch(input);
  }

  Future<String> cloneprojectfromgithub(String input) async {
    Map<String, String> queryParams = {
      'githubRepoUrl': input,
    };
    String queryString = Uri(queryParameters: queryParams).query;

    final Uri apiUri = Uri.parse(
        "http://localhost:1337/clonegithubrepointolocal?$queryString");
    final response = await http.get(
      apiUri,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    // You can perform the logic for language analysis here
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("github response$responseData");
      return responseData;
    }

    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 2));

    // Replace this with your actual logic to determine the language
    return "error in path"; // For example
  }

  Future<AnalysisResult> analyzeLanguage(String input) async {
    Map<String, String> queryParams = {
      'path': input,
    };
    String queryString = Uri(queryParameters: queryParams).query;

    final Uri apiUri =
        Uri.parse("http://localhost:1337/analyzeLanguage?$queryString");

    // You can perform the logic for language analysis here
    final response = await http.get(
      apiUri,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      AnalysisResult analysisResult = AnalysisResult.fromJson(responseData);
      print("analyzeLanguage response$analysisResult");
      return analysisResult;
    }
    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 2));

    // Replace this with your actual logic to determine the language
    return AnalysisResult(
        languages: Map.of({"Unknown": 0}),
        result: "Unknown",
        maxLanguage: "Unknown"); // For example
  }

  Future<String> createOpenApiJsonFile(String path, String language) async {
    print(language);
    if (language == "JavaScript" || language == "Java") {
      try {
        Map<String, String> queryParams = {
          'filePath': path,
          "projectName": projectName,
          "projectLanguage": language
        };
        String queryString = Uri(queryParameters: queryParams).query;

        final Uri apiUri =
            Uri.parse("http://localhost:1337/generateSwagger?$queryString");

        final http.Client client = http.Client();
        final http.Response response = await client.get(
          apiUri,
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          try {
            final responseData = json.decode(response.body);
            print("responseData$responseData");
            setState(() {
              uploadpath = responseData;
              disableButton = false;
              iscreate = false;
            });
            return "Harbinger Analyser Analysed successfully.";
          } catch (e) {
            setState(() {
              disableButton = true;
            });

            print('Error writing file: $e');
          }
        } else {
          setState(() {
            disableButton = true;
          });
          print('Failed to download file. Status code: ${response.statusCode}');
          return "Sorry, Harbinger Analyser failed to Analyse your project";
        }
      } catch (e) {
        setState(() {
          disableButton = true;
        });
        print('Error downloading file: $e');
      }
      return "Failed to analyse file.";
    } else {
      setState(() {
        disableButton = true;
      });
      return "Sorry, Harbinger Analyser doesnot supports $language as of now ";
    }
  }

  _showchooseendpointsPopup(List<Endpoint> endpoints) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return EndpointWidget(
              endpoints: endpoints,
              activeprojectpath: widget.activeprojectpath,
              callback: widget.callback);
        });
  }
}
