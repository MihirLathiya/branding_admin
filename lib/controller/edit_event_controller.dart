import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class EditEventController extends GetxController {
  List<File> listOfImage = [];
  List<String> listOfImageUrl = [];
  bool isLoading = false;
  updateLoading(bool value) {
    isLoading = value;
    update();
  }

  /// UPLOAD IMAGE TO FIREBASE
  Future<String?> uploadFile(
      {File? file, String? filename, String? dir}) async {
    print("File path:$file");
    try {
      var response = await FirebaseStorage.instance
          .ref("Event/$dir/$filename")
          .putFile(file!);
      var result =
          await response.storage.ref("Event/$dir/$filename").getDownloadURL();
      return result;
    } catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  /// MULTIPLE IMAGE PICKER
  pickImages(String eventName, String docId) async {
    updateLoading(true);

    FilePickerResult? selectedImages = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );

    if (selectedImages != null) {
      try {
        listOfImageUrl.clear();

        selectedImages.files.forEach((element) async {
          listOfImage.add(File(element.path!));
        });
        print('selectedImages  image of  ${selectedImages}');
        for (int i = 0; i < listOfImage.length; i++) {
          String? url = await uploadFile(
            file: listOfImage[i],
            filename: listOfImage[i].toString().split('/').last.toString(),
            dir: eventName.toString(),
          );

          FirebaseFirestore.instance
              .collection('Events')
              .doc('${docId}')
              .collection('Eventimage')
              .add({
            'image': url,
            'time': DateTime.now(),
            'name': listOfImage[i].toString().split('/').last.toString()
          });
        }

        clearAll();
      } catch (e) {
        print('UPLOAD ERROR:- $e');
        updateLoading(false);
      }
    }

    updateLoading(false);
    update();
  }

  /// SINGLE IMAGE PICKER
  File? image;
  pickImage(int index, String fileName, String eventName, String eventId,
      String docId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );
    if (result == null) {
      print("No file selected");
    } else {
      updateLoading(true);

      image = File(result.files.single.path!);

      try {
        String? url = await uploadFile(
            filename: fileName, file: image, dir: eventName.toString());
        FirebaseFirestore.instance
            .collection('Events')
            .doc('${docId}')
            .collection('Eventimage')
            .doc(eventId)
            .update({
          'image': url,
          'time': DateTime.now(),
          'name': image.toString().split('/').last.toString()
        });
      } catch (e) {
        updateLoading(false);
        print('----ERORORO---$e');
      }
      update();
      updateLoading(false);

      print('Audio pick= = ${result.files.single.name}');
    }
    update();
  }

  /// DELETE IMAGE
  removeImage(String docId, String eventId) async {
    FirebaseFirestore.instance
        .collection('Events')
        .doc(eventId)
        .collection('Eventimage')
        .doc(docId)
        .delete();
    update();
  }

  /// DELETE COLLECTION
  deleteCollection(String eventId) async {
    var data = FirebaseFirestore.instance
        .collection('Events')
        .doc(eventId)
        .collection('Eventimage');
    var info = await data.get();
    info.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .collection('Eventimage')
          .doc(element.id)
          .delete();
    });
    FirebaseFirestore.instance.collection('Events').doc(eventId).delete();
    Get.back();
    Get.back();
  }

  /// CLEAAR ALL
  clearAll() {
    listOfImageUrl.clear();
    listOfImage.clear();
    image = null;

    update();
  }
}
