import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/common_widget/round_button.dart';
import 'package:meditate/screen/login/login_screen.dart';
import 'package:meditate/screen/login/sign_up_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/starup_top2.png",
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
          const Spacer(),
          Text(
            "จิตที่ฝึกดีแล้ว นำสุขมาให้",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '''ให้เวลากับการพัฒนาจิตของตน \n ผ่านการฝึกสติและสมาธิ ในชีวิตประจำวัน''',
            textAlign: TextAlign.center,
            style: TextStyle(color: TColor.secondaryText, fontSize: 18),
            softWrap: true,
          ),
          const Spacer(),
          RoundButton(
            title: "ลงทะเบียนบัญชีใหม่",
            onPressed: () {
              context.push(const SignUpScreen());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "มีบัญชีอยู่แล้วหรือไม่ ?",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(const LoginScreen());
                },
                child: Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
