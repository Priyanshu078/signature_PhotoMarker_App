import 'dart:io';
import 'dart:typed_data';
import 'package:blup_assignment/draw_points.dart';
import 'package:blup_assignment/home_page_controller.dart';
import 'package:blup_assignment/paint_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey globalKey = GlobalKey();
  final HomePageController homePageController = Get.put(HomePageController());

  Future<void> _capturePng() async {
    Uint8List pngBytes;
    String imagePath;
    File capturedFile;
    try {
      print('inside');
      RenderRepaintBoundary boundary =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData!.buffer.asUint8List();
//create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      imagePath = '$dir/yourImage${DateTime.now()}.png';
      capturedFile = File(imagePath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile.path);
      final result = await ImageGallerySaver.saveImage(pngBytes,
          name: "yourImage${DateTime.now()}");
      print(result);
      print('png done');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved Image to Gallery")));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: "Settings",
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10))),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                        padding: const EdgeInsets.all(16),
                        height: height * 0.5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Settings",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              Row(
                                children: [
                                  const Text("Color",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Obx(
                                    () => Container(
                                      height: height * 0.02,
                                      width: height * 0.02,
                                      color: Color(homePageController.markerColor.value),
                                    ),
                                  )
                                ],
                              ),
                              MaterialButton(
                                color: Colors.blue,
                                  child: const Text("Choose Color",
                                      style: TextStyle(
                                        color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Pick a color!'),
                                              content: SingleChildScrollView(
                                                child: ColorPicker(
                                                  pickerColor:
                                                      Color(homePageController
                                                          .markerColor.value),
                                                  onColorChanged: (color) {
                                                    homePageController
                                                        .markerColor.value = color.value;
                                                    print(Color(color.value));
                                                  },
                                                ),
                                              ),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  child: const Text('Got it'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));
                                  }),
                              const Text("Thickness",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Obx(
                                () => Slider(
                                    divisions: 10,
                                    min: 0.0,
                                    max: 10.0,
                                    label: homePageController.thickness.value
                                        .toString(),
                                    value: homePageController.thickness.value,
                                    onChanged: (val) {
                                      homePageController.thickness.value = val;
                                    }),
                              )
                            ]),
                      ));
            },
          ),
          IconButton(
            tooltip: "Clear Screen",
            icon: const Icon(Icons.delete),
            onPressed: () {
              homePageController.pointsList.clear();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: RepaintBoundary(
                  key: globalKey,
                  child: Stack(
              fit: StackFit.expand,
              children: [
                  Obx(
                    () => homePageController.imagePath.value != ""
                        ? Image.file(
                            File(homePageController.imagePath.value),
                            fit: BoxFit.fill,
                          )
                        : Container(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                      onPanStart: (dragDetails) {
                        homePageController.pointsList.add(DrawPoints(
                          paint: Paint()
                            ..strokeCap = StrokeCap.butt
                            ..isAntiAlias = true
                            ..color = Color(homePageController.markerColor.value)
                            ..strokeWidth = homePageController.thickness.value,
                          offsetPoints: dragDetails.localPosition,
                        ));
                        print(dragDetails.globalPosition);
                        print(dragDetails.localPosition);
                      },
                      onPanUpdate: (dragDetails) {
                        homePageController.pointsList.add(DrawPoints(
                          paint: Paint()
                            ..strokeCap = StrokeCap.butt
                            ..isAntiAlias = true
                            ..color = Color(homePageController.markerColor.value)
                            ..strokeWidth = homePageController.thickness.value,
                          offsetPoints: dragDetails.localPosition,
                        ));
                        print(dragDetails.globalPosition);
                        print(dragDetails.localPosition);
                      },
                      onPanEnd: (dragDetails) {
                        homePageController.pointsList.add(null);
                        print(dragDetails.primaryVelocity);
                        print(dragDetails.velocity);
                      },
                      child: Obx(
                        () => homePageController.pointsList.isEmpty
                            ? CustomPaint(
                                size: Size.infinite,
                                painter: ImagePainter(
                                    pointsList: homePageController.pointsList),
                              )
                            : CustomPaint(
                                size: Size.infinite,
                                painter: ImagePainter(
                                    pointsList: homePageController.pointsList),
                              ),
                      )),
              ],
            ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                    XFile? file = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    homePageController.imagePath.value = file!.path;
                  },
                  child: const Text(
                    "Select Image",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    if(homePageController.pointsList.isNotEmpty) {
                      _capturePng();
                    }
                  },
                  child: const Text(
                    "Save Image",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
