// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:harbinger/models/testScriptModel.dart';

class IfBlockForLoopScreen extends StatefulWidget {
  final screen;
  final List<TestStep> testStepArray;
  const IfBlockForLoopScreen(
      {super.key, required this.screen, required this.testStepArray});

  @override
  State<IfBlockForLoopScreen> createState() => _IfBlockForLoopScreenState();
}

class _IfBlockForLoopScreenState extends State<IfBlockForLoopScreen> {
  int page = 1;

  List<TestStep> selectedtestStepsArrayforloop = [];
  List<TestStep> selectedtestStepsArrayifloop = [];
  List<bool> selectedCheckboxes = [];
  TextEditingController conditionControllerforifblock = TextEditingController();
  TextEditingController initializationController =
      TextEditingController(text: "int i=0");
  TextEditingController conditionController =
      TextEditingController(text: "i>=1");
  TextEditingController incrementController =
      TextEditingController(text: "i++");

  @override
  initState() {
    super.initState();
    selectedCheckboxes = List.filled(widget.testStepArray.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: page == 1
              ? widget.screen == "Ifblock"
                  ? const Text('Teststeps for if block')
                  : const Text('Teststeps for for loop')
              : widget.screen == "Ifblock"
                  ? const Text('If Block')
                  : const Text('For Loop'),
          contentPadding: const EdgeInsets.all(16),
          content: page == 1
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: MediaQuery.of(context).size.height * 0.34,
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15,),
                       widget.screen == "Ifblock"? Text("select the teststeps to include in if block:"):Text("select the teststeps to include in for block: "),
                      ],
                    ),SizedBox(height: 7),
                    
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.testStepArray.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xFFEFEFEF)),
                              checkColor: Colors.grey,
                              value: selectedCheckboxes[index],
                              onChanged: (value) {
                                setState(() {
                                  selectedCheckboxes[index] = value ?? false;
                                  if (selectedCheckboxes[index] == true) {
                                    widget.screen == "Ifblock"
                                        ? selectedtestStepsArrayifloop
                                            .add(widget.testStepArray[index])
                                        : selectedtestStepsArrayforloop
                                            .add(widget.testStepArray[index]);
                                  } else {
                                    widget.screen == "Ifblock"
                                        ? selectedtestStepsArrayifloop
                                            .remove(widget.testStepArray[index])
                                        : selectedtestStepsArrayforloop
                                            .remove(widget.testStepArray[index]);
                                  }
                                });
                              },
                            ),
                            title: Text(
                              widget.testStepArray[index]
                                      .humanReadableStatement ??
                                  "N/A",
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: MediaQuery.of(context).size.height * 0.34,
                  child: widget.screen == "Ifblock"
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(14, 7, 14, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "If ( ",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: TextField(
                                      controller:
                                          conditionControllerforifblock,
                                      decoration: const InputDecoration(
                                        focusColor: Colors.white,
                                        fillColor: Colors.white,
                                        labelText:
                                            "Enter your condition here",
                                      ),
                                    ),
                                  ),
                                  const Text(" ) {",
                                      style: TextStyle(fontSize: 24)),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        selectedtestStepsArrayifloop.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                selectedtestStepsArrayifloop[
                                                            index]
                                                        .humanReadableStatement ??
                                                    "N/A"),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("}", style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.fromLTRB(14, 7, 14, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                const Text(
                                  "for(",
                                  style: TextStyle(fontSize: 24),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: initializationController,
                                    decoration: const InputDecoration(
                                      focusColor: Colors.white,
                                          fillColor: Colors.white,
                                      labelText: 'Initialization',
                                    ),
                                  ),
                                ),
                                const Text("; ",
                                    style: TextStyle(fontSize: 24)),
                                Flexible(
                                  child: TextField(
                                    controller: conditionController,
                                    decoration: const InputDecoration(
                                      focusColor: Colors.white,
                                          fillColor: Colors.white,
                                      labelText: 'Condition',
                                    ),
                                  ),
                                ),
                                const Text("; ",
                                    style: TextStyle(fontSize: 24)),
                                Flexible(
                                  child: TextField(
                                    controller: incrementController,
                                    decoration: const InputDecoration(
                                      focusColor: Colors.white,
                                          fillColor: Colors.white,
                                      labelText: 'Increment',
                                    ),
                                  ),
                                ),
                                const Text(")",
                                    style: TextStyle(fontSize: 24)),
                                const Text("{",
                                    style: TextStyle(fontSize: 24))
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      selectedtestStepsArrayforloop.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              selectedtestStepsArrayforloop[index]
                                                      .humanReadableStatement ??
                                                  "N/A"),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            const Row(
                              children: [
                                Text("}", style: TextStyle(fontSize: 24)),
                              ],
                            )
                          ],
                        ),
                      )),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed: () {
                  page == 1
                      ? Navigator.of(context).pop()
                      : setState(() {
                          page = 1;
                        });
                },
                child: page == 1
                    ? const Text(
                        "Close",
                        selectionColor: Color(0xFFCCCCCC),
                        style: TextStyle(color: Colors.black),
                      )
                    : const Text(
                        "Back",
                        selectionColor: Color(0xFFCCCCCC),
                        style: TextStyle(color: Colors.black),
                      ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: const Color.fromARGB(255, 3, 129, 7)),
                hoverColor: const Color.fromARGB(255, 5, 152, 10),
                onPressed: () {
                  page == 1
                      ? setState(() {
                          page = 2;
                        })
                      : Navigator.of(context).pop();
                },
                icon: const Row(
                  children: [
                    Icon(Icons.skip_next, color: Colors.white),
                    Text(
                      "Next ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        );
      },
    );
  }
}
