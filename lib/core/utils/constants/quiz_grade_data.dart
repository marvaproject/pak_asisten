// lib/constants/grade_data.dart

import 'package:flutter/material.dart';

class GradeData {
  static const Map<String, Map<String, dynamic>> gradeInfo = {
    'A+': {
      'range': '100',
      'color': Color(0xFF4CAF50),
      'messages': [
        "Congratulations!",
        "Perfect! You're absolutely brilliant!",
        "You've achieved the highest score possible!",
        "Outstanding achievement! You're a star!"
      ],
    },
    'A': {
      'range': '90-99',
      'color': Color(0xFF66BB6A),
      'messages': [
        "Congratulations!",
        "Outstanding performance!",
        "You're doing amazing!",
        "Keep up the excellent work!"
      ],
    },
    'A-': {
      'range': '85-89',
      'color': Color(0xFF81C784),
      'messages': [
        "Congratulations!",
        "Great job!",
        "You're very close to perfection!",
        "Excellent understanding of the material!"
      ],
    },
    'B+': {
      'range': '80-84',
      'color': Color(0xFF2196F3),
      'messages': [
        "Congratulations!",
        "Very good work!",
        "You're on the right track!",
        "Keep this momentum going!"
      ],
    },
    'B': {
      'range': '75-79',
      'color': Color(0xFF42A5F5),
      'messages': [
        "Congratulations!",
        "Good work!",
        "You've shown solid understanding!",
        "Well done on your performance!"
      ],
    },
    'B-': {
      'range': '70-74',
      'color': Color(0xFF64B5F6),
      'messages': [
        "Pretty good!",
        "Keep pushing yourself!",
        "You're doing well, but aim higher!",
        "There's potential for more!"
      ],
    },
    'C+': {
      'range': '65-69',
      'color': Color(0xFFFFC107),
      'messages': [
        "You're doing okay!",
        "Room for improvement ahead!",
        "Keep studying and you'll do better!",
        "Don't stop here!"
      ],
    },
    'C': {
      'range': '60-64',
      'color': Color(0xFFFFD54F),
      'messages': [
        "You've passed!",
        "Try to study more next time",
        "You can achieve better results!",
        "Focus on improving!"
      ],
    },
    'C-': {
      'range': '55-59',
      'color': Color(0xFFFFE082),
      'messages': [
        "You can do better!",
        "Focus on your weak points",
        "More practice needed",
        "Don't give up!"
      ],
    },
    'D+': {
      'range': '50-54',
      'color': Color(0xFFFF9800),
      'messages': [
        "You need to work harder",
        "Don't give up!",
        "Review your study methods",
        "Keep trying!"
      ],
    },
    'D': {
      'range': '45-49',
      'color': Color(0xFFFFA726),
      'messages': [
        "Please put in more effort",
        "Try again with more preparation",
        "You need to study more",
        "Don't lose hope!"
      ],
    },
    'D-': {
      'range': '40-44',
      'color': Color(0xFFFFB74D),
      'messages': [
        "You're struggling, but don't lose hope!",
        "Time to change your study approach",
        "Ask for help if needed",
        "Every failure is a chance to learn"
      ],
    },
    'E+': {
      'range': '35-39',
      'color': Color(0xFFF44336),
      'messages': [
        "You need serious improvement",
        "Let's study more!",
        "Don't be discouraged",
        "Time to work harder!"
      ],
    },
    'E': {
      'range': '1-34',
      'color': Color(0xFFEF5350),
      'messages': [
        "Time to hit the books harder!",
        "You can overcome this!",
        "Everyone has room for improvement",
        "Never give up!"
      ],
    },
    'F': {
      'range': '0',
      'color': Color(0xFFE53935),
      'messages': [
        "Don't be discouraged",
        "Everyone has bad days",
        "Tomorrow is another chance",
        "Learn from this experience"
      ],
    },
  };

  static const Set<String> congratsGrades = {'A+', 'A', 'A-', 'B+', 'B'};
}