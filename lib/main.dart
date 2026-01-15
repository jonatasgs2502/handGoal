import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/goal_model.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    // 1. Informa ao Flutter sobre o nosso modelo de estado
    //    antes que o aplicativo seja executado.
    ChangeNotifierProvider(
      create: (context) => GoalModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HandGoal Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF252525),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: Colors.orange,
          labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}
