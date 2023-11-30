import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SuperadminDashboardOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 10, 0, 10),
                child: Chip(
                  elevation: 1,
                  backgroundColor: Colors.green.withOpacity(.2),
                  label: Text("Admin Dashboard",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 0, 0),
            child: Text(
              'Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FirstDashboardCard(title: 'Active Users', value: '500'),
              FirstDashboardCard(title: 'Total Organizations', value: '20'),
              FirstDashboardCard(title: 'Total Projects', value: '100'),
              FirstDashboardCard(title: 'Tests Created', value: '1000'),
            ],
          ),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
            child: Text(
              'Tool Usage Patterns',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardCard(
                title: 'Revenue',
                value: '500K',
                chart: RevenueChart(),
              ),
              DashboardCard(
                title: 'Organizations',
                value: '20',
                chart: OrganizationChart(),
              ),
              DashboardCard(
                title: 'Total Users',
                value: '1000',
                chart: TotalUsersChart(),
              ),
            ],
          ),
          SizedBox(
            height: 29,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 0, 0),
            child: Text(
              'UI tests vs API tests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TestCreationChart(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TestCreationChartYear(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TestCreationChartOrg(),
          ),
          SizedBox(
            height: 29,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 0, 0),
            child: Text(
              'OpenApi.json vs Harbinger Analyser for api testing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: HarbingerAnalyzerUsageChart(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: UsageComparisonChart(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: OrganizationUsageChart(),
          ),
           SizedBox(
            height: 29,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 0, 0),
            child: Text(
              'Project Creation based on Organisation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ProjectDistributionChart(),
                ),
              ),
               Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ProjectDistributionCharts(),
                ),
              ),
            ],
          ),
           Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: ProjectCreationChart(),
                ),

        ],
      ),
    );
  }
}

// ProjectCreationChart
// ProjectDistributionCharts
class FirstDashboardCard extends StatelessWidget {
  final String title;
  final String value;

  FirstDashboardCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget chart;

  DashboardCard(
      {required this.title, required this.value, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            chart,
          ],
        ),
      ),
    );
  }
}

class RevenueChart extends StatefulWidget {
  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: SfCartesianChart(enableAxisAnimation: true,tooltipBehavior: _tooltipBehavior,
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<SalesData, String>(
            dataSource: [
              SalesData('Jan', 100),
              SalesData('Feb', 150),
              SalesData('Mar', 200),
              SalesData('Apr', 180),
              SalesData('May', 250),
            ],
            xValueMapper: (SalesData sales, _) => sales.month,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ],
      ),
    );
  }
}

class OrganizationChart extends StatefulWidget {
  @override
  State<OrganizationChart> createState() => _OrganizationChartState();
}

class _OrganizationChartState extends State<OrganizationChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: SfCartesianChart(enableAxisAnimation: true,tooltipBehavior: _tooltipBehavior,
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<SalesData, String>(
            dataSource: [
              SalesData('Jan', 5),
              SalesData('Feb', 8),
              SalesData('Mar', 12),
              SalesData('Apr', 10),
              SalesData('May', 15),
            ],
            xValueMapper: (SalesData sales, _) => sales.month,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ],
      ),
    );
  }
}

class TotalUsersChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: SfCartesianChart(enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<SalesData, String>(
            dataSource: [
              SalesData('Jan', 200),
              SalesData('Feb', 250),
              SalesData('Mar', 300),
              SalesData('Apr', 280),
              SalesData('May', 350),
            ],
            xValueMapper: (SalesData sales, _) => sales.month,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ],
      ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}

class TestCreationChart extends StatefulWidget {
  @override
  State<TestCreationChart> createState() => _TestCreationChartState();
}

class _TestCreationChartState extends State<TestCreationChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(enableAxisAnimation: true,tooltipBehavior: _tooltipBehavior,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Month'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Tests'),
      ),
      series: <ChartSeries>[
        AreaSeries<TestData, DateTime>(
          dataSource: getTestData(),
          xValueMapper: (TestData data, _) => data.date,
          yValueMapper: (TestData data, _) => data.numOfTests,
          name: 'UI Tests',
        ),
        AreaSeries<TestData, DateTime>(
          dataSource: getTestData(),
          xValueMapper: (TestData data, _) => data.date,
          yValueMapper: (TestData data, _) => data.numOfAPITests,
          name: 'API Tests',
        ),
      ],
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Number of UI and API Tests Created Over Months'),
    );
  }

  // Replace this with your actual data retrieval logic
  List<TestData> getTestData() {
    // This is just a sample data. Replace it with your actual data.
    return [
      TestData(DateTime(2023, 1), 10, 5),
      TestData(DateTime(2023, 2), 20, 8),
      TestData(DateTime(2023, 3), 30, 12),
      // Add more data points as needed
    ];
  }
}

