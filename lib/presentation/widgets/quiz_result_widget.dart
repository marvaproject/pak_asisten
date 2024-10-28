import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
import 'package:pak_asisten/core/utils/constants/quiz_grade_data.dart';
import 'package:pak_asisten/presentation/app.dart';
import 'package:pak_asisten/presentation/controllers/navigation_controller.dart';
import 'package:pak_asisten/presentation/providers/quiz_provider.dart';
import 'package:pak_asisten/presentation/widgets/quiz_capture_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QuizResultWidget extends StatefulWidget {
  final Map<String, dynamic> results;

  const QuizResultWidget({
    super.key,
    required this.results,
  });

  @override
  State<QuizResultWidget> createState() => _QuizResultWidgetState();
}

class _QuizResultWidgetState extends State<QuizResultWidget> {
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  final screenshotController = ScreenshotController();

  Widget _listResultContainer(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _tagContainer(String text, IconData icon) {
    return UnconstrainedBox(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
            SizedBox(width: 4),
            Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String toSentenceCase(String str) {
    if (str.isEmpty) return str;
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _shareResult() async {
    try {
      final Widget captureWidget = QuizCaptureWidget(
        results: widget.results,
        screenshotController: screenshotController,
      );

      final Uint8List? image = await screenshotController.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          Material(
            child: captureWidget,
          ),
        ),
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final imagePath = '${directory.path}/quiz_result_$timestamp.png';

        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Check out my quiz result!\n'
              'Score: ${widget.results['score'].toStringAsFixed(0)}\n'
              'Grade: ${widget.results['grade']}\n'
              '${widget.results['message']}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share result: $e')),
      );
    }
  }

  Future<void> _downloadResult() async {
    try {
      final Widget captureWidget = QuizCaptureWidget(
        results: widget.results,
        screenshotController: screenshotController,
      );

      final Uint8List? image = await screenshotController.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          Material(
            child: captureWidget,
          ),
        ),
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final imagePath = '${directory.path}/quiz_result_$timestamp.png';

        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Result saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download result: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color gradeColor =
        GradeData.gradeInfo[widget.results['grade']]!['color'] as Color;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 25, top: 16, left: 16, right: 16),
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withAlpha((0.25 * 255).toInt()),
                    ),
                    shape: BoxShape.circle),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 10,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withAlpha((0.5 * 255).toInt()),
                      ),
                      shape: BoxShape.circle),
                  child: Container(
                    padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        border: Border.all(
                          width: 8,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            widget.results['grade'], // Tampilkan grade
                            style: GoogleFonts.lato(
                              color: widget.results['grade'] == 'A+'
                                  ? Color(0xFF4CAF50)
                                  : Color(0xFF274688),
                              fontSize: 52,
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Score: ${widget.results['score'].toStringAsFixed(0)}",
                            style: GoogleFonts.lato(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
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
                widget.results['message'],
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(20),
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
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Statistics',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _listResultContainer(
                          'Total Questions',
                          widget.results['totalQuestions'].toString(),
                        ),
                        SizedBox(width: 16),
                        _listResultContainer(
                          'Total Duration',
                          formatDuration(widget.results['duration']),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _listResultContainer(
                          'Correct Answer',
                          widget.results['correctAnswers'].toString(),
                        ),
                        SizedBox(width: 16),
                        _listResultContainer(
                          'Wrong Answer',
                          widget.results['wrongAnswers'].toString(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: _listResultContainer(
                        'Not Answered',
                        widget.results['notAnswered'].toString(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tagContainer(widget.results['language'],
                            Icons.translate_rounded),
                        _tagContainer(
                            widget.results['subject'], Icons.book_rounded),
                        _tagContainer(
                            toSentenceCase(widget.results['material']),
                            Icons.article_rounded),
                        _tagContainer(widget.results['difficulty'],
                            Icons.trending_up_rounded),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _downloadResult,
                      label: Text("Download"),
                      icon: Icon(CustomIcon.download),
                      iconAlignment: IconAlignment.end,
                      style: Theme.of(context).outlinedButtonTheme.style,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _shareResult,
                      label: Text("Share"),
                      icon: Icon(CustomIcon.share),
                      iconAlignment: IconAlignment.end,
                      style: Theme.of(context).outlinedButtonTheme.style,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavBar(),
                      ),
                      (route) => false,
                    ).then((_) {
                      Provider.of<NavigationController>(context, listen: false)
                          .changeIndex(3);
                    });
                  },
                  style: Theme.of(context).filledButtonTheme.style,
                  child: Text(
                    "Return to Homepage",
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
    );
  }
}
