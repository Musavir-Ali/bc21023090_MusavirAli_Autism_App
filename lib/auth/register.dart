import 'package:autism_app/auth/login.dart';
import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/components/custom_textfield.dart';
import 'package:autism_app/helpers/auth_helper.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isPasswordVisible = false;
  String? selectedRole; // Hold the selected dropdown value

  void _togglePasswordView() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(widthSpace(viewPadding)),
          child: Column(
            children: [
              SizedBox(height: heightSpace(4)),
              Image.asset('assets/Support.png'),
              SizedBox(height: heightSpace(3.5)),
              const CustomText(
                text: 'Create your account',
                fontSize: 2.2,
                weight: FontWeight.bold,
              ),
              SizedBox(height: heightSpace(2)),
              CustomTextField(
                controller: AuthHelper.accountController.userName,
                hintText: 'Username',
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: heightSpace(1.5)),
              CustomTextField(
                controller: AuthHelper.accountController.password,
                hintText: 'Reenter Password',
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
                    if (value == null || value.isEmpty) {
                      return 'Renter your password';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: heightSpace(1.5)),
              DropdownButtonFormField<String>(
                value: selectedRole,
                hint: const CustomText(text: 'Select Role'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                    print(selectedRole);
                  });
                },
                items: ['Professional', 'User', 'Admin'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: heightSpace(3)),
              CommonButton(
                title: 'Continue',
                onPressed: () {
                  AuthHelper.signUp(
                    AuthHelper.accountController.userName.text,
                    AuthHelper.accountController.password.text,
                    selectedRole ?? '', // Add the missing third argument
                    // selectedRole ?? '', // Add the missing third argument
                  );
                },
                isLoading: AuthHelper.accountController.isLoading.value,
                bgColor: successColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
