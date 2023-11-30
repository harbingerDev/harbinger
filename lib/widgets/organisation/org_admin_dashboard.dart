// imports
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:harbinger/widgets/Admin/superadmin_dashboard.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrgAdminDashboardScreen extends StatefulWidget {
  const OrgAdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OrgAdminDashboardScreen> createState() =>
      _OrgAdminDashboardScreenState();
}

class _OrgAdminDashboardScreenState extends State<OrgAdminDashboardScreen> {
  // Data for projects, team members, and performance
  // final List<Project> projects = [];
  // final List<TeamMember> teamMembers = [];
  // final PerformanceAnalytics performance = PerformanceAnalytics();

  @override
  void initState() {
    super.initState();
    // initialize data from a data source
    // for example, load from a server or local storage
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Chip(
                  elevation: 1,
                  backgroundColor: Colors.green.withOpacity(.2),
                  label: Text("Organisation Dashboard",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FirstDashboardCard(title: 'Total Projects', value: '20'),
              FirstDashboardCard(title: 'Total Api test', value: '140'),
              FirstDashboardCard(title: 'Total Ui tests', value: '100'),
              FirstDashboardCard(title: 'Total Employees', value: '1000'),
            ],
          ),
          SizedBox(height: 28),
          // Project Overview
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Project Overview',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ProjectEndDatesChart()
                    // _buildProjectsList(),
                  ],
                ),
              ),
            ),
          ),

          // Team Management
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API/UI Testing Progress',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TestingProgressChart(testingType: TestingType.ui),
                    const SizedBox(height: 8.0),

                    TestingProgressChart(
                        testingType:
                            TestingType.api) // _buildTeamMembersList(),
                  ],
                ),
              ),
            ),
          ),

          // Performance Analytics
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance Analytics',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TestsPerformedChart(),
                    Row(
                      children: [
                        Expanded(child: TestsPassedFailedChartDough()),
                         Expanded(child: TestsPassedFailedChartDough()),
                      ],
                    ),
                    TestsPassedFailedChartSla()
                    // _buildTeamMembersList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectEndDatesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true), // Add this to show legend
      enableAxisAnimation: true,
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Projects'),
      ),
      primaryYAxis: DateTimeAxis(
        title: AxisTitle(text: 'End Dates'),
        dateFormat: DateFormat.yMd(),
      ),
      series: getChartSeries(),
      title: ChartTitle(text: 'Project End Dates'),
    );
  }

  List<ChartSeries<ProjectDataEndDate, String>> getChartSeries() {
    // Replace this with your actual data retrieval logic
    return [
      BarSeries<ProjectDataEndDate, String>(
        dataSource: getProjectData(),
        xValueMapper: (ProjectDataEndDate data, _) => data.projectName,
        yValueMapper: (ProjectDataEndDate data, _) =>
            data.endDate.millisecondsSinceEpoch.toDouble(),
        name: 'End Dates',
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];
  }

  List<ProjectDataEndDate> getProjectData() {
    // Replace this with your actual data retrieval logic
    return [
      ProjectDataEndDate('Project 1', DateTime(2023, 12, 31)),
      ProjectDataEndDate('Project 2', DateTime(2023, 11, 30)),
      ProjectDataEndDate('Project 3', DateTime(2023, 10, 31)),
      ProjectDataEndDate('Project 4', DateTime(2023, 9, 30)),
      ProjectDataEndDate('Project 5', DateTime(2023, 8, 31)),
      ProjectDataEndDate('Project 6', DateTime(2023, 7, 31)),
      ProjectDataEndDate('Project 7', DateTime(2023, 6, 30)),
      ProjectDataEndDate('Project 8', DateTime(2023, 5, 31)),
      ProjectDataEndDate('Project 9', DateTime(2023, 4, 30)),
      ProjectDataEndDate('Project 10', DateTime(2023, 3, 31)),
    ];
  }
}

class ProjectDataEndDate {
  final String projectName;
  final DateTime endDate;

  ProjectDataEndDate(this.projectName, this.endDate);
}

enum TestingType { api, ui }

class TestingProgressChart extends StatefulWidget {
  final TestingType testingType;

  TestingProgressChart({required this.testingType});

  @override
  _TestingProgressChartState createState() => _TestingProgressChartState();
}

