import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_text.dart';

// ignore: must_be_immutable
class CommonButton extends StatelessWidget {
  final String title;
  Function()? onPressed;
  final bool isTransparent;
  final bool isEnabled;
  final int? bgColor;
  final Color textColor;
  final Widget? icon;
  final double fontSize;
  final bool isLoading;
  final double horizontalPadding,vertcalPaddingM;
  CommonButton({super.key,required this.title,this.onPressed,this.isTransparent=false,this.bgColor,this.textColor=Colors.white,
  this.icon,this.horizontalPadding=0,this.vertcalPaddingM=3.2,this.fontSize=1.9,this.isEnabled=true,this.isLoading=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: isLoading || !isEnabled?null:onPressed,
        child: Container(
          width: horizontalPadding>0?null:double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: widthSpace(vertcalPaddingM),horizontal: horizontalPadding),
            decoration: BoxDecoration(
              color:!isEnabled?Colors.grey[400]: isTransparent?null:Color(bgColor??themeColor),
              borderRadius: BorderRadius.circular(12)
            ),
            child: isLoading
                ?const Center(child: SizedBox(width: 21,height: 21,child:
            CircularProgressIndicator(color: Colors.white,strokeWidth: 2)))
                :Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(icon!=null)...[
                  icon!,
                  SizedBox(width: widthSpace(2.5)),
                ],
                CustomText(
                    text:title,
                    fontSize: fontSize,
                    color:isTransparent?null:textColor,
                    weight: FontWeight.w500),
              ],
            )));
  }
}
