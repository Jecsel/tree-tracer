import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

// void main() {
//   runApp(DevicePreview(
//     builder: (context) => const MyApp(),
//   ));
// }

void main() async {
  await _initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
      home: const SplashScreen(),
    );
  }
}


// void main() async {
//   await _initHive();
//   runApp(const MainApp());
// }

Future<void> _initHive() async{
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}

/// Flutter code sample for [Scaffold].

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'The Flutter Way - Template',
//       theme: AppTheme.lightTheme(context),
//       initialRoute: SplashScreen.routeName,
//       routes: routes,
//     );
//   }
// }