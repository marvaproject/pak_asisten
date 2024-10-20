import 'package:flutter/material.dart';
import 'package:pak_asisten/custom_class/custom_icon_icons.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 1, // Rasio 1:1 (persegi)
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(
                        0,
                        2,
                      ),
                    ),
                  ],
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Color(0xFFBBBBBB),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Open Camera",
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.color)),
                  icon: Icon(CustomIcon.camera),
                  iconAlignment: IconAlignment.end,
                  style: Theme.of(context).filledButtonTheme.style,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Upload Image"),
                  icon: Icon(CustomIcon.upload),
                  iconAlignment: IconAlignment.end,
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Recognized Text Result...",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              contentPadding: EdgeInsets.all(20),
              border: OutlineInputBorder(
                borderSide:
                    Theme.of(context).inputDecorationTheme.border!.borderSide,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextButton(
              onPressed: () {},
              style: Theme.of(context).filledButtonTheme.style,
              child: Text(
                "Generate",
                style: TextStyle(
                  color: Theme.of(context).textTheme.displayMedium?.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
