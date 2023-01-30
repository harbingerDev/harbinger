// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/testCase.dart';
import '../../models/testCaseStepsDataSource.dart';
import '../../models/testStepsDataSource.dart';

class TestStepGrid extends StatefulWidget {
  const TestStepGrid({super.key, required this.testSteps});
  final List<List<String>> testSteps;

  @override
  State<TestStepGrid> createState() => _TestStepGridState();
}

class _TestStepGridState extends State<TestStepGrid> {
  late TestCaseStepsDataSource _testStepsDataSource;
  List<TestCaseSteps> _testSteps = <TestCaseSteps>[];
  late DataGridController _dataGridController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dataGridController;
    _testSteps;
    _testStepsDataSource;
  }

  @override
  Widget build(BuildContext context) {
    _testSteps = getTestCaseData(widget.testSteps);
    _testStepsDataSource = TestCaseStepsDataSource(_testSteps);
    _dataGridController = DataGridController();
    return SfDataGrid(
      isScrollbarAlwaysShown: false,
      allowColumnsResizing: true,
      source: _testStepsDataSource,
      allowEditing: false,
      selectionMode: SelectionMode.single,
      navigationMode: GridNavigationMode.cell,
      columnWidthMode: ColumnWidthMode.fill,
      controller: _dataGridController,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'Step description',
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Step description',
            ),
          ),
        ),
      ],
    );
  }

  List<TestCaseSteps> getTestCaseData(List<List<String>> testSteps) {
    List<TestCaseSteps> testStepList = [];
    print(testSteps);
    for (var i = 0; i < testSteps.length; i++) {
      testStepList.add(TestCaseSteps(testSteps[i][0]));
    }

    return testStepList;
  }
}
