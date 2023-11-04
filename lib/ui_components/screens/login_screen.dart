import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/admin.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/services/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
  final TextEditingController _emailController = TextEditingController(text: 'admin');
  final TextEditingController _passController = TextEditingController(text: '123123123');
  var isLogin = false;

  Future<void> _login() async {
    isLogin = await dbHelper.loginUser(_emailController.text, _passController.text);

    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AdminPage(searchKey: 'TREE', userType: 'User',);
          },
        ),
      );
    }
    print("==========isLogin===========");
    print(isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 100, right: 15, bottom: 50),
                child: Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF393939),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF393939),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color(0xFF9F7BFF),
                    ),
                    onPressed: () {
                      _login();
                    },
                    child: const Text("Login"),
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ClipRRect(
                  //         borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //         child: ElevatedButton(
                  //           onPressed: () {},
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: const Color(0xFF9F7BFF),
                  //           ),
                  //           child: const Text(
                  //             'Sign In',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 15,
                  //               fontFamily: 'Poppins',
                  //               fontWeight: FontWeight.w500,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          color: Color(0xFF837E93),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 2.5,
                      ),
                      InkWell(
                        onTap: () {
                          widget.controller.animateToPage(1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}