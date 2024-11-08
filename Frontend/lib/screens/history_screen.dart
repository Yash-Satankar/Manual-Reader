import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> history = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:5000/get_history'));
    if (response.statusCode == 200) {
      setState(() {
        history = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Q&A History"),
      ),
      body: history.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  title: Text("Q: ${item['question']}"),
                  subtitle: Text("A: ${item['answer']}"),
                  trailing: Text(item['timestamp']),
                );
              },
            ),
    );
  }
}
