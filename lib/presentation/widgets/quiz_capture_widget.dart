// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';


class QuizCaptureWidget extends StatelessWidget {
    final Map<String, dynamic> results;
  final ScreenshotController screenshotController;

  const QuizCaptureWidget({
    super.key,
    required this.results,
    required this.screenshotController,
  });

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _listTitleContainer(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF274688),
          ),
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF274688),
          ),
        ),
      ],
    );
  }

  Widget _listResultContainer(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF274688),
          ),
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF274688),
          ),
        ),
      ],
    );
  }

  String toSentenceCase(String str) {
    if (str.isEmpty) return str;
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  Map<String, String> formatDateTime() {
    final now = DateTime.now();
    final time = DateFormat('hh:mm a').format(now);
    final date = DateFormat('MMM. dd, yyyy').format(now);
    return {'time': time, 'date': date};
  }

  @override
  Widget build(BuildContext context) {
final dateTime = formatDateTime();

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Color(0xFFF4F8FF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: 8, bottom: 16, right: 8, left: 8),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color(0xFF274688).withAlpha((0.25 * 255).toInt()),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: Offset(
                              0,
                              4,
                            ),
                          ),
                        ]),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 14,
                                color: Color(0xFF274688)
                                    .withAlpha((0.25 * 255).toInt()),
                              ),
                              shape: BoxShape.circle),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 10,
                                  color: Color(0xFF274688)
                                      .withAlpha((0.5 * 255).toInt()),
                                ),
                                shape: BoxShape.circle),
                            child: Container(
                              padding: EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 8,
                                    color: Color(0xFF274688),
                                  ),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      results['grade'],
                                      style: GoogleFonts.lato(
                                        color: results['grade'] == 'A+'
                                            ? Color(0xFF4CAF50)
                                            : Color(0xFF274688),
                                        fontSize: 52,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Score: ${results['score'].toStringAsFixed(0)}",
                                      style: GoogleFonts.lato(
                                        color: Color(0xFF274688),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Perfect! You're absolutely brilliant!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              color: Color(0xFF274688),
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Statistics',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF274688),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _listResultContainer('Total Questions',
                                      results['totalQuestions'].toString()),
                                  SizedBox(width: 16),
                                  _listResultContainer('Total Duration',
                                      formatDuration(results['duration'])),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _listResultContainer('Correct Answer',
                                      results['correctAnswers'].toString()),
                                  SizedBox(width: 16),
                                  _listResultContainer('Wrong Answer',
                                      results['wrongAnswers'].toString()),
                                ],
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: _listResultContainer('Not Answered',
                                    results['notAnswered'].toString()),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:
                              _listTitleContainer('Material', toSentenceCase(results['material'])),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _listTitleContainer('Subject', toSentenceCase(results['subject'])),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child:
                                    _listTitleContainer('Language', toSentenceCase(results['language']))),
                            Expanded(
                                child:
                                    _listTitleContainer('Difficulty', toSentenceCase(results['difficulty'])))
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _listTitleContainer('Time', dateTime['time']!)),
                            Expanded(
                              child: _listTitleContainer('Date', dateTime['date']!),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'From',
                        style: GoogleFonts.lato(
                          color: Color(0xFF274688),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Center(
                        child: SvgPicture.asset(
                          'assets/logo/LightLogoAppBar.svg',
                          height: 14,
                          color: Color(0xFF274688),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
