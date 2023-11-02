// import 'dart:convert';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:harbinger/models/Endpoint.dart';
// import 'package:harbinger/widgets/TestPlan/test_script.dart';
// import 'package:http/http.dart' as http;
// Widget uploadjsonfile(BuildContext context){

//           return AlertDialog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     const Icon(FontAwesomeIcons.cloudUploadAlt, size: 100.0),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Upload the project openapi.json file to start API testing",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     print("uploading....");
//                     final result = await FilePicker.platform.pickFiles(
//                       type: FileType.custom,
//                       allowedExtensions: ['json'],
//                     );
//                     if (result != null && result.files.isNotEmpty) {
                   
//                       String serverUrl = "http://127.0.0.1:8001/uploadapiinfo/";
//                       final selectedFile = result.files.first;
//                       // Create an HTTP request to your backend
//                       final request =
//                           http.MultipartRequest('POST', Uri.parse(serverUrl));

//                       // Convert the Uint8List to List<int>
//                       final byteList = selectedFile.bytes!.toList();

//                       // Create a Stream from the List<int>
//                       final fileStream =
//                           Stream<List<int>>.fromIterable([byteList]);
//                       // Create a MultipartFile from the selected file
//                       final multipartFile = http.MultipartFile.fromBytes(
//                           'file', byteList,
//                           filename: selectedFile.name);

//                       // Add the file to the request
//                       request.files.add(multipartFile);

//                       // Send the request
//                       final response = await request.send();
//                       print("response: $response");
//                       if (response.statusCode == 200) {
//                         //make to next screen and send the data u got
                      

//                         final List<dynamic> responseData =
//                             json.decode(await response.stream.bytesToString());
//                         final List<Endpoint> endpoints = responseData
//                             .map((e) => Endpoint.fromJson(e))
//                             .toList();
//                         // // Navigate to the ChooseEndPointScreen and pass the 'endpoints' list
//                         // Provider.of<ScreenState>(context, listen: false)
//                         //     .changeScreen('endpoint',
//                         //         data: {"endpoints": endpoints});
//                         // print("changing");

//                         //naviagte
//                          Navigator.of(context).pop();
//                           const TestScript(tab:"")._showchooseendpointsPopup(endpoints);

//                         print('image uploaded');
//                       } else {
//                         print('failed');
                       
//                       }
//                     } else {
//                       print("No file selected.");
//                     }
//                   },
//                   child: const Text("upload"),
//                 ),
//               ],
//             ),
//           );
// }
