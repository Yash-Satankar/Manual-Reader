import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/api_service.dart';
import 'question_screen.dart';

class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  @override
  _UploadPdfScreenState createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  bool _isUploading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  Future<void> _requestPermission() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
      if (permissionStatus.isDenied) {
        await openAppSettings();
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _uploadPdf() async {
    await _requestPermission();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      File pdfFile = File(result.files.single.path!);
      setState(() => _isUploading = true);

      try {
        var response = await apiService.uploadPdf(pdfFile, "user_id_1");
        int pdfId = response['pdf_id'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuestionScreen(pdfId: pdfId)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Upload failed")));
      } finally {
        setState(() => _isUploading = false);
      }
    } else {
      print("No file selected or operation was cancelled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload PDF')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadPdf,
                    child: const Text('Upload PDF'),
                  ),
          ],
        ),
      ),
    );
  }
}
