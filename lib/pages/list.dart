// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ListUI extends StatelessWidget {
  const ListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 0),
      child: Container(
        padding: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Column(
                    children: [Text("Music"), Text("Artist")],
                  ),
                )
              ],
            ),
            Text("Length")
          ],
        ),
      ),
    );
  }
}
