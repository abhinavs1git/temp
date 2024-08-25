// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:temp/final_confirm.dart';


class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({super.key});

  @override
  _DocumentUploadPageState createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  double uploadProgress = 0;
  String? uploadStatus;

  // Track uploaded files
  Map<String, PlatformFile?> uploadedFiles = {
    'Address Proof': null,
    'Land Ownership': null,
    'Harvest Record': null,
    'Skill Certificates': null,
    'Farm Photos': null,
  };

  Future<void> _pickFile(String fileType, String section) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType == "pdf" ? FileType.custom : FileType.image,
      allowedExtensions: fileType == "pdf" ? ['pdf'] : ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        uploadedFiles[section] = file;
      });
      _uploadFile(file);
    }
  }

  Future<void> _uploadFile(PlatformFile file) async {
    Dio dio = Dio();
    String fileName = file.name;
    String filePath = file.path!;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
    });

    dio.post(
      "https://vfgabackend.soachglobal.com/", // upload URL
      data: formData,
      onSendProgress: (int sent, int total) {
        setState(() {
          uploadProgress = sent / total;
          uploadStatus = '${(uploadProgress * 100).toStringAsFixed(0)}%';
        });
      },
    ).then((response) {
      setState(() {
        uploadStatus = 'Upload complete!';
      });
    }).catchError((error) {
      setState(() {
        uploadStatus = 'Upload failed';
      });
    });
  }

  Widget _buildUploadContainer(String section, String fileType) {
    if (uploadedFiles[section] != null) {
      return GestureDetector(
        onTap: () => _openFile(uploadedFiles[section]!),
        child: Container(
          margin:const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.green, size: 40),
              const SizedBox(height: 10),
              Text(
                uploadedFiles[section]!.name,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Text(
                '${(uploadedFiles[section]!.size / 1024).toStringAsFixed(2)} KB',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _pickFile(fileType, section),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_upload_outlined, color: Colors.redAccent, size: 40),
              const SizedBox(height: 10),
              Text(
                'Click to Upload or drag and drop',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Text(
                '(Max. File size: 25 MB)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _openFile(PlatformFile file) async {
    await OpenFile.open(file.path);
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _submit() {
    List<String> missingFiles = [];

    // Check for missing files
    uploadedFiles.forEach((key, value) {
      if (value == null) {
        missingFiles.add(key);
      }
    });

    if (missingFiles.isNotEmpty) {
      // Show error if files are missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${missingFiles.join(", ")} not uploaded'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      // Navigate to success page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FinalConfirmScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Document Upload', style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSectionHeader('Address Proof', 'eg: bill, Aadhar card'),
            _buildUploadContainer('Address Proof', 'pdf'),

            _buildSectionHeader('Land Ownership', 'eg: bill, Aadhar card'),
            _buildUploadContainer('Land Ownership', 'pdf'),

            _buildSectionHeader('Harvest Record', 'eg: bill, Aadhar card'),
            _buildUploadContainer('Harvest Record', 'pdf'),

            _buildSectionHeader('Skill Certificates', 'eg: bill, Aadhar card'),
            _buildUploadContainer('Skill Certificates', 'pdf'),

            _buildSectionHeader('Farm Photos', 'eg: bill, Aadhar card'),
            _buildUploadContainer('Farm Photos', 'image'),

            if (uploadProgress > 0)
              Column(
                children: [
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: uploadProgress,
                    backgroundColor: Colors.grey[200],
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    uploadStatus ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(child: Text('Submit', style: TextStyle(fontSize: 18,color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Documents uploaded successfully!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
    );
  }
}
