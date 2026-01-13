import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xffd8b76c); // BTN_Color
  static Color get secondary => const Color(0xff3F414E); // ที่เลือกวัน
  static Color get tertiary => const Color(0xffEBEAEC); // สีปุ่มขาว

  static Color get primaryText => const Color(0xff3F414E); // สีตัวอักษรหลัก
  static Color get primaryTextW => const Color(0xffF6F1FB); // สีตัวอักษรสีขาว
  static Color get secondaryText => const Color(0xffA1A4B2); // สีตัวอักษรในช่อง
  static Color get txtBG => const Color(0xffF2F3F7); // พื้นหลังเวลาใส่ข้อความ
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  Future push(Widget widget) async {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void pop() async {
    return Navigator.pop(this);
  }
}

extension HexColor on Color {
  static Color formHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst("#", ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
