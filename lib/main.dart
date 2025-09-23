import 'package:ayursutra_app/pages/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color secondaryDark = Color(0xFF0F172A);

    return MaterialApp(
      title: 'Ayursutra App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: pureWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: pureWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: secondaryDark),
          toolbarTextStyle: TextStyle(color: secondaryDark),
          titleTextStyle: TextStyle(color: secondaryDark),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
