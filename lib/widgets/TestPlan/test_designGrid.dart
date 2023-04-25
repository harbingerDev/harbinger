// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/testSteps.dart';
import '../../models/testStepsDataSource.dart';

class TestDesignGrid extends StatefulWidget {
  const TestDesignGrid({super.key, required this.testSteps});
  final List<List<String>> testSteps;

  @override
  State<TestDesignGrid> createState() => _TestDesignGridState();
}

class _TestDesignGridState extends State<TestDesignGrid> {
  late TestStepsDataSource _testStepsDataSource;
  List<TestSteps> _testSteps = <TestSteps>[];
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
    _testSteps = getTestStepsData(widget.testSteps);
    _testStepsDataSource = TestStepsDataSource(_testSteps);
    _dataGridController = DataGridController();
    return SfDataGrid(
      isScrollbarAlwaysShown: false,
      allowColumnsResizing: true,
      source: _testStepsDataSource,
      allowEditing: true,
      selectionMode: SelectionMode.single,
      navigationMode: GridNavigationMode.cell,
      columnWidthMode: ColumnWidthMode.fill,
      controller: _dataGridController,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'Step type',
            label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text(
                  'Step type',
                ))),
        GridColumn(
            columnName: 'Variable name',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Variable name'))),
        GridColumn(
            columnName: 'Operated on',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'Operated on',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridColumn(
            columnName: 'Locator strategy 1',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Locator strategy 1'))),
        GridColumn(
            columnName: 'Locator value 1',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Locator value 1'))),
        GridColumn(
            columnName: 'Locator strategy 2',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Locator strategy 2'))),
        GridColumn(
            columnName: 'Locator value 2',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Locator value 2'))),
        GridColumn(
            columnName: 'Locator strategy 3',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Locator strategy 3'))),
        GridColumn(
            columnName: 'Locator value 3',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Locator value 3'))),
        GridColumn(
            columnName: 'Action',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('Action'))),
        GridColumn(
            columnName: 'Action argument',
            label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(
                  'Action argument',
                  softWrap: true,
                ))),
        GridColumn(
          columnName: 'button',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text('Add step'),
          ),
        ),
      ],
    );
  }

  List<TestSteps> getTestStepsData(List<List<String>> testSteps) {
    List<TestSteps> testStepList = [];
    for (var i = 0; i < testSteps.length; i++) {
      testStepList.add(TestSteps(
          testSteps[i][0],
          testSteps[i][1],
          testSteps[i][2],
          testSteps[i][3],
          testSteps[i][4],
          testSteps[i][5],
          testSteps[i][6],
          testSteps[i][7],
          testSteps[i][8],
          testSteps[i][9],
          testSteps[i][10],
          "Add step"));
    }
    return testStepList;
  }
}
