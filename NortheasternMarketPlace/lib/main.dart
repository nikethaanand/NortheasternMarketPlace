// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// new
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// new
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // new
import 'package:firebase_core/firebase_core.dart';
// new
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // This change ensures the app to stay portrait up and prevents some possible crash
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider(
      // create: (context) => ApplicationState(),
      create: (context) => UserProvider(),
      builder: ((context, child) => const App()),
    ));
  });
}

// app class calls login which is the first page
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(212, 221, 9, 44)),
      ),
      ///loginpage is called 
      home: LoginPage(),
    );
  }
}
