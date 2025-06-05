import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TiketPendakianApp());
}

class TiketPendakianApp extends StatelessWidget {
  const TiketPendakianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiket Pendakian',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
