import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceToText extends StatefulWidget {
  @override
  _VoiceToTextState createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking...';
  late FlutterTts _flutterTts;
  String respText = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    if (!_speech.isAvailable) {
      await _speech.initialize(
        onError: (error) => print('Error: $error'),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.mic),
                onPressed: startListening,
              ),
              IconButton(icon: Icon(Icons.stop), onPressed: stopListening),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_text),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      LoadingAnimationWidget.horizontalRotatingDots(
                        color: Color(0xffE95622),
                        size: 50,
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(respText),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> startListening() async {
    setState(() {
      _text = "";
    });

    if (!_speech.isAvailable) {
      print('Speech recognition not available');
      return;
    }

    _speech.listen(
      onResult: (result) async {
        setState(() {
          _text = result.recognizedWords;
        });
      },
    );
    // setState(() {
    //   _isListening = true;
    // });
  }

  Future<void> stopListening() async {
    setState(() {
      isLoading = true; 
    });

    String responseText = await apicall(_text);
    setState(() {
      isLoading = false;
      respText = responseText;
      _text = "";
    });

    await speak(respText);
    _speech.stop();
    // setState(() {
    //   _isListening = false;
    // });
  }

  Future<String> apicall(String text) async {
    final apiUrl =
        'http://localhost:8080/bot/chat?prompt=$text'; // Replace with your API endpoint
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {

      return response.body;
    } else {
      throw Exception('Failed to make API call');
    }
  }

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1);
    await _flutterTts.speak(text);
  }
}
