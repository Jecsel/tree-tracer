class Question {
  final String question;
  final String image;
  final List<String> choices;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.question,
    required this.image,
    required this.choices,
    required this.correctAnswerIndex,
    required this.explanation
  });

  Question.fromMap(Map<String, dynamic> map)
    : question = map['question'],
      image = map['image'],
      choices = List<String>.from(map['choices']),
      correctAnswerIndex = map['answer_index'],
      explanation = map['explanation'];

}