class TestData {
  final DateTime date;
  final int numOfTests;
  final int numOfAPITests;

  TestData(this.date, this.numOfTests, this.numOfAPITests);
}

class TestCreationChartYear extends StatefulWidget {
  @override
  State<TestCreationChartYear> createState() => _TestCreationChartYearState();
}

class _TestCreationChartYearState extends State<TestCreationChartYear> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(enableAxisAnimation: true,tooltipBehavior: _tooltipBehavior,
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: 'Year'),
        interval: 1, // Set the interval to 1 for yearly data
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Tests'),
      ),
      series: <ChartSeries>[
        AreaSeries<TestDataYear, int>(
          dataSource: getTestData(),
          xValueMapper: (TestDataYear data, _) => data.year,
          yValueMapper: (TestDataYear data, _) => data.numOfTests,
          name: 'UI Tests',
        ),
        AreaSeries<TestDataYear, int>(
          dataSource: getTestData(),
          xValueMapper: (TestDataYear data, _) => data.year,
          yValueMapper: (TestDataYear data, _) => data.numOfAPITests,
          name: 'API Tests',
        ),
      ],
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Number of UI and API Tests Created Over Year'),
    );
  }

  // Replace this with your actual data retrieval logic
  List<TestDataYear> getTestData() {
    // This is just a sample data. Replace it with your actual data.
    return [
      TestDataYear(2021, 100, 50),
      TestDataYear(2022, 150, 75),
      TestDataYear(2023, 200, 100),
      // Add more data points as needed
    ];
  }
}

class TestDataYear {
  final int year;
  final int numOfTests;
  final int numOfAPITests;

  TestDataYear(this.year, this.numOfTests, this.numOfAPITests);
}

class TestCreationChartOrg extends StatefulWidget {
  @override
  State<TestCreationChartOrg> createState() => _TestCreationChartOrgState();
}

class _TestCreationChartOrgState extends State<TestCreationChartOrg> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(tooltipBehavior: _tooltipBehavior,
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Month'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Tests'),
      ),
      series: getTestSeries(), enableAxisAnimation: true,
      legend: Legend(isVisible: true),
      title: ChartTitle(
          text:
              'Number of UI and API Tests Created Based on Organisations Over Time'),
    );
  }

  List<ChartSeries<TestData, DateTime>> getTestSeries() {
    // Replace this with your actual data retrieval logic
    List<OrganizationData> organizations = getOrganizationData();

    List<ChartSeries<TestData, DateTime>> seriesList = [];

    for (var organization in organizations) {
      seriesList.add(AreaSeries<TestData, DateTime>(
        dataSource: organization.testData,
        xValueMapper: (TestData data, _) => data.date,
        yValueMapper: (TestData data, _) => data.numOfTests,
        name: 'UI Tests - ${organization.organizationName}',
      ));

      seriesList.add(AreaSeries<TestData, DateTime>(
        dataSource: organization.testData,
        xValueMapper: (TestData data, _) => data.date,
        yValueMapper: (TestData data, _) => data.numOfAPITests,
        name: 'API Tests - ${organization.organizationName}',
      ));
    }

    return seriesList;
  }

  List<OrganizationData> getOrganizationData() {
    // This is just a sample data. Replace it with your actual data.
    return [
      OrganizationData(
        'Organization A',
        [
          TestData(DateTime(2023, 1), 10, 5),
          TestData(DateTime(2023, 2), 20, 8),
          TestData(DateTime(2023, 3), 30, 12),
          // Add more data points as needed
        ],
      ),
      OrganizationData(
        'Organization B',
        [
          TestData(DateTime(2023, 1), 15, 7),
          TestData(DateTime(2023, 2), 25, 10),
          TestData(DateTime(2023, 3), 35, 15),
          // Add more data points as needed
        ],
      ),
      // Add more organizations as needed
    ];
  }
}

class TestDataOrg {
  final DateTime date;
  final int numOfTests;
  final int numOfAPITests;

