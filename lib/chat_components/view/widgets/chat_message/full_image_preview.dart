import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/chatHelper/chat_helper.dart';


class ImagePreview extends StatelessWidget {
  final String imageUrl;
  const ImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ChatHelpers.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: ()=> Get.back(), icon: const Icon(Icons.close,color: ChatHelpers.black,)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.download,color: ChatHelpers.black))
            ],
          ),
          const SizedBox(height: 15,),
          Center(child: Image.network(imageUrl))
        ],
      ),
    );
  }
}
