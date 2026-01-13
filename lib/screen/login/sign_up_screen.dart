import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';
import 'package:meditate/common_widget/round_button.dart';
import 'package:meditate/common_widget/round_text_field.dart';
import 'package:meditate/screen/login/login_screen.dart';

import 'authentication_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isTrue = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();

  String? _email;
  String? _password;

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
                          "สร้างบัญชีของคุณ",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Spacer(),
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
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 20),
                RoundTextField(
                  hintText: "รหัสผ่าน",
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่านของคุณ';
                    } else if (_passwordController.text !=
                        _repasswordController.text) {
                      return 'รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 20),
                RoundTextField(
                  hintText: "ยืนยันรหัสผ่าน",
                  obscureText: true,
                  controller: _repasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกยืนยันรหัสผ่านของคุณ';
                    } else if (_passwordController.text !=
                        _repasswordController.text) {
                      return 'รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                RoundButton(title: "เริ่มต้นใช้งาน", onPressed: _signUp),
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
    _repasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Logging in the user w/ Firebase
      String result = await AuthenticationHelper().signUpUser(
        email: _email,
        password: _password,
      );
      if (result != 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.toString())));
      } else {
        if (!mounted) return;
        context.push(const LoginScreen());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาแก้ไขข้อผิดพลาดที่อยู่ด้านบน')),
      );
    }
  }
}
