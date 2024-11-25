import 'dart:io';

import 'package:flutter/material.dart';

class ImageDisplayWidget extends StatelessWidget {
  final String imagePath;

  ImageDisplayWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Image.file(File(imagePath)),
    );
  }
}
