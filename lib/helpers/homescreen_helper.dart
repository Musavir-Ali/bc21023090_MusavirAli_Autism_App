
import 'package:autism_app/controllers/homescreen_controller.dart';
import 'package:get/instance_manager.dart';


class HomeScreenHelper {
  static final HomeScreenHelper _singleton = HomeScreenHelper._internal();

 static HomeScreenController c =Get.isRegistered() ?
  Get.find<HomeScreenController>() : Get.put(HomeScreenController());



  factory HomeScreenHelper() {
    c = Get.put(HomeScreenController(),permanent: true);
    return _singleton;
  }

  HomeScreenHelper._internal();
}
