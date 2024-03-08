// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:music/pages/list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: requestStoragePermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for permission result
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle any errors
              return Scaffold(body: Center(child: Text('Error occurred')));
            } else {
              // Permission granted or denied
              if (snapshot.data == true) {
                return PlayerUI();
              } else {
                return Scaffold(body: Center(child: Text('Permission denied')));
              }
            }
          },
        ),
      ),
    );
  }
}
