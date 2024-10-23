import 'package:flutter/material.dart';
import 'package:pak_asisten/presentation/widgets/translate_widget.dart';

class RewordPage extends StatefulWidget {
  const RewordPage({super.key});

  @override
  State<RewordPage> createState() => _RewordPageState();
}

class _RewordPageState extends State<RewordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(99, 99, 99, 0.2),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),
                  child: TranslateWidget(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(99, 99, 99, 0.2),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