  TestDataOrg(this.date, this.numOfTests, this.numOfAPITests);
}

class OrganizationData {
  final String organizationName;
  final List<TestData> testData;

  OrganizationData(this.organizationName, this.testData);
}

class UsageComparisonChart extends StatefulWidget {
  @override
  State<UsageComparisonChart> createState() => _UsageComparisonChartState();
}

class _UsageComparisonChartState extends State<UsageComparisonChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCircularChart( enableMultiSelection: true,tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          dataSource: getChartData(),
          xValueMapper: (ChartData data, _) => data.tool,
          yValueMapper: (ChartData data, _) => data.percentage,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
      title: ChartTitle(
          text: 'Usage Comparison: openapi.json vs Harbinger Analyser'),
    );
  }

  List<ChartData> getChartData() {
    // Replace this with your actual data retrieval logic
    return [
      ChartData('openapi.json', 70),
      ChartData('Harbinger Analyser', 30),
    ];
  }
}

class ChartData {
  final String tool;
  final double percentage;

  ChartData(this.tool, this.percentage);
}


// class UsageComparisonChart extends StatefulWidget {
//   @override
//   State<UsageComparisonChart> createState() => _UsageComparisonChartState();
// }

// class _UsageComparisonChartState extends State<UsageComparisonChart> {
//   late TooltipBehavior _tooltipBehavior;

//   @override
//   void initState() {
//     _tooltipBehavior = TooltipBehavior(enable: true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SfCircularChart(
//       enableMultiSelection: true,
//       tooltipBehavior: _tooltipBehavior,
//       series: <CircularSeries>[
//         PieSeries<ChartData, String>(
//           dataSource: getChartData(),
//           xValueMapper: (ChartData data, _) => data.tool,
//           yValueMapper: (ChartData data, _) => data.percentage,
//           dataLabelSettings: DataLabelSettings(isVisible: true),
//         ),
//       ],
//       title: ChartTitle(
//           text: 'Usage Comparison: openapi.json vs Harbinger Analyser'),
//     );
//   }

//   List<ChartData> getChartData() {
//     // Replace this with your actual data retrieval logic
//     return [
//       ChartData('openapi.json', 70),
//       ChartData('Harbinger Analyser', 30),
//     ];
//   }
// }

// class ChartData {
//   final String tool;
//   final double percentage;

//   ChartData(this.tool, this.percentage);
// }


class OrganizationUsageChart extends StatefulWidget {
  @override
  State<OrganizationUsageChart> createState() => _OrganizationUsageChartState();
}

