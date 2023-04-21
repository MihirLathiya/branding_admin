import 'package:branding_add_post/controller/add_post_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen>
    with SingleTickerProviderStateMixin {
  AddPostController addPostController = Get.put(AddPostController());

  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddPostController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size(Get.width, 0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 20,
                  labelPadding: EdgeInsets.only(top: 20),
                  indicator: BoxDecoration(color: Colors.black),
                  controller: tabController,
                  tabs: [
                    Text('Post'),
                    Text('Banner'),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                Post(controller: controller),
                Banner(controller: controller)
              ],
            ),
          ),
        );
      },
    );
  }
}

class Post extends StatelessWidget {
  final AddPostController controller;

  const Post({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Align(alignment: Alignment.center, child: Text('Post')),
              SizedBox(
                height: 10,
              ),
              if (controller.image == null)
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      controller.pickImage();
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Icon(Icons.add),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        height: 200,
                        width: 200,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(controller.image!),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            controller.pickImage();
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                ),
// SizedBox(height: 50),
// controller.listOfImage.length != 0
//     ? SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         physics: BouncingScrollPhysics(),
//         child: Row(
//           children: List.generate(
//             controller.listOfImage.length,
//             (index) => Container(
//               margin: EdgeInsets.only(right: 15),
//               height: 200,
//               width: 200,
//               alignment: Alignment.topRight,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: FileImage(
//                         controller.listOfImage[index]),
//                     fit: BoxFit.cover),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: Colors.black,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     onPressed: () async {
//                       controller.pickImage(index);
//                     },
//                     icon: Icon(Icons.edit),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       controller.removeImage(index);
//                     },
//                     icon: Icon(Icons.delete),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     : SizedBox(),
// controller.listOfImage.length == 0
//     ? Align(
//         alignment: Alignment.center,
//         child: InkWell(
//           onTap: () async {
//             controller.pickImages();
//           },
//           child: Container(
//             height: 200,
//             width: 200,
//             child: Icon(Icons.add),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//       )
//     : SizedBox(),
// SizedBox(
//   height: 30,
// ),
              SizedBox(
                height: 30,
              ),

              Text('Event name'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controller.eventNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Event name'),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Event Date'),
              SizedBox(
                height: 10,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  controller.selectDate(context);
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(controller.selectedDate != null
                        ? '${controller.selectedDate.toString().split(' ').first}'
                        : 'Select Date'),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(
                      value: controller.upcoming,
                      onChanged: (val) {
                        controller.updateEvent(val!);
                      }),
                  SizedBox(width: 0),
                  Text('Upcoming Event'),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              controller.loader == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 50,
                      width: Get.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          controller.updateLoader(true);
                          if (controller.image != null) {
                            if (controller
                                .eventNameController.text.isNotEmpty) {
                              if (controller.selectedDate != null) {
                                try {
                                  String? url = await controller.uploadFile(
                                    file: controller.image,
                                    filename: controller.image
                                        .toString()
                                        .split('/')
                                        .last
                                        .toString(),
                                    dir: controller.eventNameController.text
                                        .trim()
                                        .toString(),
                                  );

                                  DocumentReference doc = FirebaseFirestore
                                      .instance
                                      .collection('Events')
                                      .doc();
                                  await doc.set({
                                    'eventName': controller
                                        .eventNameController.text
                                        .trim()
                                        .toString(),
                                    'upcoming': controller.upcoming,
                                    'eventDate': controller.selectedDate,
                                    'thumbnail': url,
                                    'docId': doc.id,
                                  }).then((value) {
                                    controller.updateLoader(false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Event Add Successfully'),
                                      ),
                                    );

                                    controller.clearAll();
                                  });
// await creteUrl(controller)
//     .then((value) async {
//   DocumentReference doc =
//       FirebaseFirestore.instance
//           .collection('Events')
//           .doc();
//   await doc.set({
//     'eventName': controller
//         .eventNameController.text
//         .trim()
//         .toString(),
//     'eventDate':
//         controller.selectedDate,
//     // 'imageList':
//     //     controller.listOfImageUrl,
//     'docId': doc.id
//   });
// }).then((value) {
//   controller.updateLoader(false);
//   ScaffoldMessenger.of(context)
//       .showSnackBar(
//     SnackBar(
//       content: Text(
//           'Event Add Successfully'),
//     ),
//   );
//
//
//   controller.clearAll();
// });
                                } catch (e) {
                                  controller.updateLoader(false);
                                }
                              } else {
                                controller.updateLoader(false);

                                /// SelectDate
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Select Date'),
                                  ),
                                );
                              }
                            } else {
                              controller.updateLoader(false);

                              /// Event Name

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Enter Event name'),
                                ),
                              );
                            }
                          } else {
                            controller.updateLoader(false);

                            /// PickImage
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Select Image For Event'),
                              ),
                            );
                          }
                        },
                        child: Text('Upload'),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Banner extends StatelessWidget {
  final AddPostController controller;

  const Banner({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Align(alignment: Alignment.center, child: Text('Banner')),
              SizedBox(
                height: 10,
              ),
              if (controller.bannerImage == null)
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      controller.bannerPickImage();
                    },
                    child: Container(
                      height: 180,
                      width: Get.width,
                      child: Icon(Icons.add),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: Get.width,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(controller.bannerImage!),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            controller.bannerPickImage();
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                ),
              SizedBox(
                height: 30,
              ),
              controller.loader == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 50,
                      width: Get.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          controller.updateLoader(true);
                          if (controller.bannerImage != null) {
                            try {
                              String? bannerUrl = await controller.uploadFile(
                                file: controller.bannerImage,
                                filename: controller.bannerImage
                                    .toString()
                                    .split('/')
                                    .last
                                    .toString(),
                                dir: 'Banner',
                              );

                              DocumentReference doc = FirebaseFirestore.instance
                                  .collection('Banner')
                                  .doc();
                              await doc.set({
                                'docId': doc.id,
                                'bannerImage': bannerUrl,
                                'bannerDate': DateTime.now(),
                                'name': controller.bannerImage
                                    .toString()
                                    .split('/')
                                    .last
                                    .toString(),
                              }).then((value) {
                                controller.updateLoader(false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Banner Add Successfully'),
                                  ),
                                );

                                controller.clearAll();
                              });
                            } catch (e) {
                              controller.updateLoader(false);
                            }
                          } else {
                            controller.updateLoader(false);

                            /// PickImage
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Select Banner For Event'),
                              ),
                            );
                          }
                        },
                        child: Text('Upload'),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
