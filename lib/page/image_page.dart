import 'package:flutter/material.dart';
import 'package:pak_asisten/custom_class/custom_icon_icons.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
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
                  label: Text("Download",
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.color)),
                  icon: Icon(CustomIcon.download),
                  iconAlignment: IconAlignment.end,
                  style: Theme.of(context).filledButtonTheme.style,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Share"),
                  icon: Icon(CustomIcon.share),
                  iconAlignment: IconAlignment.end,
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: "Unleash Your Imagination...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: OutlineInputBorder(
                      borderSide: Theme.of(context)
                          .inputDecorationTheme
                          .border!
                          .borderSide,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CustomIcon.send,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedIconTheme
                        ?.color,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
