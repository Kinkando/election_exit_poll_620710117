import 'package:election_exit_poll_620710117/pages/home/home_page.dart';
import 'package:election_exit_poll_620710117/pages/result/result_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.prompt().fontFamily,
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline5: TextStyle(
            fontSize: 24.0,
            color: Colors.white,
          ),
          headline6: TextStyle(
            fontSize: 22.0,
            //fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
          ),
          bodyText2: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ResultPage.routeName: (context) => const ResultPage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}