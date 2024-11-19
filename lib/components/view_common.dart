import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ViewsCommon{
  static List<BoxShadow> boxShadow = [
    const BoxShadow(
      color: Colors.black12,
      spreadRadius: .2,
      blurRadius: 2,
      offset: Offset(0, 2),
    )
  ];
  static showModalBottom(Widget child,{double radius=30,Function(dynamic)? then}){
    Get.bottomSheet(
      backgroundColor:Colors.white,
        SizedBox(
          height: Get.height * .5,
          child: BottomSheet(
            showDragHandle: true,
            dragHandleColor: Colors.black,
            dragHandleSize: const Size(50, 7),
            backgroundColor: Colors.white,
            onClosing:(){},
            builder: (c) => child),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius))),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true,

    ).then(then??(_){});
  }

}