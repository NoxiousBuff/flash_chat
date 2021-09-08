import 'package:flutter/material.dart';

class TextFieldBar extends StatelessWidget {
  final String fieldText;
  final Function onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final EdgeInsetsGeometry margin;
  final TextEditingController controller;

  TextFieldBar({
    this.fieldText,
    this.onChanged,
    this.keyboardType,
    this.obscureText,
    this.margin,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          EdgeInsets.only(left: 25.0, top: 10.0, right: 25.0, bottom: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(style: BorderStyle.solid),
            ),
            hintText: fieldText,
            isDense: true,
            contentPadding: EdgeInsets.all(13.0)),
        onChanged: onChanged,
      ),
    );
  }
}
