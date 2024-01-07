import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/trivia_home.dart';


class Score extends StatefulWidget {

  String score;

  Score({super.key, required this.score});

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text('Trivia'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TriviaHome()));
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
          children: [
            const SizedBox( height: 80.0),
            const Text(
              "Your Score out of 30",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox( height: 50.0),
            Text(
              widget.score,
              style: const TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      )
    );
  }
}