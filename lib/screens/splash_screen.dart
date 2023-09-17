import 'package:flutter/material.dart';
import 'package:grovievision/screens/home.dart';

class SplashScreen extends StatefulWidget {
  
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async{
    await Future.delayed(Duration(milliseconds: 2000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
          children: <Widget>[
              Image.asset(
              'assets/images/splash_logo.png',
              ),
          ],
        ),
      )
    );
  }
}
