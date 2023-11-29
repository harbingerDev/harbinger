import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/assets/config.dart';
import 'package:harbinger/models/organisation.dart';
import 'package:http/http.dart' as http;
 
class OrganisationCard extends StatelessWidget {
  OrganisationCard({
    Key? key,
    required this.organisations,
    required this.activateOrganisation,
    required this.sendToOrganisationDetails,
  }) : super(key: key);
 
  final Organisation organisations;
  final Function(int) activateOrganisation;
  final Function(Organisation,String) sendToOrganisationDetails;
 
 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        sendToOrganisationDetails(organisations,"org_details_screen");
 
 
        // showDialog(
        //   context: context,
        //   builder: (context) => NextScreen(
        //     orgId: organisations.orgId!,
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide.none,
              top: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(
                color: Color(0xffE95622),
                style: BorderStyle.solid,
                width: 4,
              ),
            ),
            color: Colors.white.withOpacity(.3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform(
                      transform: Matrix4.identity()..scale(0.8),
                      child: Chip(
                        elevation: 1,
                        label: Text(
                          organisations.status == "active"
                              ? "Active"
                              : "Inactive",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        backgroundColor:
                            organisations.status == "active" ? Colors.green.withOpacity(.2) : Colors.black87.withOpacity(.2),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  organisations.orgName!,
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white.withOpacity(.2),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Description: ",
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  organisations.orgDesc!,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Start Date: ",
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${organisations.orgStartDate}",
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "End Date: ",
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${organisations.orgEndDate}",
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                          child: Row(
                            children: [
                              Text(
                                "Status: ",
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                organisations.status!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Created By: ",
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                organisations.createdBy!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Transform(
                            transform: Matrix4.identity()..scale(0.8),
                            child: InkWell(
                              onTap: () async {
                                bool success = await changeOrganisationStatus(organisations.orgId!);
 
                                if (success) {
                                  // If the API call is successful, update the UI
                                  activateOrganisation(organisations.orgId!);
                                } else {
                                  // Handle error scenario, show a snackbar or other UI feedback
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Failed to change organisation status"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Chip(
                                elevation: 1,
                                label: Text(
                                  "Set organisation ${organisations.status == 'active' ? 'inactive' : 'active'}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                backgroundColor: Colors.black87.withOpacity(.2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 
  Future<bool> changeOrganisationStatus(int orgId) async {
    try {
      final baseUrl = AppConfig.BASE_URL2;
      final url = Uri.parse('$baseUrl/organisation/status/$orgId');
      final response = await http.patch(url);
 
      if (response.statusCode == 200) {
        print('Organisation $orgId status changed successfully');
        return true;
      } else {
        print('Failed to change organisation $orgId status: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
