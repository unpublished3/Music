// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music/pages/home.dart';
import 'package:music/providers/files_provider.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_status_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:music/utils/directory_selector.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

import 'package:provider/provider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.music.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PlayerProvider()),
    ChangeNotifierProvider(create: (context) => MetadataProvider()),
    ChangeNotifierProvider(create: (context) => FilesProvider()),
    ChangeNotifierProvider(create: (context) => PlaylistProvider()),
    ChangeNotifierProvider(create: (context) => PlayerStatusProvider()),
  ], child: MyApp()));
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

  ThemeData darkThemeData = ThemeData(
      colorScheme: ColorScheme.dark(
          background: Color.fromARGB(255, 23, 19, 19).withOpacity(0.7),
          brightness: Brightness.dark));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      home: Platform.isAndroid
          ? FutureBuilder<bool>(
              future: requestStoragePermission(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while waiting for permission result
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle any errors
                  return Scaffold(
                      body: Center(child: Text('Error occurred main')));
                } else {
                  // Permission granted or denied
                  if (snapshot.data == true) {
                    return Home(
                      directory: "/storage/emulated/0/Download",
                    );
                  } else {
                    return Scaffold(
                        body: Center(child: Text('Permission denied')));
                  }
                }
              },
            )
          : Scaffold(
              body: FutureBuilder<String>(
                future: selectDirectory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for permission result
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle any errors
                    return Scaffold(
                        body: Center(child: Text('Error occurred main')));
                  } else {
                    String directory = snapshot.data ?? "@!!cancelled!!@";
                    if (directory != "@!!cancelled!!@") {
                      return Home(
                        directory: directory,
                      );
                    } else {
                      return Scaffold(body: Center(child: Text('Cancelledx`')));
                    }
                  }
                },
              ),
            ),
    );
  }
}
