// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:harbinger/assets/config.dart';
import 'package:harbinger/widgets/Admin/create_org_popup.dart';
import 'package:harbinger/widgets/Admin/org_details_screen.dart';
import 'package:harbinger/widgets/Admin/organisation_card.dart';
import 'package:harbinger/widgets/Common/loader_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../assets/constants.dart';
import '../../models/organisation.dart';

class SuperAdminAdminstrate extends StatefulWidget {
  const SuperAdminAdminstrate({Key? key}) : super(key: key);

  @override
  State<SuperAdminAdminstrate> createState() => _SuperAdminAdminstrateState();
}

class _SuperAdminAdminstrateState extends State<SuperAdminAdminstrate> {
  List<Organisation> filteredOrganisationDataList = [];
  String displayScreen = "org_home_screen";
  Organisation currentOrganisation = Organisation();

  var gitVersion;
  List<Organisation> organisationDataList = [];
  List<Organisation> orginalOrganisationDataList = [];

  bool doOrganisationsExist = false;
  bool loaded = false;
  final baseurl = AppConfig.BASE_URL2;

  void activateOrganisationCallback(int orgId) {
    print("############inside active callback    id->$orgId");
    activateOrganisation(orgId);
  }

  void sendToOrganisationDetailsCallback(Organisation org, String screen) {
    setState(() {
      displayScreen = screen;
      currentOrganisation = org;
    });
  }

  Future<void> activateOrganisation(int orgId) async {
    setState(() {});
    print('Organisation $orgId has been activated');
    await _getData();
    setState(() {});
  }

  Future<void> _getData() async {
    organisationDataList = [];

    var organisationsUrl = Uri.parse("${baseurl}/organisation/");

    var gitUrl = Uri.parse("http://127.0.0.1:1337/system/checkGitVersion");

    final responses = await Future.wait([
      http.get(organisationsUrl),
      http.get(gitUrl),
    ]);
    if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('organisationsObject', responses[0].body);

      setState(() {
        if (responses[0].body.isEmpty) {
          loaded = true;
        } else {
          (jsonDecode(responses[0].body)).forEach((element) {
            organisationDataList.add(Organisation.fromJson(element));
          });
          setState(() {
            orginalOrganisationDataList = organisationDataList;
          });

          gitVersion = json.decode(responses[1].body)["gitVersion"];
          loaded = true;
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onClickDone(Map<String, dynamic> organisationObject) async {
    await _postAndGetOrganisation(organisationObject);
  }

  Future<void> _postAndGetOrganisation(
      Map<String, dynamic> organisationObject) async {
    setState(() {
      loaded = false;
    });
    final headers = {'Content-Type': 'application/json'};
    var organisationCreationUrl = Uri.parse("$baseurl/organisation/create");
    var organisationsUrl = Uri.parse("$baseurl/organisations/");
    final creationResponse = await Future.wait([
      http.post(
        organisationCreationUrl,
        body: json.encode(organisationObject),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      )
    ]);

    await _getData();
    setState(() {
      loaded = true;
    });
  }

  TextEditingController _searchController = TextEditingController();
  void filterOrganisations(String query) {
    setState(() {
      if (query == " " || query.trim() == "") {
        organisationDataList = orginalOrganisationDataList;
        return;
      }
      filteredOrganisationDataList = organisationDataList
          .where((organisation) =>
              organisation.orgName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      organisationDataList = filteredOrganisationDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !loaded
        ? LoaderWidget()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 28, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          displayScreen = "org_home_screen";
                        });
                        print(displayScreen);
                      },
                      child: Chip(
                        elevation: 1,
                        backgroundColor: Colors.green.withOpacity(.2),
                        label: Row(
                          children: [
                            displayScreen != "org_home_screen"
                                ? Icon(size: 20, Icons.arrow_back_ios)
                                : Text(""),
                            Text(
                              "Organisations",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        
                    SizedBox(
                      width: 10,
                    ),
                    // Search Organisation



                  displayScreen == "org_home_screen"?  Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          filterOrganisations(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Organisation',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ):

                     Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Organisation Details',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

                    SizedBox(
                      width: 10,
                    ),
               displayScreen == "org_home_screen"?     ElevatedButton.icon(
                      onPressed: () {
                        _showCreateOrganisationDialog(context);
                      },
                      label: Text('Create Organization'),
                      icon: Icon(Icons.add),
                    ):Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 1,
              ),
              displayScreen == "org_home_screen"
                  ? organisationDataList.length > 0
                      ? Expanded(
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.8,
                              crossAxisCount: MediaQuery.of(context)
                                          .size
                                          .width >
                                      1400
                                  ? 5
                                  : MediaQuery.of(context).size.width > 1100
                                      ? 4
                                      : MediaQuery.of(context).size.width > 1000
                                          ? 3
                                          : 2,
                              crossAxisSpacing: 4,
                            ),
                            children: organisationDataList.map((e) {
                              return OrganisationCard(
                                  organisations: e,
                                  activateOrganisation:
                                      activateOrganisationCallback,
                                  sendToOrganisationDetails:
                                      sendToOrganisationDetailsCallback);
                            }).toList(),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Lottie.asset('assets/images/noProjectFound.json',
                                width: 100, height: 100),
                            Text("No organisations found.",
                                style: textStyle16WithoutBold),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        )
                  : Expanded(
                    child: SuperAdminOrganisationDetails(
                        organisation: currentOrganisation),
                  ),
            ],
          );
  }

  void _showCreateOrganisationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateOrganisationPopup();
      },
    );
  }
}
