import 'package:autism_app/auth/login.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/controllers/homescreen_controller.dart';
import 'package:autism_app/helpers/auth_helper.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeScreenController homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      id: 'main',
      builder: (c) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (c.currentScreen.index == 0) {
            Get.dialog(AlertDialog(
              title: const Text('Are you sure you want to exit this application?'),
              actions: [
                TextButton(onPressed: Get.back, child: const Text('Cancel')),
                const ElevatedButton(
                  onPressed: SystemNavigator.pop,
                  child: Text('Yes'),
                ),
              ],
            ));
          } else {
            c.changeIndex(0);
          }
        },
        child: Scaffold(
          //extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(successColor),
            onPressed: () {
              Get.dialog(AlertDialog(
                title: const CustomText(
                  text: 'Are you sure you wanna logout?',
                ),
                actions: [
                  TextButton(
                      onPressed: Get.back,
                      child: const CustomText(
                        text: 'No',
                      )),
                  ElevatedButton(
                      child: const CustomText(
                        text: 'Yes',
                      ),
                      onPressed: () {
                        AuthHelper.accountController.userName.clear();
                        AuthHelper.accountController.password.clear();
                        Get.offAll(const Login());
                      }),
                ],
              ));
            },
            shape: const CircleBorder(),
            child: SvgPicture.asset(
              "assets/icons/logout.svg",
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            title: c.currentScreen.index == 0
                ? null
                : CustomText(
                    text: c.currentScreen.title,
                    fontSize: 2.4,
                    weight: FontWeight.bold,
                  ),
            actions: c.currentScreen.actions,
          ),
          body: c.listOfScreens[c.currentScreen.index].screenWidget,
          bottomNavigationBar: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            height: heightSpace(7.5),
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(
                c.listOfScreens.length + 1,
                (index) {
                  int i = index > 2 ? index - 1 : index;
                  if (index == 2) {
                    return const Expanded(child: SizedBox());
                  }
                  final screen = c.listOfScreens[i];
                  return Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => c.changeIndex(i),
                      child: Column(
                        children: [
                          c.currentScreen == screen
                              ? indicator
                              : const SizedBox(height: 6),
                          SizedBox(height: heightSpace(1.3)),
                          Builder(
                            builder: (context) {
                              // switch (AuthHelper.getUserType()) {
                              //   case UserType.admin:
                              return SvgPicture.asset(
                                '$dashboardAssetPath/${screen.index}.svg',
                                height: widthSpace(6),
                                color: c.currentScreen == screen
                                    ? const Color(successColor)
                                    : null,
                              );
                              // default:
                              //   return const SizedBox.shrink();
                              //}
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator = Container(
    width: widthSpace(9),
    height: 6,
    decoration: const BoxDecoration(
      color: Color(successColor),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
    ),
  );
}
