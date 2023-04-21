import 'package:branding_add_post/controller/add_post_controller.dart';
import 'package:branding_add_post/view/add_post_screen.dart';
import 'package:branding_add_post/view/edit_post_screen.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  int selectMenu = 0;
  List screen = [AddPostScreen(), EditPostScreen()];

  updateMenu(int index) {
    selectMenu = index;
    update();
  }
}
