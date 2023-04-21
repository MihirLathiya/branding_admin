import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPostController extends GetxController {
  TextEditingController eventNameController = TextEditingController();
  DateTime? selectedDate;
  bool loader = false;
  bool upcoming = false;
  List<File> listOfImage = [];
  List<String> listOfImageUrl = [];

  /// UPDATE LOADER
  updateEvent(bool value) {
    upcoming = value;
    update();
  }

  /// UPDATE LOADER
  updateLoader(bool value) {
    loader = value;
    update();
  }

  /// SINGLE IMAGE PICKER
  File? image;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );
    if (result == null) {
      print("No file selected");
    } else {
      image = File(result.files.single.path!);
      update();

      print('Image pick= = ${result.files.single.name}');
    }
    update();
  }

  /// SINGLE BANNER PICKER
  File? bannerImage;

  bannerPickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
    );
    if (result == null) {
      print("No file selected");
    } else {
      bannerImage = File(result.files.single.path!);
      update();

      print('Image pick= = ${result.files.single.name}');
    }
    update();
  }

  /// DATE PICKER
  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }

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

  /// CLEAR ALL
  clearAll() {
    listOfImageUrl.clear();
    listOfImage.clear();
    selectedDate = null;
    eventNameController.clear();
    image = null;
    bannerImage = null;

    update();
  }
}
