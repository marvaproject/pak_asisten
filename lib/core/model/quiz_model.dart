import 'dart:math';

class QuizModel {
  final String language;
  final String subject;
  final String material;
  final String difficulty;
  final List<QuestionModel> questions;

  QuizModel({
    required this.language,
    required this.subject,
    required this.material,
    required this.difficulty,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      language: json['language'] ?? '',
      subject: json['subject'] ?? '',
      material: json['material'] ?? '',
      difficulty: json['difficulty'] ?? '',
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuestionModel.fromJson(q))
          .toList(),
    );
  }
}

class QuestionModel {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  late final List<String> shuffledAnswers;
  late final int correctAnswerIndex;

  QuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  }) {
    shuffledAnswers = [...incorrectAnswers, correctAnswer];
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrect_answers'] ?? []),
    );
  }

  void shuffleAnswers() {
    final random = Random();
    for (var i = shuffledAnswers.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffledAnswers[i];
      shuffledAnswers[i] = shuffledAnswers[j];
      shuffledAnswers[j] = temp;
    }
    correctAnswerIndex = shuffledAnswers.indexOf(correctAnswer);
  }
}