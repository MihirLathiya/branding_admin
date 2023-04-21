import 'package:branding_add_post/controller/edit_event_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class EventEditScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  const EventEditScreen(
      {Key? key, required this.eventId, required this.eventName})
      : super(key: key);

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  EditEventController editEventController = Get.put(EditEventController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventName.toUpperCase()}'),
        elevation: 0,
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Are you sure to delete?'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'If you tap Yes you lose this event all data!',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          editEventController.deleteCollection(widget.eventId);
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
      ),
      floatingActionButton: GetBuilder<EditEventController>(
        builder: (controller) {
          return FloatingActionButton(
            onPressed: () {
              controller.pickImages(widget.eventName, widget.eventId);
            },
            child: Icon(Icons.add),
          );
        },
      ),
      body: GetBuilder<EditEventController>(
        builder: (controller) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Events')
                .doc(widget.eventId)
                .collection('Eventimage')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data?.docs;
                return controller.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : data?.length == 0
                        ? Center(
                            child: Text('No Data'),
                          )
                        : MasonryGridView.count(
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            itemCount: data?.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      height: 200,
                                      width: 189,
                                      imageUrl: '${data?[index]['image']}',
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Icon(Icons.error_outline),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) {
                                        return Shimmer.fromColors(
                                          baseColor:
                                              Colors.grey.withOpacity(0.4),
                                          highlightColor:
                                              Colors.grey.withOpacity(0.2),
                                          enabled: true,
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          controller.pickImage(
                                              index,
                                              data![index]['name'] ?? '',
                                              widget.eventName,
                                              data[index].id,
                                              widget.eventId);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Are you sure to delete?'),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'If you tap Yes you lose this image data!',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      controller.removeImage(
                                                          data![index].id,
                                                          widget.eventId);
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
        },
      ),
    );
  }
}
