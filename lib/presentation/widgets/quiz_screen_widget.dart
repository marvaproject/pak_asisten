import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/presentation/widgets/quiz_result_widget.dart';
import 'package:provider/provider.dart';
import 'package:pak_asisten/presentation/providers/quiz_provider.dart';

class QuizScreenWidget extends StatefulWidget {
  @override
  _QuizScreenWidgetState createState() => _QuizScreenWidgetState();
}

class _QuizScreenWidgetState extends State<QuizScreenWidget> {
  int previousQuestionIndex =
      -1; // Untuk menyimpan indeks pertanyaan sebelumnya
  int? correctAnswerIndex;

  String toSentenceCase(String str) {
    if (str.isEmpty) return str;
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  Widget _tagContainer(BuildContext context, String text, IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quitPopup(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7, // 70% dari lebar layar
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar tinggi menyesuaikan konten
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 6),
              child: Text(
                'Do you want to quit? Your progress will be lost',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: Theme.of(context).outlinedButtonTheme.style,
                    child: Text("Cancel"),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: Theme.of(context).filledButtonTheme.style,
                    child: Text(
                      "Quit",
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
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final currentQuestion =
            quizProvider.quiz?.questions[quizProvider.currentQuestionIndex];
        final isLastQuestion = quizProvider.currentQuestionIndex ==
            (quizProvider.quiz?.questions.length ?? 0) - 1;
        final isFirstQuestion = quizProvider.currentQuestionIndex == 0;

        double progress = (quizProvider.currentQuestionIndex + 1) /
            (quizProvider.quiz?.questions.length ?? 1);

        void _finishQuiz() {
          final results = quizProvider.getQuizResults();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResultWidget(
                results: results,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => _quitPopup(context),
                                ),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  toSentenceCase(
                                      quizProvider.quiz?.material ?? ""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 0.5,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                child: StreamBuilder(
                                  stream: Stream.periodic(Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    final duration =
                                        quizProvider.getElapsedTime();
                                    return Text(
                                      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).dialogBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(149, 157, 165, 0.2),
                                  blurRadius: 24,
                                  spreadRadius: 0,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _tagContainer(
                                          context,
                                          quizProvider.quiz?.language ?? "",
                                          Icons.translate_rounded),
                                      SizedBox(width: 12),
                                      _tagContainer(
                                          context,
                                          quizProvider.quiz?.subject ?? "",
                                          Icons.book_rounded),
                                      SizedBox(width: 12),
                                      _tagContainer(
                                          context,
                                          quizProvider.quiz?.difficulty ?? "",
                                          Icons.trending_up_rounded),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Question ${quizProvider.currentQuestionIndex + 1} / ${quizProvider.quiz?.questions.length ?? 0}",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  currentQuestion!.question,
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          ListView.builder(
                            itemCount:
                                currentQuestion?.shuffledAnswers.length ?? 0,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Material(
                                  elevation: 8,
                                  shadowColor: Color(0x4C274688),
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      quizProvider.answerQuestion(index);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: quizProvider.userAnswers[
                                                    quizProvider
                                                        .currentQuestionIndex] ==
                                                index
                                            ? Color(0xFF274688)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Color(0xFF274688),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              currentQuestion?.shuffledAnswers[
                                                      index] ??
                                                  '',
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                                color: quizProvider.userAnswers[
                                                            quizProvider
                                                                .currentQuestionIndex] ==
                                                        index
                                                    ? Colors.white
                                                    : Color(0xFF274688),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            quizProvider.userAnswers[quizProvider
                                                        .currentQuestionIndex] ==
                                                    index
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: quizProvider.userAnswers[
                                                        quizProvider
                                                            .currentQuestionIndex] ==
                                                    index
                                                ? Colors.white
                                                : Color(0xFF274688),
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 25, top: 16, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isFirstQuestion) // Hanya tampilkan jika bukan halaman pertama
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                quizProvider.previousQuestion();
                              },
                              style: Theme.of(context).filledButtonTheme.style,
                              label: Text(
                                "Previous",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              icon: Icon(Icons.arrow_back_rounded),
                              iconAlignment: IconAlignment.start,
                            ),
                          ),
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ElevatedButton.icon(
                            onPressed: isLastQuestion
                                ? () {
                                    final quizProvider =
                                        Provider.of<QuizProvider>(context,
                                            listen: false);
                                    final results =
                                        quizProvider.getQuizResults();

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizResultWidget(
                                          results: results,
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    quizProvider.nextQuestion();
                                  },
                            style: Theme.of(context).filledButtonTheme.style,
                            label: Text(isLastQuestion ? "Finish" : "Next",
                                style:
                                    Theme.of(context).textTheme.displaySmall),
                            icon: Icon(Icons.arrow_forward_rounded),
                            iconAlignment: IconAlignment.end,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
