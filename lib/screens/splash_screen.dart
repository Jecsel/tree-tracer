import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/ui_components/login.dart';
import 'package:tree_tracer/ui_components/main_view.dart';

class SplashScreen extends StatefulWidget {
  
  static String routeName = "/splash";

  // const SplashScreen({super.key});
  const SplashScreen({
    Key? key,
  }) : super(key: key);

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
    await Future.delayed(Duration(milliseconds: 3000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Image.asset(
          'assets/images/app_icon.jpg',
        ),
      )
    );
  }
}
