import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(CameraApp());

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraHomePage(),
    );
  }
}

class CameraHomePage extends StatefulWidget {
  @override
  _CameraHomePageState createState() => _CameraHomePageState();
}

class _CameraHomePageState extends State<CameraHomePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File savedImage = await _saveImagePermanently(File(image.path));
      setState(() {
        _image = savedImage;
      });
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File savedImage = await _saveImagePermanently(File(image.path));
      setState(() {
        _image = savedImage;
      });
    }
  }

  // Save image permanently to app directory
  Future<File> _saveImagePermanently(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = image.path.split('/').last;
    final newImage = await image.copy('${directory.path}/$name');
    return newImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera & Gallery App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 300),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImageFromCamera,
              icon: Icon(Icons.camera_alt),
              label: Text('Take Photo'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: Icon(Icons.photo_library),
              label: Text('Pick from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}