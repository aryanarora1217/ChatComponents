import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/view/widgets/icon_button/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ChatHelpers.mainColor,
        leading: CircleIconButton(
          onTap: () {},
          isImage: false,
          icons: CupertinoIcons.back,
        ),
        title: Text(
          "Send Location",
          style: ChatHelpers.instance
              .styleMedium(ChatHelpers.fontSizeLarge, ChatHelpers.white),
        ),
      ),
      backgroundColor: ChatHelpers.white,
      // body: SizedBox(
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   // child: const GoogleMap(
      //   //   initialCameraPosition: CameraPosition(
      //   //       target: LatLng(26.9154576, 75.8189817), zoom: 11.0),
      //   // ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: ChatHelpers.mainColor,
        child: const Icon(Icons.send,color: ChatHelpers.white,
        ),
      ),
    );
  }
}
