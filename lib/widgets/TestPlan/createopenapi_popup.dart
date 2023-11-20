// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:harbinger/models/analysisResult.dart';
import 'package:http/http.dart' as http;

class CreateOpenApiJsonFile extends StatefulWidget {
  final VoidCallback onBackButtonPressed;
  const CreateOpenApiJsonFile({Key? key, required this.onBackButtonPressed})
      : super(key: key);

  @override
  State<CreateOpenApiJsonFile> createState() => _CreateOpenApiJsonFileState();
}

class _CreateOpenApiJsonFileState extends State<CreateOpenApiJsonFile> {
  TextEditingController urlController = TextEditingController();
  String analysisResult = "";
  bool isAnalyzing = false;

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
              const Text('Create OpenApi.json file'),
            ],
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            height: MediaQuery.of(context).size.height * 0.34,
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
                            TextStyle(fontSize: 16, color: Color(0xffE95622)))
                    : SizedBox.shrink(),
                SizedBox(height: 36),
                ElevatedButton(
                  onPressed: () async {
                    if (isGitHubRepo(urlController.text)) {
                      setState(() {
                        isAnalyzing = true;
                        analysisResult =
                            "Cloning project from github repository...";
                      });
                      final path =
                          await cloneprojectfromgithub(urlController.text);
                      analysisResult = "Cloned project in $path";
                    }

                    setState(() {
                      isAnalyzing = true;
                      analysisResult = "Analyzing...";
                    });

                    // Perform analysis based on the entered URL or path
                    String input = urlController.text;
                    // Assuming there's a function for language analysis
                    AnalysisResult result = await analyzeLanguage(input);
                    print(result.maxLanguage);
                    String languagesprint = "";
                    result.languages.forEach((key, value) {
                      languagesprint += "$key = $value files  ";
                    });
                    if (result.maxLanguage == "Unknown" &&
                        result.result == "Unknown") {
                      analysisResult = "Failed to analyse the language";
                    }
                    setState(() {
                      analysisResult =
                          " languages : \n ${languagesprint} \n max language ${result.maxLanguage}  ";
                    });
                    print("waiting for 3 sec");
                    await Future.delayed(Duration(seconds: 3));

                    // Hit the createopenapi.jsonfile API
                    if (result.maxLanguage != "Unknown") {
                      analysisResult =
                          "Creating openapi.json file for ${result.maxLanguage}";
                      await createOpenApiJsonFile(input, result.maxLanguage);
                    } else {
                      analysisResult = "Failed to analyse the language";
                    }

                    setState(() {
                      analysisResult = "OpenApi.json file created!";
                      isAnalyzing = false;
                    });

                    // You might want to close the dialog or handle completion differently
                    // Navigator.of(context).pop();
                  },
                  child: Text("Create "),
                ),
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
      return responseData.filepath;
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
        languages: Map.of({"unkown": 0}),
        result: "Unknown",
        maxLanguage: "Unknown"); // For example
  }

  Future<void> createOpenApiJsonFile(String path, String language) async {
    print(language);
    if (language == "JavaScript") {
      try {
        Map<String, String> queryParams = {
          'filePath': path,
        };
        String queryString = Uri(queryParameters: queryParams).query;

        final Uri apiUri = Uri.parse(
            "http://localhost:1337/generateSwaggerinNodejs?$queryString");

        final http.Client client = http.Client();
        final http.Response response = await client.get(
          apiUri,
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          // Extracting file name from Content-Disposition header
          // String fileName = response.headers['content-disposition']!
          //     .split('filename=')[1]
          //     .replaceAll('"', '');

          // Save the file
          File file = File("openapi.json");
          file.writeAsBytesSync(response.bodyBytes);

          // You can now use the 'file' variable to access the downloaded file.
          print('File downloaded successfully: ${file.path}');
        } else {
          print('Failed to download file. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error downloading file: $e');
      }
    }

    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 3));

    // Replace this with actual logic to handle the response
    print("OpenApi.json file created for $language at $path");
  }
}
