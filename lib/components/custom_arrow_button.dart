import 'package:flutter/material.dart';

class CustomArrowButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  CustomArrowButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
