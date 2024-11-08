import 'package:flutter/material.dart';
import 'package:pdf_reader/screens/history_screen.dart';

import 'upload_pdf_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Reader'),
      ),
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadPdfScreen()),
                  );
                },
                child: const Text('Upload PDF and Start'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to HistoryScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()),
                );
              },
              child: const Text('View Q&A History'),
            ),
          ],
        ),
      ),
    );
  }
}
