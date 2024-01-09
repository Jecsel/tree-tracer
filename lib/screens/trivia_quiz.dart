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
              'The Alagau Tree is abundant in Sitio Tia-ilan in Barangay Agutay. Most of these trees grow by the seashore and there are also in the mountains.'),
      Question(
          question:
              'In which Barangay in the town of Cajidiocan can the Bakan Tree be found?',
          image: 'assets/images/bakan1.jpeg',
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
          image: 'assets/images/agoho1.jpg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. On the seashore.',
            'C. On the upper reaches of Mt. Guiting-Guiting.'
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Agoho Tree is abundant in Poblacion, Magdiwang, Romblon. It is mostly found on the seashore. There are many agoho in Poblacion, Tampayan and there is also in Barangay Ambulong.'),
      Question(
          question:
              'Which part of MT. GUITING GUITING where the Apitong Tree is located?',
          image: 'assets/images/apitong3.jpeg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. In the National Parks lower elevations of Mt. Guiting-Guiting.',
            'C. On the upper reaches of Mt. Guiting-Guiting.'
          ],
          correctAnswerIndex: 1,
          explanation:
              'Apitong Tree are usually found in the islands lowlands, particularly in Mount Guiting-Guiting National Parks lower elevations.'),
      Question(
          question:
              'Which part of MT. GUITING GUITING where the Malasantol Tree is located?',
          image: 'assets/images/malasantol1.jpeg',
          choices: [
            'A. Lowland areas of Mt. Guiting-Guiting National Park.',
            'B. On the upper reaches of Mt. Guiting-Guiting.',
            'C. Near the rivers at the foot of Mt. Guiting Guiting.'
          ],
          correctAnswerIndex: 0,
          explanation:
              'You may encounter Malasantol trees in various lowland areas, including parts of Mount Guiting-Guiting National Park. The tree may have applications in traditional medicine or local practices, although the extent of such uses can vary regionally.'),
      Question(
          question:
              'In which place in Magdiwang can you see the huge Kubi Tree?',
          image: 'assets/images/kubi1.jpeg',
          choices: ['A. Agutay', 'B. Agtiwa ', 'C. Tampayan '],
          correctAnswerIndex: 1,
          explanation:
              'The Kubi Tree is mostly on private land. the chainsaw hates that because its resin is sticky but its wood is strong. There are many kubi trees in Barngay Agutay and Agtiwa. There in Agtiwa there is a huge Kube tree.'),
      Question(
          question:
              'In which Barangays in the town of Magdiwang can the Busisi Tree be found?',
          image: 'assets/images/busisi1.jpeg',
          choices: [
            'A. Agutay, Agtiwa, Agsao',
            'B. Ambulong, Ipil Dulangan',
            'C. Silum, Tampayan, Jao-asan'
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Busisi tree grows all around. In Agutay, Agtiwa, Barangay Agsao. simply chopped and utilized by the indigenous, whose leaves and roots are used in traditional medicine to heal illnesses.'),
      Question(
          question:
              'Where in Sibuyan Island can you often see the Dolalog tree?',
          image: 'assets/images/dolalog.jpeg',
          choices: [
            'A. . Close to the riverside.',
            'B. On the upper reaches of Mt. Guiting-Guiting.',
            'C. On the seashore.'
          ],
          correctAnswerIndex: 0,
          explanation:
              'Dolalog is abundant in Barangay Agutay, Agtiwa, Agsao or anywhere Barangay has it. most of them can be seen next to the river or next to the stream. The main dolalog tree in sibuyan island is called tayobog.'),
      Question(
          question:
              'In which Barangay in the town of Magdiwang can the Balinghasai Tree be found?',
          image: 'assets/images/balinghasay1.jpg',
          choices: [
            'A. Barangay Silum',
            'B. Barangay Dulangan',
            'C. Barangay Tampayan'
          ],
          correctAnswerIndex: 2,
          explanation:
              'Balinghasai Tree is mostly seen in Logdeck Tampayan Magdiwang Romblon.'),
      Question(
          question:
              'In which part of sibuyan island is the Putat Tree mostly seen?',
          image: 'assets/images/putat2.jpg',
          choices: [
            'A. On the upper reaches of Mt. Guiting-Guiting.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. On the seashore. '
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Putat Tree can be seen on the seashore. This tree can be found almost along the seashore in the entire Island of Sibuyan.'),
      Question(
          question:
              'Where Barangay in the town of Sanfernado can you find the Binayuyu Tree?',
          image: 'assets/images/binayuyu.jpg',
          choices: ['A. Mabini', 'B. Mabulo', 'C. España'],
          correctAnswerIndex: 2,
          explanation:
              'The Binayuyu Tree can be found in Barangay España, Sanfernado, Romblon. There you can see a lot of the trees that have been mentioned.'),
      Question(
          question: 'Where can you see the Tugbak Tree in Sibuyan Island?',
          image: 'assets/images/tugbak1.jpg',
          choices: [
            'A. España, Sanfernado, Romblon',
            'B. Tampayan, Magdiwang, Romblon',
            'C. Cambajao, Cajidiocan, Romblon'
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Tugbak Tree is located in Sitio Logdeck, Barangay Tampayan, Magdiwang, Romblon.'),
      Question(
          question:
              'In which part of sibuyan island is the Mangasinoro Tree mostly seen?',
          image: 'assets/images/mangasinoro1.jpg',
          choices: [
            'A. On the upper reaches of Mt. Guiting-Guiting.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Mangasinoro Tree can be found in lowland areas including parts of MT. GUITING GUITING National Park in Sibuyan.'),
      Question(
          question:
              'In which Barangay in Sanfernado Romblon is the Malabuho Tree located?',
          image: 'assets/images/malabuho3.jpeg',
          choices: ['A. España', 'B. Mabulo', 'C. Mabini'],
          correctAnswerIndex: 2,
          explanation:
              'The Malabuho Tree is located in Barangay Mabini in Sanfernado, Romblon. Only this can usually be seen on the mountain.'),
      Question(
          question:
              'In which place in Sibuyan Island are the most Bahai Trees located?',
          image: 'assets/images/bahai1.jpg',
          choices: [
            'A. Lowland areas of Mt. Guiting Guiting.',
            'B. On the upper reaches of Mt. Guiting-Guiting.',
            'C. On the seashore. '
          ],
          correctAnswerIndex: 0,
          explanation:
              'Bahai Trees are located on Mt. Guiting Guiting particularly in forests at low and medium altitudes. This tree is found scattered in dipterocarp forests. The bahai tree is propagated by seeds.'),
      Question(
          question: 'Where in Magdiwang is the Kahoy Dalaga Tree located?',
          image: 'assets/images/kahoydalaga4.jpeg',
          choices: [
            'A. Barangay Agtiwa',
            'B. Barangay Silum',
            'C. Barangay Tampayan'
          ],
          correctAnswerIndex: 2,
          explanation:
              'Kahoy Dalaga Tree is located in Sitio Logdeck, Barangay Tampayan, Magdiwang, Romblon particularly in National Park in Sibuyan.'),
      Question(
          question:
              'What Barangay in Sibuyan Island has many Marang Trees growing?',
          image: 'assets/images/marang3.jpeg',
          choices: [
            'A. Barangay Cantagda',
            'B. Barangay Danao',
            'C. Barangay Cambalo'
          ],
          correctAnswerIndex: 0,
          explanation:
              'In Barangay Cantagda, Cajidiocan, Romblon there are many Marang Trees because most of the land there is private land. The Marang Tree is closely related to the jackfruit, cempedak, and breadfruit trees which all belong to the same genus, Artocarpus.'),
      Question(
          question:
              'Where part of Mt. Guiting Guiting is the Tamayuan Tree located?',
          image: 'assets/images/tamayuan2.jpeg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. Just above flood level up to 350m elevations of Mt. Guiting Guiting.',
            'C. Lowland areas of Mt. Guiting Guiting.'
          ],
          correctAnswerIndex: 1,
          explanation:
              'You may encounter Tamayuan Tree just above flood level up to 350m elevations.'),
      Question(
          question:
              'In which Barangay in Magdiwang is the Tagotoi Tree located?',
          image: 'assets/images/tagotoi1.jpg',
          choices: [
            'A. Barangay Tampayan',
            'B. Barangay Agsao',
            'C. Barangay Ambulong'
          ],
          correctAnswerIndex: 0,
          explanation:
              'Kahoy Dalaga Tree is located in Sitio Logdeck, Barangay Tampayan, Magdiwang, Romblon particularly in National Park in Sibuyan.'),
      Question(
          question: 'Which area of Sibuyan Island is Balit Trees located?',
          image: 'assets/images/balit2.jpeg',
          choices: [
            'A. Lowland areas of MT. Guiting Guiting National Park.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. On the upper reaches of Mt. Guiting-Guiting.'
          ],
          correctAnswerIndex: 0,
          explanation:
              'The Balit Tree is located in lowland areas including parts of MT. GUITING GUITING National Park in Sibuya'),
      Question(
          question:
              'Which part of Mt. Guiting Guiting is the Tindalo Tree located?',
          image: 'assets/images/tindalo1.jpeg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. On the upper reaches of Mt. Guiting-Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Tindalo Tree is located in the upper reaches of Mt. Guiting-Guiting. Tindalo is one of the finest Philippine woods used for cabinet making and all kinds of high-grade construction.'),
      Question(
          question:
              'In which part of sibuyan island is the Katmon Tree mostly seen?',
          image: 'assets/images/katmon1.jpg',
          choices: [
            'A. On the upper reaches of Mt. Guiting-Guiting.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Katmon Tree can be found in lowland areas including parts of MT. GUITING GUITING National Park in Sibuyan.'),
      Question(
          question: 'Where in sibuyan island can you see the Alim Tree?',
          image: 'assets/images/alim1.jpg',
          choices: [
            'A. Town of Magdiwang ',
            'B. Town of Sanfernado ',
            'C. Everywhere in the Island of Sibuyan.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Alim Tree can be seen mainly secondary places like roadsides, regrowth thickets, depleted open forest, forest edges in savannah, coconut plantations, old gardens. We can see this tree around Island of Sibuyan.'),
      Question(
          question: 'Which part of Mt. Guiting Guiting located Bago Tree?',
          image: 'assets/images/bago1.jpg',
          choices: [
            'A. On the upper reaches of Mt. Guiting-Guiting.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Bago Tree can be found in lowland areas including parts of MT. GUITING GUITING National Park in Sibuyan.'),
      Question(
          question:
              'Which part of Mt. Guiting Guiting is the Nato Tree located?',
          image: 'assets/images/nato1.jpg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. Lowland areas of MT. Guiting Guiting National Park.',
            'C. On the upper reaches of Mt. Guiting-Guiting.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Nato  Tree is located in the upper reaches of Mt. Guiting-Guiting. Nato, or Palaquium luzoniense, is a valuable timber tree that has been used for various purposes throughout history. Its wood is highly sought after due to its durability, strength, and beautiful reddish-brown color.'),
      Question(
          question: 'Where in Sibuyan Island is the Maganhop Tree located?',
          image: 'assets/images/maganhop2.jpg',
          choices: [
            'A. Near the rivers.',
            'B. Lowland areas.',
            'C. On the seashore.'
          ],
          correctAnswerIndex: 1,
          explanation:
              'The Maganhop Tree is a lowland tree that grows virtually everywhere in Sibuyan Island. Like many other tannin-producing barks, its bark is used medicinally, such as for colic. '),
      Question(
          question:
              'Which part of Mt. Guiting Guiting is the Suklapi Tree located?',
          image: 'assets/images/sukalpi1.jpg',
          choices: [
            'A. Near the rivers at the foot of Mt. Guiting Guiting.',
            'B. On the upper reaches of Mt. Guiting-Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Suklapi Tree is located in the upper reaches of Mt. Guiting-Guiting'),
      Question(
          question:
              'In which part of sibuyan island is the Red Luan Tree mostly seen?',
          image: 'assets/images/redlauan1.jpg',
          choices: [
            'A. On the upper reaches of Mt. Guiting-Guiting.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'Lowland regions, such as sections of MT. GUITING GUITING National Park in Sibuyan, are home to the Mangasinoro Tree.'),
      Question(
          question:
              'In which part of sibuyan island is the Malapanau Tree located?',
          image: 'assets/images/malapanau3.jpg',
          choices: [
            'A. On the upper reaches of Mt. Guiting-Guiting.',
            'B. Near the rivers at the foot of Mt. Guiting Guiting.',
            'C. Lowland areas of MT. Guiting Guiting National Park.'
          ],
          correctAnswerIndex: 2,
          explanation:
              'The Malapanau Tree can be found in lowland areas including parts of MT. GUITING GUITING National Park in Sibuyan.'),
    ];

    questions.shuffle();

    selectedAnswers = List.filled(questions.length, null);
  }

  void onAnswerSelected(int questionIndex, int choiceIndex) {
    setState(() {
      selectedAnswers[questionIndex] = choiceIndex;
      questionIndexSelected = questionIndex;
      choiceIndexSelected = choiceIndex;

      if (selectedAnswers[questionIndex] ==
          questions[questionIndex].correctAnswerIndex) {
        showExplanation = true;
        isWrongAnswer = false;
        // audioCache.play('correct.mp3');
        player.play(AssetSource('correct.mp3'));

        // Future.delayed(const Duration(seconds: 5), () {
        //   setState(() {
        //     if (currentQuestionIndex < questions.length - 1) {
        //       showExplanation = false;
        //       currentQuestionIndex++;
        //     } else {
        //       int finalScore = calculateScore();
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => Score(score: finalScore.toString())));
        //     }
        //   });
        // });
      } else {
        // audioCache.play('wrong.mp3');
        player.play(AssetSource('wrong.mp3'));
        questions[questionIndex].choices.asMap().forEach((index, choice) {
          if (index == choiceIndex) {
            isWrongAnswer = true;
            showExplanation = false;
            if (currentQuestionIndex < questions.length - 1) {
              currentQuestionIndex++;
            } else {
              int finalScore = calculateScore();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Score(score: finalScore.toString())));
            }

            // questions[questionIndex].choices[index] = 'Wrong Answer';
          }
        });
      }
    });
  }

  nextQuestion() {
    setState(() {
      isWrongAnswer = true;
      showExplanation = false;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        int finalScore = calculateScore();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Score(score: finalScore.toString())));
      }
    });
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
                  child: Text(
                      questions.isNotEmpty
                          ? '$currentNumber . ${questions[currentQuestionIndex].question}'
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 15.0),
                ...questions[currentQuestionIndex].choices.map((choice) {
                  int index =
                      questions[currentQuestionIndex].choices.indexOf(choice);
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        onPressed: () {
                          onAnswerSelected(currentQuestionIndex, index);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
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
                    : const Text(''),
                showExplanation
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: nextQuestion,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Text(
                              'NEXT',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          ),
        ));
  }
}
