import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/utils/constants/quiz_input_data.dart';
import 'package:pak_asisten/presentation/providers/quiz_provider.dart';
import 'package:pak_asisten/presentation/widgets/quiz_screen_widget.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? _selectedLanguage;
  String? _selectedSubject;
  String? _selectedDifficulty;
  String? _selectedQuestionCount;
  final TextEditingController _materialController = TextEditingController();
  bool _isGenerating = false;

  final List<Map<String, String>> _languages = QuizInputData.languages;
  final List<Map<String, String>> _subjects = QuizInputData.subjects;
  final List<String> _difficulties = QuizInputData.difficulties;
  final List<String> _questionCounts = QuizInputData.questionCounts;

  bool get _isFormComplete {
    return _selectedLanguage != null &&
        _selectedSubject != null &&
        _selectedDifficulty != null &&
        _selectedQuestionCount != null &&
        _materialController.text.isNotEmpty;
  }

  Widget _buildConstrainedDropdown({
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            hint,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Theme.of(context).textTheme.displayLarge!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Color(0xFF274688), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Color(0x4C274688),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  'Select $hint',
                  style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                onChanged: onChanged,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF274688)),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Color(0xFF274688),
                  fontWeight: FontWeight.bold,
                ),
                borderRadius: BorderRadius.circular(25),
                dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                menuMaxHeight: MediaQuery.of(context).size.height * 0.6,
                itemHeight: 50,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      constraints: BoxConstraints(minWidth: 120),
                      child: Text(
                        value,
                        style: GoogleFonts.lato(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmojiDropdown({
    required String? value,
    required Function(String?) onChanged,
    required List<Map<String, String>> items,
    required String hint,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            hint,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Theme.of(context).textTheme.displayLarge!.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Color(0xFF274688), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Color(0x4C274688),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  'Select $hint',
                  style: GoogleFonts.lato(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onChanged: onChanged,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF274688)),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Color(0xFF274688),
                  fontWeight: FontWeight.bold,
                ),
                borderRadius: BorderRadius.circular(25),
                dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                items: items
                    .map<DropdownMenuItem<String>>((Map<String, String> item) {
                  return DropdownMenuItem<String>(
                    value: item['name'],
                    child: Row(
                      children: [
                        Text(
                          item['emoji']!,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['name']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Color(0xFF274688),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _generateQuiz() async {
    // Validasi input
    if (_selectedLanguage == null ||
        _selectedSubject == null ||
        _selectedDifficulty == null ||
        _selectedQuestionCount == null ||
        _materialController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Mencegah multiple generate
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);

      await quizProvider.generateQuiz(
        language: _selectedLanguage!,
        subject: _selectedSubject!,
        material: _materialController.text,
        difficulty: _selectedDifficulty!,
        questionCount: _selectedQuestionCount!,
      );

      if (!mounted) return;

      if (quizProvider.error == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreenWidget(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(quizProvider.error!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate quiz: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<QuizProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Quiz Generation',
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(149, 157, 165, 0.2),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: Offset(
                            0,
                            8,
                          ),
                        ),
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildEmojiDropdown(
                              value: _selectedLanguage,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedLanguage = newValue;
                                });
                              },
                              items: _languages,
                              hint: 'Language',
                              context: context,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: buildEmojiDropdown(
                              value: _selectedSubject,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSubject = newValue;
                                });
                              },
                              items: _subjects,
                              hint: 'Subject',
                              context: context,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildConstrainedDropdown(
                              value: _selectedDifficulty,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDifficulty = newValue;
                                });
                              },
                              items: _difficulties,
                              hint: 'Difficulty',
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: _buildConstrainedDropdown(
                              value: _selectedQuestionCount,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedQuestionCount = newValue;
                                });
                              },
                              items: _questionCounts,
                              hint: 'Number of Questions',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          "Material or Topic",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _materialController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter material or topic',
                          hintStyle: GoogleFonts.lato(
                              color: Colors.grey, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          fillColor: Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withAlpha((0.5 * 255).toInt()),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .border!
                                    .borderSide
                                    .color,
                                width: 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .border!
                                    .borderSide
                                    .color,
                                width: 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                if (_isFormComplete)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: _generateQuiz,
                      style: Theme.of(context).filledButtonTheme.style,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isGenerating)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.color ??
                                        Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            _isGenerating ? "Generating..." : "Generate Quiz",
                            style: GoogleFonts.lato(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.color,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _materialController.dispose();
    super.dispose();
  }
}
