import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/common_widget/round_button.dart';
import 'package:meditate/common_widget/round_text_field.dart';
import 'package:meditate/screen/home/welcome_screen.dart';
import 'package:meditate/screen/login/sign_up_screen.dart';

import 'authentication_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(
                      "assets/images/login_top2.png",
                      width: double.maxFinite,
                      fit: BoxFit.fitWidth,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context.pop();
                                },
                                child: Image.asset(
                                  "assets/images/back.png",
                                  width: 55,
                                  height: 55,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "ยินดีต้อนรับ การกลับมา!",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MaterialButton(
                            onPressed: () async {
                              final userCredential =
                                  await AuthenticationHelper()
                                      .signInWithGoogle();

                              if (!context.mounted) return;

                              if (userCredential != null) {
                                context.push(const WelcomeScreen());
                              }
                            },
                            minWidth: double.maxFinite,
                            elevation: 0,
                            color: Colors.white,
                            height: 60,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: TColor.tertiary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 25,
                                  height: 25,
                                ),
                                Expanded(
                                  child: Text(
                                    "CONTINUE WITH GOOGLE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Text(
                  "เข้าสู่ระบบด้วยอีเมล",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 35),
                RoundTextField(
                  hintText: "อีเมล",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกอีเมลของคุณ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                RoundTextField(
                  hintText: "รหัสผ่าน",
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่านของคุณ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(title: "เข้าสู่ระบบ", onPressed: _logInUser),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "สร้างบัญชีใหม่ ?",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(const SignUpScreen());
                      },
                      child: Text(
                        "ลงทะเบียน",
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logInUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String result = await AuthenticationHelper().logInUser(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (result == 'success') {
        if (!mounted) return;
        context.push(const WelcomeScreen());
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('การเข้าสู่ระบบไม่สำเร็จ')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาแก้ไขข้อผิดพลาดที่อยู่ด้านบน')),
      );
    }
  }
}
