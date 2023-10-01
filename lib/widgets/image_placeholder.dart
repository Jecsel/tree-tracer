import 'package:flutter/material.dart';

class ImagePlaceholder extends StatefulWidget {
  final String imageUrl;
  final String placeholderAsset;

  ImagePlaceholder({required this.imageUrl, required this.placeholderAsset});

  @override
  _ImagePlaceholderState createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_loading)
          Image.asset(
            widget.placeholderAsset,
            fit: BoxFit.cover,
            width: 200, // Adjust the width and height as needed
            height: 200,
          ),
        FadeInImage(
          placeholder: AssetImage(widget.placeholderAsset),
          image: NetworkImage(widget.imageUrl),
          fit: BoxFit.cover,
          width: 200, // Adjust the width and height as needed
          height: 200,
          imageErrorBuilder: (context, error, stackTrace) {
            setState(() {
              _loading = false;
            });
            return Image.asset(
              widget.placeholderAsset,
              fit: BoxFit.cover,
              width: 200, // Adjust the width and height as needed
              height: 200,
            );
          },
          // Other image properties like width, height, fit, etc.
        ),
      ],
    );
  }
}