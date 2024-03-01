// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "package:flutter/material.dart";

class PlayerUI extends StatelessWidget {
  const PlayerUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Music Image
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: FractionallySizedBox(
            heightFactor: 0.3,
            widthFactor: 0.6,
            child: Container(
              color: Colors.red,
            ),
          ),
        ),

        Column(
          children: [Text("Name"), Text("Artist")],
        ),

        Column(
          children: [
            LinearProgressIndicator(
              value: 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Current Time"), Text("End Time")],
            )
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.skip_previous),
            Icon(Icons.pause_circle_filled_rounded),
            Icon(Icons.skip_next)
          ],
        )
      ],
    );
  }
}
