// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/arduino-light.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ShowCodeGPT extends StatefulWidget {
  final String filePath;
  ShowCodeGPT({required this.filePath});

  @override
  State<ShowCodeGPT> createState() => _ShowCodeGPTState();
}

class _ShowCodeGPTState extends State<ShowCodeGPT> {
  bool isLoaded = false;
  late String fileContent;
  late TextEditingController _controller;
  bool _showAddButton = false;
  int _hoveredLine = -1;

  Future<String> readFileAsString(String filePath) async {
    return File(widget.filePath).readAsString();
  }

  @override
  void initState() {
    super.initState();
    readFileAsString(widget.filePath).then((content) => {
          setState((() {
            fileContent = content;
            _controller = TextEditingController(text: content);
            isLoaded = true;
          }))
        });
  }

  Widget _buildHighlightedCode() {
    return HighlightView(
      _controller.text,
      language: 'javascript',
      theme: arduinoLightTheme,
      textStyle: TextStyle(fontFamily: 'monospace', fontSize: 12.0),
    );
  }

  Future<String> generateCode(String prompt) async {
    const String apiUrl = 'https://api.openai.com/v1/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ',
    };
    final body = json.encode({
      'model': "text-davinci-002",
      'prompt': prompt,
      'max_tokens': 100,
      'n': 1,
      'stop': null,
      'temperature': 0.5,
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print(response.body);
      final responseData = json.decode(response.body);
      final generatedCode = responseData['choices'][0]['text'].trim();

      return generatedCode;
    } else {
      throw Exception('Failed to generate code. ${response.reasonPhrase}');
    }
  }

  // Insert the generated code after the hovered line
  void insertGeneratedCode(String generatedCode) {
    print(generatedCode);
    // Get the current position of the text cursor
    int currentPosition = _controller.selection.baseOffset;

    if (currentPosition < 0) {
      currentPosition = 0;
    }

    // Find the end of the line containing the cursor
    int endOfLine = _controller.text.indexOf('\n', currentPosition);
    if (endOfLine == -1) endOfLine = _controller.text.length;

    // Insert the generated code
    String newText = _controller.text.substring(0, endOfLine) +
        '\n' +
        generatedCode +
        _controller.text.substring(endOfLine);
    _controller.value = _controller.value.copyWith(text: newText);
  }

  @override
  Widget build(BuildContext context) {
    List<String> lines = _controller.text.split('\n');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Color(0xffE95622),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "X",
          style: GoogleFonts.roboto(fontSize: 18),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  itemCount: lines.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MouseRegion(
                      onEnter: (_) => setState(() {
                        _hoveredLine = index;
                      }),
                      onExit: (_) => setState(() {
                        _hoveredLine = -1;
                      }),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: HighlightView(
                                lines[index],
                                language: 'javascript',
                                theme: arduinoLightTheme,
                                textStyle: TextStyle(
                                    fontFamily: 'monospace', fontSize: 12.0),
                              ),
                            ),
                          ),
                          if (_hoveredLine == index)
                            IconButton(
                              onPressed: () {
                                // Show the text box for user input
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Enter your prompt'),
                                      content: TextFormField(
                                        initialValue: '',
                                        onFieldSubmitted: (value) async {
                                          Navigator.pop(context);
                                          final generatedCode =
                                              await generateCode(value);
                                          insertGeneratedCode(generatedCode);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.add_circle_outline),
                            ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            )
          : Text("Loading"),
    );
  }
}
