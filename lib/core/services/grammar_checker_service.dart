import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pak_asisten/core/config/env/env.dart';

class GrammarCheckerService {
  final String _apiUrl = 'https://api-inference.huggingface.co/models/pszemraj/flan-t5-large-grammar-synthesis';
  final String _apiKey = Env.huggingfaceApiKey;

  Future<String> checkGrammar(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'inputs': text,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);
        if (result.isNotEmpty && result[0] is Map<String, dynamic>) {
          return result[0]['generated_text'] as String;
        }
        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to check grammar: ${response.statusCode}');
      }
    } catch (e) {
      print("Error in checkGrammar: $e");
      rethrow; // Melempar kembali error untuk ditangani di widget
    }
  }
}