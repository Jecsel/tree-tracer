import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/trivia_home.dart';
import 'package:tree_tracer/screens/view_species.dart';
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
  TracerDatabaseHelper dbHelper = TracerDatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper.initiateUserData(dbHelper);
    print("============initiateUserData====done=====");
    dbHelper.initiateTracerData(dbHelper);
    print("============initiateTracerData====done=====");
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
          ClipOval(
            child: Image.asset(
              "assets/images/app_logo.jpg",
                  width: 200, // Set both width and height to the same value
                  height: 200, // to create a perfect circle
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Image.asset(
              "assets/images/loading.gif",
              width: 35,  // Set both width and height to the same value
              height: 35, // to create a perfect circle
            ),
          ),
        ],
      ),
      )
    );
  }
}
