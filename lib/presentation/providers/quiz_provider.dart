// lib/presentation/providers/quiz_provider.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pak_asisten/core/model/quiz_model.dart';
import 'package:pak_asisten/core/services/quiz_services.dart';
import 'package:pak_asisten/core/utils/constants/quiz_grade_data.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  QuizModel? _quiz;
  int _currentQuestionIndex = 0;
  List<int> _userAnswers = [];
  DateTime? _startTime;
  String? _error;
  bool _isLoading = false;

  QuizModel? get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  List<int> get userAnswers => _userAnswers;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get canMoveNext =>
      _currentQuestionIndex < (_quiz?.questions.length ?? 0) - 1;

  int getUnansweredCount() {
    if (_quiz == null) return 0;
    return _userAnswers.where((answer) => answer == -1).length;
  }

  Future<void> generateQuiz({
    required String language,
    required String subject,
    required String material,
    required String difficulty,
    required String questionCount,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _quiz = await _quizService.generateQuiz(
        language: language,
        subject: subject,
        material: material,
        difficulty: difficulty,
        questionCount: questionCount,
      );

      // Acak jawaban sekali saat generate
      for (var question in _quiz!.questions) {
        question.shuffleAnswers();
      }

      _currentQuestionIndex = 0;
      _userAnswers = List.filled(_quiz!.questions.length, -1);
      _startTime = DateTime.now();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

double getScorePercentage() {
  if (_quiz == null) return 0;
  int correctAnswers = getScore();
  return (correctAnswers / _quiz!.questions.length) * 100;
}

String getGrade() {
  double score = getScorePercentage();
  for (var grade in GradeData.gradeInfo.entries) {
    var range = grade.value['range'] as String;
    if (range.contains('-')) {
      var limits = range.split('-').map(int.parse).toList();
      if (score >= limits[0] && score <= limits[1]) return grade.key;
    } else {
      if (score == double.parse(range)) return grade.key;
    }
  }
  return 'F';
}

String getRandomMessage() {
  String grade = getGrade();
  var messages = GradeData.gradeInfo[grade]!['messages'] as List;
  return messages[Random().nextInt(messages.length)];
}

Map<String, dynamic> getQuizResults() {
  return {
    'score': getScorePercentage(),
    'grade': getGrade(),
    'message': getRandomMessage(),
    'totalQuestions': quiz?.questions.length ?? 0,
    'correctAnswers': getScore(),
    'wrongAnswers': _userAnswers.where((a) => a != -1).length - getScore(),
    'notAnswered': _userAnswers.where((a) => a == -1).length,
    'duration': getElapsedTime(),
    'language': quiz?.language ?? '',
    'subject': quiz?.subject ?? '',
    'material': quiz?.material ?? '',
    'difficulty': quiz?.difficulty ?? '',
  };
}

  void answerQuestion(int answerIndex) {
    if (_quiz == null) return;
    _userAnswers[_currentQuestionIndex] = answerIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (canMoveNext) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  Duration getElapsedTime() {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }

  int getScore() {
    if (_quiz == null) return 0;
    int score = 0;
    for (int i = 0; i < _quiz!.questions.length; i++) {
      if (_userAnswers[i] != -1) {
        if (_userAnswers[i] == _quiz!.questions[i].correctAnswerIndex) {
          score++;
        }
      }
    }
    return score;
  }

  void reset() {
    _quiz = null;
    _currentQuestionIndex = 0;
    _userAnswers = [];
    _startTime = null;
    _error = null;
    notifyListeners();
  }
}
