
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../view_model/controller/chat_screen_controller/camera_screen_controller.dart';

class ImageView extends StatelessWidget {
  final double height;
  final double width;
  final List<Medium> mediaList;
  final CameraScnController controller;

  const ImageView(
      {super.key,
      required this.height,
      required this.width,
      required this.mediaList, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          mediaList.length,
          (index) {
            bool isAdded = controller.selectedMediumList.any((element) => element.id == mediaList[index].id);
            return GestureDetector(
              onTap: () => controller.imageList.isEmpty ? controller.tapOnImage(index) : controller.longPressOnImage(index),
              onLongPress: () => controller.longPressOnImage(index),
              child: Container(
                height: height,
                width: width,
                color: isAdded ? ChatHelpers.mainColorLight : ChatHelpers.white ,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(2),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: ThumbnailProvider(
                    mediumId: mediaList[index].id,
                    mediumType: mediaList[index].mediumType,
                    highQuality: true,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // children: <Widget>[
      //   ...mediaList.map(
      //     (medium) => GestureDetector(
      //       onTap: () => logPrint("Tap on image"),
      //       child: Container(
      //         color: Colors.grey[300],
      //         child: FadeInImage(
      //           fit: BoxFit.cover,
      //           placeholder: MemoryImage(kTransparentImage),
      //           image: ThumbnailProvider(
      //             mediumId: medium.id,
      //             mediumType: medium.mediumType,
      //             highQuality: true,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
