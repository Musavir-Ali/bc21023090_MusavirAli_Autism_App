import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class CommonCheckbox extends StatelessWidget {
  final bool isChecked;
  final String title;
  final Color? checkedColor;
  final VoidCallback onChecked;

  const CommonCheckbox({
    super.key,
    required this.isChecked,
    required this.title,
    this.checkedColor,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChecked,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(widthSpace(1.2)),
            decoration: BoxDecoration(
              color: isChecked ? (checkedColor ?? const Color(themeColor)) : null,
              border: isChecked ? null : Border.all(color: const Color(borderColor)),
              borderRadius: BorderRadius.circular(7),
            ),
            child: isChecked
                ? const Icon(Icons.check, color: Colors.white, size: 19)
                : const SizedBox(width: 19, height: 19),
          ),
          SizedBox(width: widthSpace(3)),
          CustomText(text: title, fontSize: 1.9),
        ],
      ),
    );
  }
}
