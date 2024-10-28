import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:pak_asisten/core/model/quiz_model.dart';

class QuizService {
  final gemini = Gemini.instance;

  Future<QuizModel> generateQuiz({
    required String language,
    required String subject,
    required String material,
    required String difficulty,
    required String questionCount,
  }) async {
    try {
      final prompt = '''
      Generate a quiz with these specifications:
      - Number of questions: $questionCount
      - Language: $language
      - Subject: $subject
      - Topic: $material
      - Difficulty: $difficulty

      Provide the response in this exact JSON format:
      {
        "language": "$language",
        "subject": "$subject",
        "material": "$material",
        "difficulty": "$difficulty",
        "questions": [
          {
            "question": "Write the question here",
            "correct_answer": "Correct answer",
            "incorrect_answers": [
              "First wrong answer",
              "Second wrong answer",
              "Third wrong answer"
            ]
          }
        ]
      }

      Rules:
      1. Strictly follow the JSON format above
      2. Each question must have exactly 3 incorrect answers and 1 correct answer
      3. Do not add any explanation or additional text
      4. Ensure all JSON properties are properly quoted
      5. Make sure the response is valid JSON
      ''';

      final response = await gemini.text(prompt);
      if (response?.content?.parts?.first.text == null) {
        throw Exception('Empty response from API');
      }

      String jsonString = response!.content!.parts!.first.text!;

      // Clean up the response
      jsonString = jsonString.trim();
      
      // Remove any markdown code blocks if present
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
      }
      
      // Remove any non-JSON text before or after the JSON object
      final jsonMatch = RegExp(r'{[\s\S]*}').firstMatch(jsonString);
      if (jsonMatch == null) {
        throw Exception('No valid JSON found in response');
      }
      
      jsonString = jsonMatch.group(0)!;

      // Parse JSON
      final Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(jsonString);
      } catch (e) {
        print('Invalid JSON response: $jsonString');
        throw Exception('Invalid JSON format in response');
      }

      // Validate required fields
      if (!jsonData.containsKey('questions') || 
          !jsonData.containsKey('language') ||
          !jsonData.containsKey('subject') ||
          !jsonData.containsKey('material') ||
          !jsonData.containsKey('difficulty')) {
        throw Exception('Missing required fields in response');
      }

      return QuizModel.fromJson(jsonData);
    } catch (e) {
      print('Error generating quiz: $e');
      throw Exception('Failed to generate quiz: $e');
    }
  }
}