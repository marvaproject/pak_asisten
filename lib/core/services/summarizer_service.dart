import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pak_asisten/core/config/env/env.dart';

class SummarizerService {
  static const String _huggingFaceToken = Env.huggingfaceApiKey;
  static const String _bartApiUrl = 'https://api-inference.huggingface.co/models/facebook/bart-large-cnn';

  static Future<String> summarizeText(String text, String language) async {
    try {
      if (language.toLowerCase() == 'english') {
        return await _summarizeWithBART(text);
      } else {
        throw Exception('Unsupported language: $language');
      }
    } catch (e) {
      throw Exception('Error in summarization: $e');
    }
  }

  static Future<String> _summarizeWithBART(String text) async {
    final response = await http.post(
      Uri.parse(_bartApiUrl),
      headers: {
        'Authorization': 'Bearer $_huggingFaceToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'inputs': text,
        'parameters': {
          'max_length': 300,
          'min_length': 100,
          'length_penalty': 2.0,
          'num_beams': 4,
          'early_stopping': false,
        }
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && data[0].containsKey('summary_text')) {
        return data[0]['summary_text'];
      } else {
        throw Exception('Unexpected response format from BART API');
      }
    } else {
      throw Exception('Failed to summarize text with BART: ${response.body}');
    }
  }
}