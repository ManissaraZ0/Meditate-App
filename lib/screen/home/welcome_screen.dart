import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/common_widget/round_button.dart';
import 'package:meditate/screen/main_tabview/main_tab_view_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffd159),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            "assets/images/welcome.png",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "สวัสดี, คุณ ${user?.displayName ?? user?.email ?? 'Guest'}",
                    style: TextStyle(
                      color: TColor.primaryTextW,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "to Samma Sati",
                    style: TextStyle(color: TColor.primaryTextW, fontSize: 22),
                  ),
                  const SizedBox(height: 25),
                  const Spacer(),
                  RoundButton(
                    title: "เริ่มต้นใช้งาน",
                    type: RoundButtonType.secondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainTabViewScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
