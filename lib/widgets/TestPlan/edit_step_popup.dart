import 'package:flutter/material.dart';

import '../../assets/constants.dart';

Widget showEditForm(BuildContext context, List<String> allFields) {
  return AlertDialog(
    title: Text('Edit step'),
    content: Container(
      height: MediaQuery.of(context).size.height * .5,
      width: MediaQuery.of(context).size.width * .7,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: allFields.length,
        itemBuilder: (BuildContext context, int index) {
          String field = allFields[index];
          if (["const", "let"].contains(field)) {
            return ListTile(
              title: DropdownButton<String>(
                value: field,
                onChanged: (String? newValue) {},
                items: ["const", "let"].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            );
          } else if (availableLocatorStrategies.contains(field)) {
            return ListTile(
              title: DropdownButton<String>(
                value: field,
                onChanged: (String? newValue) {},
                items: availableLocatorStrategies.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            );
          } else if (availableActions.contains(field)) {
            return ListTile(
              title: DropdownButton<String>(
                value: field,
                onChanged: (String? newValue) {},
                items: availableActions.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            );
          } else {
            return ListTile(
              title: TextFormField(
                initialValue: field,
                decoration: InputDecoration(
                  labelText: 'Field',
                ),
              ),
            );
          }
        },
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text('Save'),
        onPressed: () {
          //make the api call to save the edited content
          // Save the form data here
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
