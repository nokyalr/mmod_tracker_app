import 'package:flutter/material.dart';
import 'package:mood_tracker_app/providers/report_provider.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/post_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme:
          ThemeData(primarySwatch: Colors.orange, fontFamily: 'ADLaMDisplay'),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
