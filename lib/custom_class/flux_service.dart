import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:pak_asisten/env/env.dart';

class FluxService {
  static const String _apiUrl = 'https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-schnell';
  static const String _apiKey = Env.huggingfaceApiKey;
  Future<Uint8List?> generateImage(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'inputs': prompt}),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}