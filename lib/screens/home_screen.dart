import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import '../widgets/image_display_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image;
  List<String> _labels = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _labels = [];
    });

    if (image != null) {
      await _labelImage(File(image.path));
    }
  }

  Future<void> _labelImage(File imageFile) async {
    final visionImage = FirebaseVisionImage.fromFile(imageFile);
    final labeler = FirebaseVision.instance.imageLabeler();
    final labels = await labeler.processImage(visionImage);

    setState(() {
      _labels = labels.map((label) => '${label.text} (${label.confidence.toStringAsFixed(2)})').toList();
    });

    labeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Labeling App')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
          if (_image != null)
            ImageDisplayWidget(imagePath: _image!.path),
          if (_labels.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _labels.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_labels[index]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
