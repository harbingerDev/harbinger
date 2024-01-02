// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class JenkinsJobsScreen extends StatefulWidget {
  @override
  _JenkinsJobsScreenState createState() => _JenkinsJobsScreenState();
}

class _JenkinsJobsScreenState extends State<JenkinsJobsScreen> {
  List<dynamic> jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  _fetchJobs() async {
    String username = 'admin';
    String apiToken = '11d8fe2988c83f162f11d5586aa3337526';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$apiToken'));

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/json'),
      headers: <String, String>{'authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      setState(() {
        jobs = jsonDecode(response.body)['jobs'];
      });
    } else {
      Fluttertoast.showToast(msg: 'Failed to load Jenkins jobs.');
    }
  }

  _createJob(String jobName) async {
    String username = 'admin';
    String apiToken = '11d8fe2988c83f162f11d5586aa3337526';

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$apiToken'));

    String configXml = """
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps">
    <script>
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'gitCredentials', url: 'git@github.com:codetesta2z/kilimanjaro.git']])
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }
        
        stage('Execute') {
            steps {
                script {
                    sh 'npx playwright test --headed --project=chromium'
                }
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'playwright-report/*', allowEmptyArchive: true
        }
    }
}
    </script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
""";

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/createItem?name=$jobName'),
      headers: <String, String>{
        'authorization': basicAuth,
        'Content-Type': 'application/xml',
      },
      body: configXml,
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Pipeline job created successfully');
    } else {
      Fluttertoast.showToast(msg: 'Failed to create Jenkins job.');
    }
  }

  Future<String?> _showJobNameDialog() async {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Job Name'),
          content: TextField(
            controller: _controller,
            decoration:
                InputDecoration(hintText: "Enter the name for the new job"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _triggerBuild(String jobName) async {
    String username = 'admin';
    String apiToken = '119dd70df35908d1eb482509c47c52023e';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$apiToken'));

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/job/$jobName/build'),
      headers: <String, String>{
        'authorization': basicAuth,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Build triggered for $jobName');
    } else {
      Fluttertoast.showToast(msg: 'Failed to trigger build for $jobName');
    }
  }

  Future<List<String>> _fetchJobDetails(String jobName) async {
    String username = 'admin';
    String apiToken = '119dd70df35908d1eb482509c47c52023e';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$apiToken'));

    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/job/$jobName/api/json?tree=builds[result]{0,5}'),
      headers: <String, String>{
        'authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      var jobDetails = json.decode(response.body);
      return jobDetails['builds']
          .map<String>((build) => build['result'].toString())
          .toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            return FutureBuilder<List<String>>(
              future: _fetchJobDetails(jobs[index]['name']),
              builder: (context, snapshot) {
                List<Widget> indicators = [];

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  for (var result in snapshot.data!) {
                    Color color;
                    switch (result) {
                      case 'SUCCESS':
                        color = Colors.green;
                        break;
                      case 'FAILURE':
                        color = Colors.red;
                        break;
                      case 'UNSTABLE':
                        color = Colors.yellow;
                        break;
                      default:
                        color = Colors.grey;
                    }
                    indicators.add(Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(backgroundColor: color, radius: 5),
                    ));
                  }
                } else if (snapshot.hasError) {
                  print(
                      "Error fetching job details for ${jobs[index]['name']}: ${snapshot.error}");
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 4, color: Color(0xffE95622)),
                      ),
                    ),
                    child: ListTile(
                      title: Text(jobs[index]['name']),
                      trailing: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 4, color: Color(0xffE95622)),
                    ),
                  ),
                  child: ListTile(
                    title: Text(jobs[index]['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...indicators,
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _triggerBuild(jobs[index]['name']);
                          },
                          child: Text('Build'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final jobName = await _showJobNameDialog();
          if (jobName != null && jobName.isNotEmpty) {
            _createJob(jobName);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Create Jenkins Job',
      ),
    );
  }
}
