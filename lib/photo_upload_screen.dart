// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:temp/bank_details.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Photo Upload',
         style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1),
            const Text(
              'Upload a photo',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 82, 81, 81)),
            ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05),
            Center(
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.grey[300],
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Image.file(
                            _image!,
                            width: 240,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 50,
                        ),
                ),
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height*0.07),
            const Text(
              'Photo guidelines',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset('assets/clear_face.png', width: 100, height: 100),
                    const Text('Clear face'),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/no_sunglasses.png', width: 100, height: 80),
                    const Text('No sun-glasses'),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/no_group.png', width: 100, height: 100),
                    const Text('No group'),
                  ],
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BankDetails()),
                  );
              },
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity,
                          MediaQuery.of(context).size.height * 0.07),
                    ),
              child: Text(style: const TextStyle(color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600),
              _image == null ? 'Add photo' : 'Submit',),
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
