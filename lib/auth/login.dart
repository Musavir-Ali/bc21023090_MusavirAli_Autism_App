import 'package:autism_app/auth/register.dart';
import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/components/common_checkbox.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/components/custom_textfield.dart';
import 'package:autism_app/helpers/auth_helper.dart';
import 'package:autism_app/screens/caregiver.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // _loadCredentials();
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    bool? remember = prefs.getBool('rememberMe') ?? false;

    if (remember) {
      AuthHelper.accountController.userName.text = username ?? '';
      AuthHelper.accountController.password.text = password ?? '';
      setState(() {
        rememberMe = true;
      });
    }
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('username', AuthHelper.accountController.userName.text);
      await prefs.setString('password', AuthHelper.accountController.password.text);
      await prefs.setBool('rememberMe', rememberMe);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.remove('rememberMe');
    }
  }

  void _toggleRememberMe() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _login() async {
    if (AuthHelper.accountController.loginKey.currentState?.validate() ?? false) {
      await AuthHelper.login(
        AuthHelper.accountController.userName.text,
        AuthHelper.accountController.password.text,
      );
      //_saveCredentials();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(widthSpace(viewPadding)),
          child: Form(
            key: AuthHelper.accountController.loginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightSpace(4)),
                //SvgPicture.asset('assets/icons/logo1.svg'),
                Image.asset('assets/Support.png'),
                SizedBox(height: heightSpace(3.5)),
                const CustomText(text: 'Login to your account', fontSize: 2.1, weight: FontWeight.bold),
                SizedBox(height: heightSpace(3)),
                CustomTextField(
                  controller: AuthHelper.accountController.userName,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  prefixIcon: SvgPicture.asset('assets/icons/email.svg'),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      AuthHelper.accountController.userName.clear();
                    },
                  ),
                  validator: (value) {
                    if (value?.isNotEmpty == true) {
                      return null;
                    }
                    return 'This field must not be Empty';
                  },
                ),
                SizedBox(height: heightSpace(1.5)),
                CustomTextField(
                  controller: AuthHelper.accountController.password,
                  hintText: 'Password',
                  obscureText: !_isPasswordVisible,
                  prefixIcon: SvgPicture.asset('assets/icons/key.svg'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordView,
                  ),
                  validator: (value) {
                    if (AuthHelper.accountController.isLoginAction) {
                      // Validate password only if it's a login action
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: heightSpace(3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonCheckbox(
                      isChecked: rememberMe,
                      title: 'Remember me',
                      checkedColor: const Color(successColor),
                      onChecked: _toggleRememberMe,
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: heightSpace(3)),

                Obx(
                  () => CommonButton(
                    title: 'Log In',
                    onPressed: () {
                      AuthHelper.login(
                        AuthHelper.accountController.userName.text,
                        AuthHelper.accountController.password.text,
                      );
                    },
                    isLoading: AuthHelper.accountController.isLoading.value,
                    bgColor: successColor,
                  ),
                ),
                SizedBox(height: heightSpace(3)),
                TextButton(
                  onPressed: () {
                    Get.to(CaregiverDonation());
                  },
                  child: const CustomText(
                    text: "Click here if you're a caregiver",
                    fontSize: 1.8,
                    color: Colors.blue,
                    weight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: heightSpace(10)),
                BottomAppBar(
                  color: Colors.transparent,
                  child: TextButton(
                    onPressed: () {
                      Get.to(const Register());
                    },
                    child: const CustomText(
                      text: "Register Now!",
                      fontSize: 1.8,
                      color: Colors.black,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
                //  SizedBox(height: heightSpace(1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
//   void _forgotPassword() {
//   if (AuthHelper.accountController.userName.text.isEmpty) {
//     Get.snackbar("Validation Error", "Please enter your email address.");
//   } else {
//     AuthHelper.resetPassword(AuthHelper.accountController.userName.text);
//   }
// }
}
