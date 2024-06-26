import 'package:flutter/material.dart';

class SentinelTextfield extends StatelessWidget {

  final String hintText;
  final bool obscureText;
  final IconData icon;
  final controller;
  final Function()? onTap;
  final Function()? onEditingCompleted;
  final bool? readOnly;
  final Widget? suffixButton;

  const SentinelTextfield({
    super.key,

    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.controller,
    this.onTap,
    this.readOnly,
    this.suffixButton,
    this.onEditingCompleted
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        obscureText: obscureText,
        onTap: onTap,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black,),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.black, width: 1)
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.lightBlue, width: 2),
            ),
            suffixIcon: suffixButton,
            fillColor: Colors.blueGrey[50],
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])
        ),

      ),
    );
  }
}