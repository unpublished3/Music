// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import "package:flutter/material.dart";

class PlayerUI extends StatelessWidget {
  PlayerUI({super.key});
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Music Image
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
          ),

          Column(
            children: [Text("Name"), Text("Artist")],
          ),

          Column(
            children: [
              Slider(
                onChanged: (double a) {},
                value: 0,
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
              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              Icon(Icons.skip_next)
            ],
          )
        ],
      ),
    );
  }
}
