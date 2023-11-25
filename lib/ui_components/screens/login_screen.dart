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
  TracerDatabaseHelper dbHelper = TracerDatabaseHelper.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController(text: 'admin');
  // final TextEditingController _passController = TextEditingController(text: '123123123');
  var isLogin = false;
  bool _obscurePassword = true;

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
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 24, 122, 0), Color.fromARGB(255, 82, 209, 90)],
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
            },
        ),
      ),
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
                  TextFormField(
                    controller: _passController,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: _obscurePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // TextField(
                  //   controller: _passController,
                  //   obscureText: _obscurePassword,
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     color: Color(0xFF393939),
                  //     fontSize: 13,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  //   decoration: const InputDecoration(
                  //     labelText: 'Password',
                  //     labelStyle: TextStyle(
                  //       color: Color(0xFF755DC1),
                  //       fontSize: 15,
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       borderSide: BorderSide(
                  //         width: 1,
                  //         color: Color(0xFF837E93),
                  //       ),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       borderSide: BorderSide(
                  //         width: 1,
                  //         color: Color(0xFF9F7BFF),
                  //       ),
                  //     ),
                  //     prefixIcon: const Icon(Icons.password_outlined),
                  //     // suffixIcon: IconButton(
                  //     //     onPressed: () {
                  //     //       setState(() {
                  //     //         _obscurePassword = !_obscurePassword;
                  //     //       });
                  //     //     },
                  //     //     icon: _obscurePassword ? const Icon(Icons.visibility_outlined) : const Icon(Icons.visibility_off_outlined)
                  //     // ),
                  //   ),
                  // ),
                  
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
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
