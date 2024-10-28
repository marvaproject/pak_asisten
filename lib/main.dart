import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:pak_asisten/core/config/env/env.dart';
import 'package:pak_asisten/core/theme/theme_provider.dart';
import 'package:pak_asisten/core/utils/error_handler.dart';
import 'package:pak_asisten/presentation/app.dart';
import 'package:pak_asisten/presentation/controllers/navigation_controller.dart';
import 'package:pak_asisten/presentation/providers/quiz_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NavigationController()),
        ChangeNotifierProvider(create: (_) => QuizProvider())
      ],
      child: PakAsisten(),
    ),
  );

  ErrorHandler.runWithTry(() {
    WidgetsFlutterBinding.ensureInitialized();
    Gemini.init(apiKey: Env.geminiApiKey);
  });
}