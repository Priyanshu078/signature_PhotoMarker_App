import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/saved_images_database.dart';

class HomePageController extends GetxController {
  var imagePath = "".obs;
  RxList pointsList = [].obs;
  RxBool gestureDetector = true.obs;
  RxDouble thickness = 1.0.obs;
  RxInt markerColor = Colors.blue.value.obs;
  SavedImagesDatabase database = SavedImagesDatabase();

  @override
  void onInit() async{
    await database.openMyDatabase();
    super.onInit();
  }
}
