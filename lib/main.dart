import 'package:flutter/material.dart';
import 'package:tarefas/page/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarefas',
      theme: ThemeData(
        brightness: ThemeData.dark().brightness,
      ),
      home: const LoginPage(),
    );
  }
}
