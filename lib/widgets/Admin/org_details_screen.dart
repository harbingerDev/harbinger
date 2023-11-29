// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:accordion/accordion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/assets/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:harbinger/models/organisation.dart';
import 'package:harbinger/models/organisation_remodel.dart';

class SuperAdminOrganisationDetails extends StatefulWidget {
  final Organisation organisation;

  const SuperAdminOrganisationDetails({Key? key, required this.organisation})
      : super(key: key);

  @override
  State<SuperAdminOrganisationDetails> createState() =>
      _SuperAdminOrganisationDetailsState();
}

class _SuperAdminOrganisationDetailsState
    extends State<SuperAdminOrganisationDetails> {
  late Future<Organisationremodel> _organisationFuture;

  @override
  void initState() {
    super.initState();
    _organisationFuture = _fetchOrganisationData();
  }

  Future<Organisationremodel> _fetchOrganisationData() async {
    try {
      final organisationData =
          await getOrganisationWithRelations(widget.organisation.orgId!);
      print("organisationData$organisationData");
      return organisationData;
    } catch (error) {
      print('Error fetching data: $error');
      rethrow;
    }
  }

  Future<Organisationremodel> getOrganisationWithRelations(int orgId) async {
    final Uri url = Uri.parse(
        "${AppConfig.BASE_URL2}/organisation/withorgadminprojectadminprojectmember/$orgId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(
          'Received data from API+++++++++++++++++++++++++++++++++++++++++++: $jsonData'); // Add this line to print the received data
      return Organisationremodel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load organisation data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<Organisationremodel>(
          future: _organisationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while fetching data
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle error state
              return Text('Error: ${snapshot.error}');
            } else {
              final org = snapshot.data!;
              return SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .89,
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Transform(
                                      transform: Matrix4.identity()..scale(0.8),
                                      child: Chip(
                                        elevation: 1,
                                        label: Text(
                                          org.status == "active"
                                              ? "Active"
                                              : "Inactive",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.roboto(
                                            color: Colors.black87,
                                            fontSize: 15,
                                          ),
                                        ),
                                        backgroundColor: org.status == "active"
                                            ? Colors.green.withOpacity(.2)
                                            : Colors.black87.withOpacity(.2),
                                      ),
                                    ),
                                  ]),
                              Row(
                                children: [
                                  Text(
                                    "Organisation Name:   ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${org.orgName}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    "Organisation Code:   ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${org.orgCode}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    "Organisation Description:  ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${org.orgDesc}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    "Organisation Start Date:  ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${org.orgStartDate}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    "Organisation End Date:   ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${org.orgEndDate}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(Icons.edit),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .89,
                      child: Card(
                        borderOnForeground: true,
                        color: Colors.white,
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Organisation Admin',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.add),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: org.orgAdmins.map((member) {
                                  return Row(
                                    children: [
                                      Text(member.orgAdminId.toString() ??
                                          'N/A'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(member.emailId ?? 'N/A'),
                                    ],
                                  );
                                }).toList(),
                              ),
                              Accordion(
                                contentBorderColor: Color(0xFFE8E8E8),
                                headerBorderColor: Color(0xFFE8E8E8),
                                rightIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                children: [
                                  AccordionSection(
                                    headerBackgroundColor: Color(0xFFE8E8E8),
                                    header: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text("Accept Requests"),
                                    ),
                                    isOpen: false,
                                    content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("user1@gmail.com"),
                                          Text("user2@gmail.com"),
                                          Text("user3@gmail.com")
                                        ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .89,
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Project Admin',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.add),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // Display project members here
                                children: org.projectAdmins.map((member) {
                                  return Row(
                                    children: [
                                      Text(member.projectAdminId.toString() ??
                                          'N/A'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(member.emailId ?? 'N/A'),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .89,
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Project Members',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.add),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // Display project members here
                                children: org.projectMembers.map((member) {
                                  return Row(
                                    children: [
                                      Text(member.projectMemberId.toString() ??
                                          'N/A'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(member.emailId ?? 'N/A'),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }
          }),
    );
  }
}
