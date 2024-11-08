import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(ManualReaderApp());
}

class ManualReaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manual Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
