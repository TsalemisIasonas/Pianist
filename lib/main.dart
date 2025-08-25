import 'package:flutter/material.dart';
import 'package:pianist/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pianist",
      home: HomePage(),
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
    );
  }
}