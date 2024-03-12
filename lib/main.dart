// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:music/pages/mobile_home.dart';
import 'package:music/providers/player_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

import 'package:music/utils/find_music_directory.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  final mp3Files = findMp3Files();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayerProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Platform.isAndroid
              ? FutureBuilder<bool>(
                  future: requestStoragePermission(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator while waiting for permission result
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle any errors
                      return Scaffold(
                          body: Center(child: Text('Error occurred')));
                    } else {
                      // Permission granted or denied
                      if (snapshot.data == true) {
                        return MobileHome();
                      } else {
                        return Scaffold(
                            body: Center(child: Text('Permission denied')));
                      }
                    }
                  },
                )
              : Placeholder(),
        ),
      ),
    );
  }
}
