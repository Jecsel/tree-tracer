import 'package:flutter/material.dart';
import 'package:grovievision/routes.dart';
import 'package:grovievision/screens/splash_screen.dart';
import 'package:grovievision/theme.dart';

/// Flutter code sample for [Scaffold].

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Way - Template',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}