import 'package:flutter/material.dart';
import 'package:latihan_layout_navigation/latihan_layout.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Flutter Modul 1',
      theme: ThemeData(),
      home: const LayoutPage(),
    );
  }
}