class _OrganizationUsageChartState extends State<OrganizationUsageChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(tooltipBehavior: _tooltipBehavior,
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Percentage'),
        // axisRangePadding: 10,
      ),
      series: getChartSeries(), enableAxisAnimation: true,
      title: ChartTitle(text: 'Tool Usage by Organization'),
      legend: Legend(isVisible: true), // Add this to show legend
    );
  }

  List<ChartSeries<ChartDataorg, String>> getChartSeries() {
    // Replace this with your actual data retrieval logic
    return [
      StackedColumnSeries<ChartDataorg, String>(
        dataSource: getChartDataorg(),
        xValueMapper: (ChartDataorg data, _) => data.organization,
        yValueMapper: (ChartDataorg data, _) => data.openapiPercentage,
        name: 'openapi.json',
        isVisibleInLegend: true,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
      StackedColumnSeries<ChartDataorg, String>(
        dataSource: getChartDataorg(),
        xValueMapper: (ChartDataorg data, _) => data.organization,
        yValueMapper: (ChartDataorg data, _) => data.harbingerPercentage,
        name: 'Harbinger Analyser',
        enableTooltip: true,
        isVisibleInLegend: true,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];
  }

  List<ChartDataorg> getChartDataorg() {
    // Replace this with your actual data retrieval logic
    return [
      ChartDataorg('Organization A', 60, 40),
      ChartDataorg('Organization B', 80, 20),
      ChartDataorg('Organization C', 60, 40),
   

      // Add more organizations as needed
    ];
  }
}

class ChartDataorg {
  final String organization;
  final double openapiPercentage;
  final double harbingerPercentage;

  ChartDataorg(
      this.organization, this.openapiPercentage, this.harbingerPercentage);
}









// class ComparisonChart extends StatefulWidget {
//   @override
//   _ComparisonChartState createState() => _ComparisonChartState();
// }

// class _ComparisonChartState extends State<ComparisonChart> {
//   late String selectedOrganization;
//   late List<UsageData> chartData;

//   @override
//   void initState() {
//     super.initState();
//     selectedOrganization = organizations[0];
//     chartData = getUsageData(selectedOrganization);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         DropdownButton<String>(
//           value: selectedOrganization,
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedOrganization = newValue!;
//               chartData = getUsageData(selectedOrganization);
//             });
//           },
//           items: organizations.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
//         SizedBox(height: 20),
//         Container(
//           height: 300,
//           child: SfCartesianChart(
//             primaryXAxis: NumericAxis(
//               title: AxisTitle(text: 'Usage'),
//             ),
//             primaryYAxis: CategoryAxis(
//               title: AxisTitle(text: 'Harbinger Analyzer vs OpenAPI.json'),
//             ),
//             isTransposed: true,
//             series: <BarSeries<UsageData, String>>[
//               BarSeries<UsageData, String>(
//                 dataSource: chartData,
//                 xValueMapper: (UsageData data, _) => data.usage.toString(),
//                 yValueMapper: (UsageData data, _) => data.tool,
//                 dataLabelSettings: DataLabelSettings(isVisible: true),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   List<UsageData> getUsageData(String organization) {
//     // Replace this with your actual data retrieval logic based on the organization
//     return [
//       UsageData('Harbinger Analyzer', 80),
//       UsageData('OpenAPI.json', 60),
//     ];
//   }
// }

// class UsageData {
//   final String tool;
//   final double usage;

//   UsageData(this.tool, this.usage);
// }

// List<String> organizations = [
//   'Organization 1',
//   'Organization 2',
//   'Organization 3',
//   // Add more organizations as needed
// ];



class HarbingerAnalyzerUsageChart extends StatefulWidget {
  @override
  State<HarbingerAnalyzerUsageChart> createState() => _HarbingerAnalyzerUsageChartState();
}

class _HarbingerAnalyzerUsageChartState extends State<HarbingerAnalyzerUsageChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(title: ChartTitle(text: " Harbinger Aanalyser Usage by Organisation"),
      legend: Legend(isVisible: true),
      series: <DoughnutSeries<OrganizationDatadoughnut, String>>[
        DoughnutSeries<OrganizationDatadoughnut, String>(enableTooltip: true,
          dataSource: getOrganizationData(),
          xValueMapper: (OrganizationDatadoughnut data, _) => data.organizationName,
          yValueMapper: (OrganizationDatadoughnut data, _) => data.usagePercentage,
          dataLabelMapper: (OrganizationDatadoughnut data, _) => data.organizationName,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  List<OrganizationDatadoughnut> getOrganizationData() {
    return [
      OrganizationDatadoughnut('Organization 1', 20),
      OrganizationDatadoughnut('Organization 2', 15),
      OrganizationDatadoughnut('Organization 3', 10),
      OrganizationDatadoughnut('Organization 4', 8),
      OrganizationDatadoughnut('Organization 5', 5),
      OrganizationDatadoughnut('Organization 6', 7),
      OrganizationDatadoughnut('Organization 7', 12),
      OrganizationDatadoughnut('Organization 8', 18),
      OrganizationDatadoughnut('Organization 9', 14),
      OrganizationDatadoughnut('Organization 10', 16),
      OrganizationDatadoughnut('Organization 11', 9),
      OrganizationDatadoughnut('Organization 12', 11),
      OrganizationDatadoughnut('Organization 13', 13),
      OrganizationDatadoughnut('Organization 14', 17),
      OrganizationDatadoughnut('Organization 15', 19),
      OrganizationDatadoughnut('Organization 16', 6),
      OrganizationDatadoughnut('Organization 17', 3),
      OrganizationDatadoughnut('Organization 18', 4),
      OrganizationDatadoughnut('Organization 19', 2),
      OrganizationDatadoughnut('Organization 20', 1),
    ];
  }
}

class OrganizationDatadoughnut {
  final String organizationName;
  final double usagePercentage;

  OrganizationDatadoughnut(this.organizationName, this.usagePercentage);
}








class ProjectDistributionChart extends StatefulWidget {
  @override
  State<ProjectDistributionChart> createState() =>
      _ProjectDistributionChartState();
}

class _ProjectDistributionChartState extends State<ProjectDistributionChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      enableMultiSelection: true,
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        PieSeries<OrganizationDataproject, String>(
          dataSource: getOrganizationDataproject(),
          xValueMapper: (OrganizationDataproject data, _) => data.organizationName,
          yValueMapper: (OrganizationDataproject data, _) => data.totalProjects,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
      title: ChartTitle(
          text: 'Total Number of Projects Across  Organizations'),
    );
  }

  List<OrganizationDataproject> getOrganizationDataproject() {
    // Replace this with your actual data retrieval logic
    return [
      OrganizationDataproject('Organization 1', 20),
      OrganizationDataproject('Organization 2', 15),
      OrganizationDataproject('Organization 3', 10),
      OrganizationDataproject('Organization 4', 8),
      OrganizationDataproject('Organization 5', 5),
      OrganizationDataproject('Organization 6', 7),
      OrganizationDataproject('Organization 7', 12),
      OrganizationDataproject('Organization 8', 18),
      OrganizationDataproject('Organization 9', 14),
      OrganizationDataproject('Organization 10', 16),
    ];
  }
}

class OrganizationDataproject {
  final String organizationName;
  final int totalProjects;

  OrganizationDataproject(this.organizationName, this.totalProjects);
}



class ProjectDistributionCharts extends StatefulWidget {
  @override
  State<ProjectDistributionCharts> createState() =>
      _ProjectDistributionChartsState();
}

class _ProjectDistributionChartsState
    extends State<ProjectDistributionCharts> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(isTransposed: true,
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Organizations'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Total Number of Projects'),
      ),
      series: <ChartSeries>[
        BarSeries<OrganizationDataPro, String>(
          dataSource: getOrganizationDataPro(),
          xValueMapper: (OrganizationDataPro data, _) =>
              data.organizationName,
          yValueMapper: (OrganizationDataPro data, _) =>
              data.totalProjects,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: _tooltipBehavior,
      title: ChartTitle(
          text: 'Total Number of Projects Across Organizations'),
    );
  }

  List<OrganizationDataPro> getOrganizationDataPro() {
    // Replace this with your actual data retrieval logic
    return [
      OrganizationDataPro('Organization 1', 20),
      OrganizationDataPro('Organization 2', 15),
      OrganizationDataPro('Organization 3', 10),
      OrganizationDataPro('Organization 4', 8),
      OrganizationDataPro('Organization 5', 5),
      OrganizationDataPro('Organization 6', 7),
      OrganizationDataPro('Organization 7', 12),
      OrganizationDataPro('Organization 8', 18),
      OrganizationDataPro('Organization 9', 14),
      OrganizationDataPro('Organization 10', 16),
    ];
  }
}

