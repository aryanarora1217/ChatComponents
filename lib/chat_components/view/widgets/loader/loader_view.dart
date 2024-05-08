import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../model/chatHelper/chat_helper.dart';

class LoaderView extends StatelessWidget {
  final Color? loaderColor;
  final double? size;
  const LoaderView({super.key, this.loaderColor, this.size});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: loaderColor ?? ChatHelpers.mainColor,
      size: size ?? 50,
    );
  }
}
