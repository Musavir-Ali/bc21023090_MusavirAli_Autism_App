import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double? padding;
  final TextInputType? textInputType;
  final int? lines;
  final bool forceBorder;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.padding,
    this.textInputType,
    this.lines = 1,
    this.obscureText = false,
    this.forceBorder = false,
    this.readOnly = false,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      maxLines: lines,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      readOnly: readOnly,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        filled: fillColor != null,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: padding != null ? EdgeInsets.all(widthSpace(padding)) : null,
        prefixIconConstraints: BoxConstraints.tightForFinite(
          width: widthSpace(12),
          height: widthSpace(5),
        ),
        suffixIconConstraints: BoxConstraints.tightForFinite(
          width: widthSpace(14),
          height: widthSpace(8),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: border(),
        focusedBorder: border(),
        errorBorder: errorBorder(),
        focusedErrorBorder: errorBorder(),
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: BorderSide(color: Colors.red[900]!),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: fillColor == null || forceBorder
          ? const BorderSide(color: Color(borderColor))
          : BorderSide.none,
    );
  }
}
