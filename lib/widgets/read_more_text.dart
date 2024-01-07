import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String longText;
  final int maxLines;

  ReadMoreText({required this.longText, required this.maxLines});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        Text(
          widget.longText,
          maxLines: isExpanded ? null : widget.maxLines
        ),
        const SizedBox(height: 10.0),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'See Less' : 'See More',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}