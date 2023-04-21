import 'package:branding_add_post/controller/edit_post_controller.dart';
import 'package:branding_add_post/view/edit_event_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen>
    with SingleTickerProviderStateMixin {
  EditPostController editPostController = Get.put(EditPostController());
  TabController? tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPostController>(
      builder: (controller) {
        return Scaffold(
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
                  Text('Event'),
                  Text('Banner'),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Event(controller: controller),
              Banners(controller: controller)
            ],
          ),
        );
      },
    );
  }
}

class Event extends StatelessWidget {
  final EditPostController controller;
  const Event({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Events')
          .orderBy('eventDate', descending: false)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data?.docs;

          return MasonryGridView.count(
            physics: BouncingScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: data?.length,
            itemBuilder: (context, index) {
              return data?.length == 0
                  ? Center(
                      child: Text('No Events'),
                    )
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => EventEditScreen(
                                  eventId: data![index].id,
                                  eventName:
                                      data[index]['eventName'] ?? 'Event',
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              height: 200,
                              width: 189,
                              imageUrl: '${data?[index]['thumbnail']}',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(Icons.error_outline),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(0.4),
                                  highlightColor: Colors.grey.withOpacity(0.2),
                                  enabled: true,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(vertical: 6),
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${data![index]['eventName']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Server Error'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class Banners extends StatelessWidget {
  final EditPostController controller;
  const Banners({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Banner')
          .orderBy('bannerDate', descending: false)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data?.docs;

          return ListView.separated(
            padding: EdgeInsets.all(20),
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return data.length == 0
                  ? Center(
                      child: Text('No Banner'),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            height: 200,
                            width: Get.width,
                            imageUrl: '${data[index]['bannerImage']}',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(Icons.error_outline),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.4),
                                highlightColor: Colors.grey.withOpacity(0.2),
                                enabled: true,
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Are you sure to delete?'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'If you tap Yes you lose this banner data!',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Banner')
                                            .doc(data[index].id.toString())
                                            .delete();
                                        Get.back();
                                      },
                                      child: Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Server Error'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