class _TestingProgressChartState extends State<TestingProgressChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true), // Add this to show legend
      enableAxisAnimation: true,
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Projects'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Tests'),
      ),
      series: getChartSeries(),
      title: ChartTitle(
          text:
              '${widget.testingType == TestingType.api ? 'API' : 'UI'} Testing Progress'),
      isTransposed: true,
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<ChartSeries<ProjectData, String>> getChartSeries() {
    return [
      StackedBarSeries<ProjectData, String>(
        dataSource: getProjectData(),
        xValueMapper: (ProjectData data, _) => data.projectName,
        yValueMapper: (ProjectData data, _) =>
            widget.testingType == TestingType.api
                ? data.apiTestingCompleted
                : data.uiTestingCompleted,
        name: 'Completed',
      ),
      StackedBarSeries<ProjectData, String>(
        dataSource: getProjectData(),
        xValueMapper: (ProjectData data, _) => data.projectName,
        yValueMapper: (ProjectData data, _) =>
            widget.testingType == TestingType.api
                ? data.apiTestingRemaining
                : data.uiTestingRemaining,
        name: 'Remaining',
      ),
    ];
  }

  List<ProjectData> getProjectData() {
    return [
      ProjectData('Project 1', 50, 30, 20, 70),
      ProjectData('Project 2', 70, 20, 10, 80),
      ProjectData('Project 3', 40, 40, 30, 60),
      ProjectData('Project 4', 60, 25, 15, 75),
      ProjectData('Project 5', 80, 15, 5, 85),
      ProjectData('Project 6', 30, 45, 25, 70),
      ProjectData('Project 7', 55, 35, 15, 65),
      ProjectData('Project 8', 65, 20, 15, 80),
      ProjectData('Project 9', 45, 30, 25, 70),
      ProjectData('Project 10', 75, 15, 10, 85),
    ];
  }
}

class ProjectData {
  final String projectName;
  final int uiTestingCompleted;
  final int apiTestingCompleted;
  final int uiTestingRemaining;
  final int apiTestingRemaining;

  ProjectData(
      this.projectName,
      this.uiTestingCompleted,
      this.apiTestingCompleted,
      this.uiTestingRemaining,
      this.apiTestingRemaining);
}

class TestsPerformedChart extends StatefulWidget {
  @override
  State<TestsPerformedChart> createState() => _TestsPerformedChartState();
}

class _TestsPerformedChartState extends State<TestsPerformedChart> {
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
        title: AxisTitle(text: 'Date'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Tests Performed'),
      ),
      series: getChartSeries(),
      tooltipBehavior: _tooltipBehavior,
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Tests Performed vs Date based on Projects'),
    );
  }

  List<ChartSeries<TestData, DateTime>> getChartSeries() {
    List<ChartSeries<TestData, DateTime>> seriesList = [];

    for (int i = 1; i <= 10; i++) {
      String projectName = 'Project $i';
      seriesList.add(StackedLineSeries<TestData, DateTime>(
        dataSource: getTestData(projectName),
        xValueMapper: (TestData data, _) => data.date,
        yValueMapper: (TestData data, _) => data.testsPerformed,
        name: projectName,
      ));
    }

    return seriesList;
  }

  List<TestData> getTestData(String projectName) {
    // Replace this with your actual data retrieval logic based on the project
    return [
      TestData(DateTime(2023, 1, 1), 50),
      TestData(DateTime(2023, 2, 1), 75),
      TestData(DateTime(2023, 3, 1), 100),
      TestData(DateTime(2023, 4, 1), 120),
      TestData(DateTime(2023, 5, 1), 90),
      TestData(DateTime(2023, 6, 1), 110),
    ];
  }
}

class TestData {
  final DateTime date;
  final int testsPerformed;

  TestData(this.date, this.testsPerformed);
}



class TestsPassedFailedChart extends StatefulWidget {
  @override
  State<TestsPassedFailedChart> createState() => _TestsPassedFailedChartState();
}

