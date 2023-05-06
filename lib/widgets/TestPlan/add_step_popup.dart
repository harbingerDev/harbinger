import 'package:flutter/material.dart';
import '../../models/form_data.dart';

class AddStepPopup extends StatefulWidget {
  @override
  _AddStepPopupState createState() => _AddStepPopupState();
}

class _AddStepPopupState extends State<AddStepPopup> {
  List<FormData> currentFormData = actionFormData;
  Map<String, dynamic> formValues = {};

  void _updateFormData(List<FormData> formData) {
    setState(() {
      currentFormData = formData;
    });
  }

  void _showForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...currentFormData
                  .map((field) => _buildFormField(field))
                  .toList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print(formValues);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField(FormData field) {
    switch (field.type) {
      case 'text':
        return TextFormField(
          decoration: InputDecoration(labelText: field.name),
          initialValue: field.defaultValue,
          onChanged: (value) {
            formValues[field.name] = value;
          },
        );
      case 'list':
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: field.name),
          value: field.defaultValue,
          items: field.values!.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            formValues[field.name] = value;
          },
        );
      case 'checkbox':
        return CheckboxListTile(
          title: Text(field.name),
          value: formValues[field.name] ?? false,
          onChanged: (bool? value) {
            setState(() {
              formValues[field.name] = value;
            });
          },
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Popup'),
        actions: [
          TextButton(
            onPressed: () {
              _updateFormData(actionFormData);
              _showForm();
            },
            child: Text(
              'Action',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              _updateFormData(verificationFormData);
              _showForm();
            },
            child: Text(
              'Verification',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
