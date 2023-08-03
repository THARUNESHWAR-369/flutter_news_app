import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/screens.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter News App UI',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SearchScreen.routeName: (context) => const SearchScreen(),
        ArticleScreen.routeName: (context) => const ArticleScreen(),
      },
    );
  }
}
