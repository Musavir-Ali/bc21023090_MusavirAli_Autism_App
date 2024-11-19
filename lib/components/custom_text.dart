
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? weight;
  final Color? color;
  final int? lines;
  final FontStyle? fontStyle;
  const CustomText({super.key,required this.text,this.fontSize=2,this.weight,this.color,this.lines,this.fontStyle});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: lines,
      style: TextStyle(
        fontSize: heightSpace(fontSize),
        color: color,
        fontWeight: weight,
        fontStyle: fontStyle
      ),
    );
  }
}
