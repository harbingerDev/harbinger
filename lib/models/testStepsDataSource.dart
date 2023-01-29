// ignore_for_file: prefer_const_constructors

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbinger/assets/constants.dart';
import 'package:harbinger/models/testSteps.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TestStepsDataSource extends DataGridSource {
  TestStepsDataSource(this._testSteps) {
    print(dataGridRows.isEmpty);
    dataGridRows = _testSteps
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  List<TestSteps> _testSteps = [];

  List<DataGridRow> dataGridRows = [];

  /// Helps to hold the new value of all editable widget.
  /// Based on the new value we will commit the new value into the corresponding
  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Tooltip(
        message: dataGridCell.value,
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            )),
      );
    }).toList());
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'Step type') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Step type', value: newCellValue);
      _testSteps[dataRowIndex].type = newCellValue.toString();
    } else if (column.columnName == 'Variable name') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Variable name', value: newCellValue);
      _testSteps[dataRowIndex].variableName = newCellValue.toString();
    } else if (column.columnName == 'Operated on') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Operated on', value: newCellValue);
      _testSteps[dataRowIndex].operatedOn = newCellValue.toString();
    } else if (column.columnName == 'Locator strategy 1') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Locator strategy 1', value: newCellValue);
      _testSteps[dataRowIndex].locatorStrategy1 = newCellValue.toString();
    } else if (column.columnName == 'Locator value 1') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Locator value 1', value: newCellValue);
      _testSteps[dataRowIndex].locatorValue1 = newCellValue.toString();
    } else if (column.columnName == 'Locator strategy 2') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Locator strategy 2', value: newCellValue);
      _testSteps[dataRowIndex].locatorStrategy2 = newCellValue.toString();
    } else if (column.columnName == 'Locator value 2') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Locator value 2', value: newCellValue);
      _testSteps[dataRowIndex].locatorValue2 = newCellValue.toString();
    } else if (column.columnName == 'Locator strategy 3') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Locator strategy 3', value: newCellValue);
      _testSteps[dataRowIndex].locatorStrategy3 = newCellValue.toString();
    } else if (column.columnName == 'Locator value 3') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Locator value 3', value: newCellValue);
      _testSteps[dataRowIndex].locatorValue3 = newCellValue.toString();
    } else if (column.columnName == 'Action') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Action', value: newCellValue);
      _testSteps[dataRowIndex].action = newCellValue.toString();
    } else if (column.columnName == 'Action argument') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'Action argument', value: newCellValue);
      _testSteps[dataRowIndex].actionArgument = newCellValue.toString();
    }
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final RegExp regExp = _getRegExp(column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: column.columnName == "Step type" ||
              column.columnName == "Action" ||
              column.columnName.contains("strategy")
          ? DropdownButton<String>(
              items: column.columnName == "Step type"
                  ? availableStepTypes
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : column.columnName == "Action"
                      ? availableActions
                          .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : availableLocatorStrategies
                          .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
              autofocus: true,
              focusColor: Colors.transparent,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.arrow_drop_down_sharp),
              isExpanded: true,
              onChanged: (String? value) {
                if (value!.isNotEmpty) {
                  newCellValue = value;
                } else {
                  newCellValue = null;
                }
              })
          : TextField(
              autofocus: true,
              controller: editingController..text = displayText,
              textAlign: TextAlign.center,
              autocorrect: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(regExp)
              ],
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                if (value.isNotEmpty) {
                  newCellValue = value;
                } else {
                  newCellValue = null;
                }
              },
              onSubmitted: (String value) {
                /// Call [CellSubmit] callback to fire the canSubmitCell and
                /// onCellSubmit to commit the new value in single place.
                submitCell();
              },
            ),
    );
  }

  RegExp _getRegExp(String colum) {
    return RegExp('[a-zA-Z ]');
  }
}
