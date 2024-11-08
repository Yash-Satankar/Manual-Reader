import 'package:flutter/material.dart';

import '../services/api_service.dart';

class QuestionScreen extends StatefulWidget {
  final int pdfId;

  const QuestionScreen({super.key, required this.pdfId});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _questionController = TextEditingController();
  final ApiService apiService = ApiService();
  String? _answer;
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(_controller);
  }

  Future<void> _askQuestion() async {
    setState(() => _isLoading = true);
    try {
      final answer = await apiService.askQuestion(
        _questionController.text,
        "user_id_1",
        widget.pdfId,
      );
      setState(() {
        _answer = answer;
        _controller.forward();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to get answer")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration:
                  const InputDecoration(labelText: 'Enter your question'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _askQuestion,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Ask'),
            ),
            const SizedBox(height: 20),
            if (_answer != null)
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_answer!, style: const TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
