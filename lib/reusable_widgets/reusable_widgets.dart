import 'package:flutter/material.dart';

class ReusableWidgets {
  //a textform field
  Widget textFormField(
    int length, {
    onTap,
    required TextEditingController controller,
    required bool readOnly,
    required String label,
    required TextInputType keyboard,
    required TextInputAction action,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
        hintText: label,
      ),
      controller: controller,
      textInputAction: action,
      readOnly: readOnly,
      maxLength: length,
      onTap: onTap,
      validator: (value) {
        if (value.toString().isEmpty || value == null) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  //SnackBar
  ScaffoldMessengerState snackBar(String text, BuildContext context) {
    return ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}
