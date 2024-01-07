import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/trivia_quiz.dart';

import 'home.dart';

class TriviaHome extends StatefulWidget {
  const TriviaHome({super.key});

  @override
  State<TriviaHome> createState() => _TriviaHomeState();
}

class _TriviaHomeState extends State<TriviaHome> {
  _goToQuiz() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TriviaQuiz()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trivia'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 24, 122, 0),
                  Color.fromARGB(255, 82, 209, 90)
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80.0),
              ClipOval(
                child: Image.asset(
                  "assets/images/trivia.png",
                  width: double
                      .infinity, // Set both width and height to the same value
                  height: 250, // to create a perfect circle
                ),
              ),
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 200.0,
                  height: 60.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: _goToQuiz,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Text(
                        'START',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
