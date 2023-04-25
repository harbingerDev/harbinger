import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TestSteps {
  TestSteps(
      this.type,
      this.variableName,
      this.operatedOn,
      this.locatorStrategy1,
      this.locatorValue1,
      this.locatorStrategy2,
      this.locatorValue2,
      this.locatorStrategy3,
      this.locatorValue3,
      this.action,
      this.actionArgument,
      this.addStep);

  String type,
      variableName,
      operatedOn,
      locatorStrategy1,
      locatorValue1,
      locatorStrategy2,
      locatorValue2,
      locatorStrategy3,
      locatorValue3,
      action,
      actionArgument,
      addStep;

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<String>(columnName: 'Step type', value: type),
      DataGridCell<String>(columnName: 'Variable name', value: variableName),
      DataGridCell<String>(columnName: 'Operated on', value: operatedOn),
      DataGridCell<String>(
          columnName: 'Locator strategy 1', value: locatorStrategy1),
      DataGridCell<String>(columnName: 'Locator value 1', value: locatorValue1),
      DataGridCell<String>(
          columnName: 'Locator strategy 2', value: locatorStrategy2),
      DataGridCell<String>(columnName: 'Locator value 2', value: locatorValue2),
      DataGridCell<String>(
          columnName: 'Locator strategy 3', value: locatorStrategy3),
      DataGridCell<String>(columnName: 'Locator value 3', value: locatorValue3),
      DataGridCell<String>(columnName: 'Action', value: action),
      DataGridCell<String>(
          columnName: 'Action argument', value: actionArgument),
      DataGridCell<String>(columnName: 'Add step', value: addStep),
    ]);
  }
}
