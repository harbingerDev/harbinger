import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TestCaseSteps {
  TestCaseSteps(
    this.stepDescription,
  );

  String stepDescription;

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<String>(
          columnName: 'Step description', value: stepDescription),
    ]);
  }
}
