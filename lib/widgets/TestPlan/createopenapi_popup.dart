// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

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
                  SizedBox(width: 30,),
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
                      await cloneprojectfromgithub(urlController.text);
                    }

                    setState(() {
                      isAnalyzing = true;
                      analysisResult = "Analyzing...";
                    });

                    // Perform analysis based on the entered URL or path
                    String input = urlController.text;
                    // Assuming there's a function for language analysis
                    String language = await analyzeLanguage(input);

                    setState(() {
                      analysisResult = "Creating json file for $language";
                    });

                    // Hit the createopenapi.jsonfile API
                    await createOpenApiJsonFile(input, language);

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
    // You can perform the logic for language analysis here
    // Make API call to localhost1337/analyselanguage or perform your own analysis

    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 5));

    // Replace this with your actual logic to determine the language
    return "path"; // For example
  }

  Future<String> analyzeLanguage(String input) async {
    // You can perform the logic for language analysis here
    // Make API call to localhost1337/analyselanguage or perform your own analysis

    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 7));

    // Replace this with your actual logic to determine the language
    return "springboot"; // For example
  }

  Future<void> createOpenApiJsonFile(String path, String language) async {
    // Make API call to localhost1337/createopenapi.jsonfile
    // Provide the path and language in the request
    // You might need to use a package like http or dio for API calls
    // Example using http package:
    // final response = await http.post('localhost1337/createopenapi.jsonfile', body: {'path': path, 'language': language});

    // Simulating a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 3));

    // Replace this with actual logic to handle the response
    print("OpenApi.json file created for $language at $path");
  }
}
