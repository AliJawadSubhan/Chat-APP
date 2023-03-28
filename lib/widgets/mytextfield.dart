import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField(
      {super.key,
      required this.fieldColor,
      required this.borderColor,
      required this.function});

  final TextEditingController _controller = TextEditingController();
  final Color fieldColor;
  final Color borderColor;
  final Function(String value) function;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: fieldColor),
        prefixIcon: Icon(Icons.person, color: fieldColor),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(30.0),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
      ),
      onChanged: function,
    );
  }
}
