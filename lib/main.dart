import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/firebase_options.dart';
import 'package:meditate/screen/login/startup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditate/screen/main_tabview/main_tab_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(),
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
        useMaterial3: false,
      ),
      home: isLoggedIn ? MainTabViewScreen() : StartupScreen(),
    );
  }
}
