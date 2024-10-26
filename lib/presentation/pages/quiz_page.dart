import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final bool _isGenerating = false;

  final List<String> _languages = [
    'Indonesian',
    'English',
    'Arabic',
    'Japanese',
    'Korean',
    'Chinese',
    'Russian',
    'Turkish',
    'Malay',
    'Thai',
    'Javanese',
    'Sundanese',
  ];

  final List<String> _subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'Geography',
    'Computer Science',
    'Literature',
    'Art History',
    'Economics',
    'Psychology',
    'Sociology',
    'Environmental Science',
    'Astronomy',
    'Statistics',
    'Philosophy',
    'Political Science',
    'Music Theory',
    'Physical Education',
    'Health Education',
    'Engineering',
    'Linguistics',
    'Civics',
    'Business Studies',
    'Information Technology'
  ];

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];

  final List<String> _questionCounts = ['5', '10', '15', '20', '25', '30'];

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

  @override
  Widget build(BuildContext context) {
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
                            child: _buildConstrainedDropdown(
                              value: _selectedLanguage,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedLanguage = newValue;
                                });
                              },
                              items: _languages,
                              hint: 'Language',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildConstrainedDropdown(
                              value: _selectedSubject,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSubject = newValue;
                                });
                              },
                              items: _subjects,
                              hint: 'Subject',
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
                          hintStyle:
                              GoogleFonts.lato(color: Colors.grey, fontSize: 14),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton(
                    onPressed: () {},
                    style: Theme.of(context).filledButtonTheme.style,
                    child: Text(
                      _isGenerating ? "Generating..." : "Generate Quiz",
                      style: GoogleFonts.lato(
                        color: Theme.of(context).textTheme.displayMedium?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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
