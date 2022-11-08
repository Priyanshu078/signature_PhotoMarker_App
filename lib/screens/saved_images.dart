import 'package:blup_assignment/state_management/home_page_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:share_extend/share_extend.dart';
import 'dart:io';

// import 'package:share_plus/share_plus.dart';

// import 'package:share_plus/share_plus.dart';

class SavedImages extends StatelessWidget {
  SavedImages({Key? key}) : super(key: key);

  // final SavedImagesController savedImagesController = Get.put(SavedImagesController());
  final HomePageController _homePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Images"),
        ),
        body: FutureBuilder(
          future: _homePageController.database.getImagesPath(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // print(snapshot.data![3]['path'].toString());
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ShowImage(
                                path: snapshot.data![index]['path'].toString(),
                                index: index,
                              );
                            }));
                          },
                          child: Hero(
                              tag: 'image$index',
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: width * 0.4,
                                  height: height * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(
                                        File(
                                          snapshot.data![index]['path']
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )));
                    }),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({Key? key, required this.path, required this.index}) : super(key: key);
  final String path;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(tag: 'image$index', child: Image.file(File(path))),
              IconButton(
                  onPressed: () async{
                // Share.shareXFiles([XFile(path)],text: "image");
                // await FlutterShare.shareFile(
                //     title: 'image',
                //     filePath: path,
                //     fileType: 'image/png'
                // );
                    ShareExtend.share(path,'image');
              }, icon: const Icon(Icons.share))
            ],
          ),
        ),
      ),
    );
  }
}
