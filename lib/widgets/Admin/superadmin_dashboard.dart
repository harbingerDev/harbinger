import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SuperadminDashboardOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

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

class RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: SfCartesianChart(
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

class OrganizationChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: SfCartesianChart(
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
      child: SfCartesianChart(
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