class _TestsPassedFailedChartState extends State<TestsPassedFailedChart> {
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
        title: AxisTitle(text: 'Date'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Tests'),
      ),
      series: getChartSeries(),
      tooltipBehavior: _tooltipBehavior,
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Tests Passed and Failed based on Date'),
    );
  }

  List<ChartSeries<TestDataPassFail, DateTime>> getChartSeries() {
    return [
      StackedLineSeries<TestDataPassFail, DateTime>(
        dataSource: getTestDataPassFail('Passed'),
        xValueMapper: (TestDataPassFail data, _) => data.date,
        yValueMapper: (TestDataPassFail data, _) => data.testsCount,
        name: 'Passed',
      ),
      StackedLineSeries<TestDataPassFail, DateTime>(
        dataSource: getTestDataPassFail('Failed'),
        xValueMapper: (TestDataPassFail data, _) => data.date,
        yValueMapper: (TestDataPassFail data, _) => data.testsCount,
        name: 'Failed',
      ),
    ];
  }

  List<TestDataPassFail> getTestDataPassFail(String testResult) {
    // Replace this with your actual data retrieval logic based on the test result
    return [
      TestDataPassFail(DateTime(2023, 1, 1), 50, testResult),
      TestDataPassFail(DateTime(2023, 2, 1), 30, testResult),
      TestDataPassFail(DateTime(2023, 3, 1), 20, testResult),
      TestDataPassFail(DateTime(2023, 4, 1), 40, testResult),
      TestDataPassFail(DateTime(2023, 5, 1), 25, testResult),
      TestDataPassFail(DateTime(2023, 6, 1), 35, testResult),
    ];
  }
}

class TestDataPassFail {
  final DateTime date;
  final int testsCount;
  final String testResult;

  TestDataPassFail(this.date, this.testsCount, this.testResult);
}




class TestsPassedFailedChartDough extends StatefulWidget {
  @override
  State<TestsPassedFailedChartDough> createState() => _TestsPassedFailedChartDoughState();
}

class _TestsPassedFailedChartDoughState extends State<TestsPassedFailedChartDough> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: getChartSeries(),
      tooltipBehavior: _tooltipBehavior,
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Tests Passed and Failed'),
    );
  }

  List<DoughnutSeries<TestResultData, String>> getChartSeries() {
    List<DoughnutSeries<TestResultData, String>> seriesList = [];

    for (int i = 1; i <= 10; i++) {
      String projectName = 'Project $i';
      seriesList.add(DoughnutSeries<TestResultData, String>(
        dataSource: getTestResultData(projectName),
        xValueMapper: (TestResultData data, _) => data.result,
        yValueMapper: (TestResultData data, _) => data.count,
        name: projectName,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ));
    }

    return seriesList;
  }

  List<TestResultData> getTestResultData(String projectName) {
    // Replace this with your actual data retrieval logic based on the project
    return [
      TestResultData('Passed', 80),
      TestResultData('Failed', 20),
    ];
  }
}

class TestResultData {
  final String result;
  final int count;

  TestResultData(this.result, this.count);
}






class TestsPassedFailedChartSla extends StatefulWidget {
  @override
  State<TestsPassedFailedChartSla> createState() => _TestsPassedFailedChartSlaState();
}

class _TestsPassedFailedChartSlaState extends State<TestsPassedFailedChartSla> {
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
        title: AxisTitle(text: 'Date'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Number of Tests'),
      ),
      series: getChartSeries(),
      tooltipBehavior: _tooltipBehavior,
      legend: Legend(isVisible: true),
      title: ChartTitle(text: 'Tests Passed and Failed vs Date for Different Projects'),
    );
  }

  List<ChartSeries<TestDataSlack, DateTime>> getChartSeries() {
    List<ChartSeries<TestDataSlack, DateTime>> seriesList = [];

    for (int i = 1; i <= 10; i++) {
      String projectName = 'Project $i';
      seriesList.add(StackedLineSeries<TestDataSlack, DateTime>(
        dataSource: getTestData(projectName),
        xValueMapper: (TestDataSlack data, _) => data.date,
        yValueMapper: (TestDataSlack data, _) => data.testsPassed,
        name: '$projectName - Passed',
      ));

      seriesList.add(StackedLineSeries<TestDataSlack, DateTime>(
        dataSource: getTestData(projectName),
        xValueMapper: (TestDataSlack data, _) => data.date,
        yValueMapper: (TestDataSlack data, _) => data.testsFailed,
        name: '$projectName - Failed',
      ));
    }

    return seriesList;
  }

  List<TestDataSlack> getTestData(String projectName) {
    // Replace this with your actual data retrieval logic based on the project
    return [
      TestDataSlack(DateTime(2023, 1, 1), 30, 20),
      TestDataSlack(DateTime(2023, 2, 1), 45, 30),
      TestDataSlack(DateTime(2023, 3, 1), 60, 40),
      TestDataSlack(DateTime(2023, 4, 1), 80, 40),
      TestDataSlack(DateTime(2023, 5, 1), 50, 40),
      TestDataSlack(DateTime(2023, 6, 1), 70, 40),
    ];
  }
}

class TestDataSlack {
  final DateTime date;
  final int testsPassed;
  final int testsFailed;

  TestDataSlack(this.date, this.testsPassed, this.testsFailed);
}