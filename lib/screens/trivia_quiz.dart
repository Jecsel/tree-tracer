import 'package:flutter/material.dart';
import 'package:tree_tracer/models/question.dart';
import 'package:tree_tracer/screens/score.dart';
import 'package:tree_tracer/screens/trivia_home.dart';
import 'package:audioplayers/audioplayers.dart';

class TriviaQuiz extends StatefulWidget {
  const TriviaQuiz({super.key});

  @override
  State<TriviaQuiz> createState() => _TriviaQuizState();
}

class _TriviaQuizState extends State<TriviaQuiz> {
  var score = 0;
  int currentQuestionIndex = 0;
  late List<Question> questions;
  late List<int?> selectedAnswers;
  bool showExplanation = false;
  bool isWrongAnswer = false;
  final player = AudioPlayer();

  int questionIndexSelected = 0;
  int choiceIndexSelected = 0;
  bool userSelectAnAnswer = false;

  @override
  void initState() {
    super.initState();


    questions = [
      Question(
          question: 'In which part of Baranggay Agutay is Alagau Tree located?',
          image: 'assets/images/alakaakpula1.jpeg',
          choices: [
            'A. Sitio Tia-ilan',
            'B. Sitio Kalamago',
            'C. Sitio Malobago'
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Alagau Tree is abundant in sitio Tia-ilan in Barangay Agutay. Most of these trees grow by the seashore and there are also in the mountains.'),
      Question(
          question:
              'In which Barangay in the town of Cajidiocan can the Bakan Tree be found?',
          image: 'assets/images/alakaakpula2.jpeg',
          choices: [
            'A. Barangay Cambalo',
            'B. Barangay Cambajao',
            'C. Barangay Danao'
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Bakan Tree is found in Barangay Cambajao, Cajidiocan, Romblon. In Cambajao you can see a lot of these trees, some illegal loggers were caught there and after investigating the trees that were cut down they identified that the tree was Bakan Tree.'),
      Question(
          question: 'Where in Sibuyan Island can you often see the agoho tree?',
          image: 'assets/images/alakaakpula3.jpeg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. On the seashore.',
            'C. On the upper reaches of Mt. Guiting-Guiting.'
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Agoho Tree is abundant in Poblacion, Magdiwang, Romblon. It is mostly found on the seashore. There are many agoho in Poblacion, Tampayan and there is also in Barangay Ambulong.'),
    ];

    questions.shuffle();

    selectedAnswers = List.filled(questions.length, null);
  }

  void onAnswerSelected(int questionIndex, int choiceIndex) {
    setState(() {
      selectedAnswers[questionIndex] = choiceIndex;
      questionIndexSelected = questionIndex;
      choiceIndexSelected = choiceIndex;
      
      if (selectedAnswers[questionIndex] == questions[questionIndex].correctAnswerIndex) {
        showExplanation = true;
        isWrongAnswer = false;
        // audioCache.play('correct.mp3');
        player.play(AssetSource('correct.mp3'));

        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            if (currentQuestionIndex < questions.length - 1) {
              showExplanation = false;
              currentQuestionIndex++;
            } else {
              int finalScore = calculateScore();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Score(score: finalScore.toString())));
            }
          });
        });
      } else {
        // audioCache.play('wrong.mp3');
        player.play(AssetSource('wrong.mp3'));
        questions[questionIndex].choices.asMap().forEach((index, choice) {
          if (index == choiceIndex) {
            isWrongAnswer = true;
            questions[questionIndex].choices[index] = 'Wrong Answer';
            
          }
        });
      }
    });

    // Future.delayed(const Duration(milliseconds: 500), () {
    //   setState(() {

    //   });
    // });
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswerIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const CircularProgressIndicator();
    }

    String currentNumber = (currentQuestionIndex + 1).toString();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 15.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              Image.asset(
                questions[currentQuestionIndex].image,
                width: double.infinity,
                height: 300.0,
              ),
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(questions.isNotEmpty
                    ? '$currentNumber . ${questions[currentQuestionIndex].question}'
                    : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
              ),
              const SizedBox(height: 15.0),
              ...questions[currentQuestionIndex].choices.map((choice) {
                int index = questions[currentQuestionIndex].choices.indexOf(choice);
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:  MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {
                        onAnswerSelected(currentQuestionIndex, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Text(
                          choice,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              showExplanation
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        questions.isNotEmpty
                            ? questions[currentQuestionIndex].explanation
                            : '',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 15.0),
                      ),
                    )
                  : const Text('')
            ],
          ),
        ),
      )
      
      
    );
  }
}
