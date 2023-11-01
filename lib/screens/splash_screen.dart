import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/services/database_helper.dart';
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
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper.initiateUserData(dbHelper);
    print("============initiateUserData====done=====");
    dbHelper.initiateMangrooveData(dbHelper);
    print("============initiateMangrooveData====done=====");
    _navigateToHome();
  }

  _navigateToHome() async{
    await Future.delayed(Duration(milliseconds: 3000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon.png',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Image.asset(
              "assets/images/loading.gif",
              width: 50,  // Set both width and height to the same value
              height: 50, // to create a perfect circle
            ),
          ),
        ],
      ),
      )
    );
  }
}
