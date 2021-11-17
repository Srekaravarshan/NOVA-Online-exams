import 'package:flutter/material.dart';

Widget textField(
    {String hintText = '',
    TextInputType keyboardType = TextInputType.name,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    bool autofocus = false}) {
  return TextFormField(
    keyboardType: keyboardType,
    decoration:
        InputDecoration(border: const OutlineInputBorder(), hintText: hintText),
    onChanged: onChanged,
    validator: validator,
    autofocus: autofocus,
  );
}
