import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../model/chatHelper/chat_helper.dart';


CachedNetworkImage cachedNetworkImage({required String url,BoxFit fit = BoxFit.fill,Color ?color,required bool isProfile}){
  return CachedNetworkImage(
    cacheKey: url,
    imageUrl: url,
    fit: fit,
    color: color,
    placeholder: (context, url) => Padding(
      padding:EdgeInsets.all(isProfile?0:ChatHelpers.marginSizeExtraLarge),
      child: Image.asset(ChatHelpers.instance.loadingGIF,fit: BoxFit.cover,height: 50,width: 50,package: "chatcomponent",),
    ),
    errorWidget: (context, url, error) => Padding(
      padding: const EdgeInsets.all(ChatHelpers.marginSizeSmall),
      child: Image.asset(ChatHelpers.instance.errorImage,fit: BoxFit.cover,package: "chatcomponent",),
    ),
  );
}