import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/helpers/auth_helper.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';



class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   AuthHelper.startResendEmailTimer();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(widthSpace(viewPadding)),
        child: Column(
          children: [
            SizedBox(height: heightSpace(20)),
            const CustomText(
              text: 'Enter verification Code',
              fontSize: 2.3,
              weight: FontWeight.bold,
            ),
            SizedBox(height: heightSpace(4)),
            Text.rich(
              TextSpan(
                text: 'We sent code to ',
                style: TextStyle(fontSize: heightSpace(1.8), color: Colors.black54),
                children: <InlineSpan>[
                  TextSpan(
                    text: AuthHelper.accountController.userName.text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: ' for the verification process',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightSpace(5)),
            OtpTextField(
              numberOfFields: 6,
              onSubmit: (value) {
                AuthHelper.accountController.otp = value;
              },
              borderRadius: BorderRadius.circular(10),
              margin: EdgeInsets.symmetric(horizontal: widthSpace(2)),
              contentPadding: EdgeInsets.all(widthSpace(1.5)),
              focusedBorderColor: const Color(themeColor),
              textStyle: const TextStyle(color: Color(themeColor)),
              showFieldAsBox: true,
              onCodeChanged: (value) {
                AuthHelper.accountController.otp = value;
              },
            ),
            const Spacer(),
            Obx(
              () => CommonButton(
                title: 'Verify Account',
                //onPressed: AuthHelper.submitOtp,
                isLoading: AuthHelper.accountController.isLoading.value,
                bgColor: successColor,
              ),
            ),
            SizedBox(height: heightSpace(1)),
            Obx(
              () => CommonButton(
                title: AuthHelper.accountController.canResend.value
                    ? 'Resend Email'
                    : 'Resend Email (${AuthHelper.accountController.resendCounter.value}s)',
                isTransparent: true,
                // onPressed: AuthHelper.accountController.canResend.value
                //     ? AuthHelper.resendOtp
                //     : null,
                isLoading: AuthHelper.accountController.isResendLoading.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
