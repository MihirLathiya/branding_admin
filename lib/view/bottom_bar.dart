import 'package:branding_add_post/controller/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  BottomBarController barController = Get.put(BottomBarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetBuilder<BottomBarController>(
        builder: (controller) {
          return Container(
            height: 70,
            width: Get.width,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.updateMenu(0);
                    },
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                      color: controller.selectMenu == 0
                          ? Colors.blue
                          : Colors.white,
                      child: Icon(
                        Icons.add,
                        color: controller.selectMenu == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.updateMenu(1);
                    },
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                      color: controller.selectMenu == 1
                          ? Colors.blue
                          : Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: controller.selectMenu == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: GetBuilder<BottomBarController>(
        builder: (controller) {
          return controller.screen[controller.selectMenu];
        },
      ),
    );
  }
}
