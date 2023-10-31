import 'dart:collection';
import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:harbinger/models/Endpoint.dart';
import 'package:harbinger/models/response_model.dart';
import 'package:harbinger/widgets/TestPlan/api_testing.dart';
import 'package:http/http.dart' as http;

class EndpointWidget extends StatefulWidget {
  final List<Endpoint> endpoints;

  const EndpointWidget({super.key, required this.endpoints});

  @override
  _EndpointWidgetState createState() => _EndpointWidgetState();
}

class _EndpointWidgetState extends State<EndpointWidget> {
  List<int> selectedEndpoints = [];

  List<Endpoint> selectedEndpointsList = [];

  @override
  Widget build(BuildContext context) {
    String? reqBody;
    // RequestParameter? headers;
    List<RequestParameter>? pathvariable;
    List<RequestParameter>? queryparam;

    Future<Map<String, dynamic>> makeApiCallAndNavigateToApiScreen(
        Endpoint endpoint) async {
      Map<String, String> queryParams = {
        'api_info': endpoint.path,
        'http_method': endpoint.httpMethod,
      };

      String queryString = Uri(queryParameters: queryParams).query;
      String serverUrl = "http://127.0.0.1:8001/getapiinfo/?$queryString";

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        if (responseModel.reqbody != null) {
          String bodystart = "{";
          String bodyend = "\n}";
          for (RequestParameter parameter in responseModel.reqbody!) {
            if (parameter.type == 'string') {
              bodystart += '\n"${parameter.name}" : "string",';
            } else if (parameter.type == 'boolean') {
              bodystart += '\n"${parameter.name}" : true,';
            } else {
              bodystart += '\n"${parameter.name}" : 0,';
            }
          }

          if (bodystart != '{') {
            bodystart = bodystart.substring(0, bodystart.length - 1);
          }
          reqBody = bodystart + bodyend;
        }
        if (responseModel.pathvariable != null) {
          pathvariable = responseModel.pathvariable;
        }
        if (responseModel.queryparam != null) {
          queryparam = responseModel.queryparam;
        }
        // if (responseModel.pathvariable != null) {
        //   headers = responseModel.securityparameters;
        // }

        Map<String, dynamic> map = HashMap<String, dynamic>();
        map.addAll({
          "reqBody": reqBody,
          "queryParam": queryparam,
          "endpointPath": endpoint.path,
          "httpMethod": endpoint.httpMethod,
          // "headers": headers
        });

        return map;
      } else {
        throw Exception("ERROR IN GETTING");
      }
    }

    Future<Map<int, dynamic>> getMapOfAllEndpointsSchemasReqBodyQueryParam(
        List<Endpoint> endpoints) async {
      Map<int, dynamic> map = HashMap<int, dynamic>();
      print("inside getMapOfAllEndpointsSchemasReqBody$endpoints");

      for (int i = 0; i < endpoints.length; i++) {
        map[i] = await makeApiCallAndNavigateToApiScreen(endpoints[i]);
        print("getting$i");
      }
      return map;
    }

    List<String> tags = [];
    List<String> options = [
      'status code validation',
      'key validation',
      'schema vaildation'
    ];

    void showSelectedEndpointsDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Rearrange Endpoints"),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.41,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Rearrange the endpoints by dragging them from right side icon "),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > selectedEndpointsList.length) {
                                newIndex = selectedEndpointsList.length;
                              }
                              if (oldIndex < newIndex) {
                                newIndex--;
                              }
                              final item =
                                  selectedEndpointsList.removeAt(oldIndex);
                              selectedEndpointsList.insert(newIndex, item);
                            });
                          },
                          children: selectedEndpointsList
                              .asMap()
                              .entries
                              .map(
                                (entry) => ListTile(
                                  key: ValueKey(entry.key),
                                  title: Text(entry.value.path),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: (() async {
                      print("doing something");

                      print("doing something++");

                      Map<int, dynamic> maphavingRequestBodyAndAll =
                          await getMapOfAllEndpointsSchemasReqBodyQueryParam(
                              selectedEndpointsList);

                      Navigator.of(context).pop();

                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return ModalWithStepper(maphavingRequestBodyAndAll);
                          });
                    }),
                    child: const Text("Next"),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                //_showUploadPopup(context);
              },
              icon: const Icon(Icons.arrow_back)),
          Text("Method-Endpoint ${(widget.endpoints.length)}"),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showSelectedEndpointsDialog();
            },
            child: const Text("Use"),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.35,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.endpoints.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    fillColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 239, 239, 239)),
                    checkColor: Colors.grey,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Chip(
                          label: Text(
                            widget.endpoints[index].httpMethod,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFFF3752E),
                        ),
                        const SizedBox(width: 3),
                        Text(widget.endpoints[index].path),
                      ],
                    ),
                    value: selectedEndpoints.contains(index),
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        setState(() {
                          if (newValue) {
                            selectedEndpoints.add(index);
                            selectedEndpointsList.add(widget.endpoints[index]);
                          } else {
                            selectedEndpoints.remove(index);
                            selectedEndpointsList
                                .remove(widget.endpoints[index]);
                          }
                        });
                      }
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalWithStepper extends StatefulWidget {
  final Map<int, dynamic> dataMap;

  const ModalWithStepper(this.dataMap, {super.key});

  @override
  _ModalWithStepperState createState() => _ModalWithStepperState();
}

class _ModalWithStepperState extends State<ModalWithStepper> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Multiple Api Testing"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .8,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: currentPage,
          steps: List.generate(widget.dataMap.length, (index) {
            return Step(
              title: Text('Page ${index + 1}'),
              isActive: currentPage == index,
              content: SingleChildScrollView(
                  child: SizedBox(
                      width: 2000,
                      height: 2000,
                      child: ApiTesting(
                          endpointPath: widget.dataMap[index]["endpointPath"],
                          httpMethod: widget.dataMap[index]["httpMethod"],
                          queryParam: widget.dataMap[index]["queryParam"],
                          reqBody: widget.dataMap[index]["reqBody"]))
                  // child:Container(width: 2000,height: 2000,)
                  ),
            );
          }),
        ),
      ),
      actions: [
        if (currentPage < widget.dataMap.length - 1)
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentPage++;
              });
            },
            child: const Text("Next"),
          ),
        if (currentPage == widget.dataMap.length - 1)
          ElevatedButton(
            onPressed: () {
              // Generate button action
              // You can perform an action here when the user clicks "Generate."
            },
            child: const Text("Generate"),
          ),
      ],
    );
  }
}