class OrganizationDataPro {
  final String organizationName;
  final int totalProjects;

  OrganizationDataPro(this.organizationName, this.totalProjects);
}



class ProjectCreationChart extends StatefulWidget {
  @override
  State<ProjectCreationChart> createState() => _ProjectCreationChartState();
}

class _ProjectCreationChartState extends State<ProjectCreationChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Date of Creation'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Projects'),
      ),
      series: getChartSeries(),
      tooltipBehavior: _tooltipBehavior,
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Project Creation vs Date of Creation'),
    );
  }

  List<ChartSeries<ProjectData, DateTime>> getChartSeries() {
    List<ChartSeries<ProjectData, DateTime>> seriesList = [];

    for (int i = 1; i <= 20; i++) {
      String organizationName = 'Organization $i';
      seriesList.add(StackedLineSeries<ProjectData, DateTime>(
        dataSource: getProjectData(organizationName),
        xValueMapper: (ProjectData data, _) => data.dateOfCreation,
        yValueMapper: (ProjectData data, _) => data.numberOfProjects,
        name: organizationName,
      ));
    }

    return seriesList;
  }

  List<ProjectData> getProjectData(String organizationName) {
    // Replace this with your actual data retrieval logic based on the organization
    return [
      ProjectData(DateTime(2023, 1, 1), 10),
      ProjectData(DateTime(2023, 2, 1), 15),
      ProjectData(DateTime(2023, 3, 1), 20),
      ProjectData(DateTime(2023, 4, 1), 25),
      ProjectData(DateTime(2023, 5, 1), 18),
      ProjectData(DateTime(2023, 6, 1), 22),
    ];
  }
}

class ProjectData {
  final DateTime dateOfCreation;
  final int numberOfProjects;

  ProjectData(this.dateOfCreation, this.numberOfProjects);
}