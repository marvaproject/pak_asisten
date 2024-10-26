import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreenWidget extends StatefulWidget {
  @override
  _QuizScreenWidgetState createState() => _QuizScreenWidgetState();
}

class _QuizScreenWidgetState extends State<QuizScreenWidget> {
  int? selectedOption;
  double progress = 0.4;

  String toSentenceCase(String str) {
    if (str.isEmpty) return str;
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  Widget _tagContainer(String text) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF274688),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF274688),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              toSentenceCase("material"),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF274688),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _tagContainer("Language"),
                                  SizedBox(width: 16),
                                  _tagContainer("Subject"),
                                  SizedBox(width: 16),
                                  _tagContainer("Difficulty")
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Question 4 / 20",
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF274688),
                              ),
                            ),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF274688)),
                                minHeight: 8,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Question',
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF274688),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      ListView.builder(
                        itemCount: 4,
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
                                  setState(() {
                                    selectedOption = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: selectedOption == index
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
                                          [
                                            'Answer Option 1',
                                            'Answer Option 2',
                                            'Answer Option 3',
                                            'Answer Option 4'
                                          ][index],
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: selectedOption == index
                                                ? Colors.white
                                                : Color(0xFF274688),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        selectedOption == index
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: selectedOption == index
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
              padding: const EdgeInsets.only(bottom: 25, top: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: Theme.of(context).filledButtonTheme.style,
                  label: Text(
                    "Next",
                    style: GoogleFonts.lato(
                      color: Theme.of(context).textTheme.displayMedium?.color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.arrow_forward_rounded),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
