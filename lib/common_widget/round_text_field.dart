import 'package:flutter/material.dart';
import 'package:meditate/common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? right;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const RoundTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText,
    this.right,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: TColor.txtBG,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(color: TColor.primaryText, fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          suffixIcon: right,
          hintStyle: TextStyle(color: TColor.secondaryText, fontSize: 16),
          errorStyle: TextStyle(
            fontSize: 12,
            height: 0.5,
          ),
        ),
      ),
    );
  }
}
