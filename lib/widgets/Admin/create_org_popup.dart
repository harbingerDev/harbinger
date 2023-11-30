import 'package:flutter/material.dart';
import 'package:harbinger/assets/config.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateOrganisationPopup extends StatefulWidget {
  final VoidCallback? callback;
  const CreateOrganisationPopup({super.key, this.callback});

  @override
  State<CreateOrganisationPopup> createState() =>
      _CreateOrganisationPopupState();
}

class _CreateOrganisationPopupState extends State<CreateOrganisationPopup> {
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _orgCodeController = TextEditingController();
  final TextEditingController _orgDescController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();
  final TextEditingController _updatedByController = TextEditingController();
  DateTime? _createdOnController =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? _updatedOnController =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> createOrganisation(
      BuildContext context, Map<String, dynamic> newOrg) async {
    final Uri url = Uri.parse("${AppConfig.BASE_URL2}/organisation/create/");
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(newOrg),
    );

    print("API Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to create a new organization');
    }
  }

  Future<void> createOrganisations() async {
    final newOrg = {
      "org_name": _orgNameController.text,
      "org_code": _orgCodeController.text,
      "org_desc": _orgDescController.text,
      "org_start_date": _startDate?.toIso8601String(),
      "org_end_date": _endDate?.toIso8601String(),
      "created_by": _createdByController.text,
      "updated_by": _updatedByController.text,
      "created_on": _createdOnController?.toIso8601String(),
      "updated_on": _updatedOnController?.toIso8601String(),
    };

    try {
      await createOrganisation(context, newOrg);
      widget.callback?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Organization created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create organization: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? selectedDate,
      bool isStartDate, bool isCreatedOn) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else if (isCreatedOn) {
          _createdOnController = pickedDate;
        } else {
          _updatedOnController = pickedDate;
          _endDate = pickedDate;
        }
      });
    }
  }

  Widget _buildDateSelector({
    required String labelText,
    DateTime? date,
    void Function()? onTapStartDate,
    void Function()? onTapEndDate,
    void Function()? onTapCreatedOn,
    void Function()? onTapUpdatedOn,
    required bool isStartDate,
    required bool isCreatedOn,
    required bool isUpdatedOn,
  }) {
    return InkWell(
      onTap: isStartDate
          ? onTapStartDate
          : (isCreatedOn
              ? onTapCreatedOn
              : (isUpdatedOn ? onTapUpdatedOn : onTapEndDate)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8.0),
            Text(
              date != null ? DateFormat('yyyy-MM-dd').format(date) : labelText,
              style: TextStyle(
                fontSize: 16,
                color: date != null ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        'Create Organisation',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width * .7,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Enter the organisation details here: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                ),
              ],
            ),
            new Divider(
              color: Color(0xffE95622),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  TextField(
                    controller: _orgNameController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _orgCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Code',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _orgDescController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Description',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _updatedByController,
                    decoration: const InputDecoration(
                      labelText: 'Updated by',
                    ),
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: _createdByController,
                    decoration: const InputDecoration(
                      labelText: 'Created by',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Start Date: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: _buildDateSelector(
                          labelText: 'Start Date',
                          date: _startDate,
                          onTapStartDate: () =>
                              _selectDate(context, _startDate, true, false),
                          isStartDate: true,
                          isCreatedOn: false,
                          isUpdatedOn: false,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "End Date: ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: _buildDateSelector(
                          labelText: 'End Date',
                          date: _endDate,
                          onTapEndDate: () =>
                              _selectDate(context, _endDate, false, false),
                          isStartDate: false,
                          isCreatedOn: false,
                          isUpdatedOn: false,
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Created On: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: _buildDateSelector(
                          labelText: 'Created On',
                          date: _createdOnController,
                          onTapCreatedOn: () => _selectDate(
                              context, _createdOnController, false, true),
                          isStartDate: false,
                          isCreatedOn: true,
                          isUpdatedOn: false,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Updated On: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Expanded(
                        child: _buildDateSelector(
                          labelText: 'Updated On',
                          date: _updatedOnController,
                          onTapUpdatedOn: () => _selectDate(
                              context, _updatedOnController, false, false),
                          isStartDate: false,
                          isCreatedOn: false,
                          isUpdatedOn: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              )),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                selectionColor: const Color.fromARGB(255, 204, 204, 204),
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                                Navigator.of(context).pop();

                createOrganisations();
              },
              label: Text('Create '),
              icon: Icon(Icons.add),
            )
          ],
        )
      ],
    );
  }
}
