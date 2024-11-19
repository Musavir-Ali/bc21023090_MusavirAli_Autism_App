import 'package:autism_app/auth/login.dart';
import 'package:autism_app/controllers/firebase_messaging_controller.dart';
import 'package:autism_app/controllers/homescreen_controller.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  Get.put(FirebaseMessagingController()); 
  await GetStorage.init();
  Get.put(HomeScreenController()); 
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) {
      const Text('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig(constraints);
        return GetMaterialApp(
          title: 'ASC - Autism Support Companion',
          theme: ThemeData(
            primaryColor: const Color(themeColor),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(themeColor),
              background: Colors.white,
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.white,
            ),
            dividerTheme: const DividerThemeData(
              thickness: .7,
            ),
            useMaterial3: true,
          ),
          home: const Login(),
        );
      },
    );
  }
}
