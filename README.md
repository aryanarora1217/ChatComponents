# Chat Component About

In this Chat Components Project :

we have a total 4 screens:

1. chat Screen
  
2. OutGoing Screen

3. Audio Call Screen

4. Video call Screen

# How to use this chat Component

we simply have to pass data in chat Services init method basic values to run and use this chat 
components data are :

1. * Current user ID:- with this we can fetch user data directly from the firebase fireStore
      database

2. * Other user ID: with help, we can fetch other user data from firebase which you want to chat

3. chatRoom ID: this is optional if you have you can give the chatroom ID

4. isVideoCallEnable: with this, we can enable or disable the video call feature and the visible or
   not icon of the video call

5. isAudioCallEnable: with this, we can enable or disable the audio call feature and the visible or
   not icon of the audio call

6. isAttachmentSendEnable: with this, we can enable or disable the attachment(like file send able )
   feature and visible or not icon of attachment on the message text field

7. isCameraImageSendEnable: with this, we can enable or disable the camera Image feature and the
   visible or not icon of the camera on message text field

8. * imageBaseUrlFirebase: In this we have to add our firebase storage base
      URL: "https://firebasestorage.googleapis.com/v0/b/your_x_app_x_url"

9. agoraAppId: this is the agora app ID This is optional if you want to use video call and audio
   call features then you have to add the agora app ID

10. agoraAppCertificate: this is the Agora app Certificate This is optional if you want to use video
    call and audio call features then you have to add the Agora app Certificate

11. agoraChannelName: this is agora ChannelName This is optional if you want to use video call and
    audio call features then you have to add agora ChannelName in which both user join on call

12. agoraToken: this is agora Token This is optional if you want to use video call and audio call
    features then you have to add agora Token which is use generated for this specific channel name

13. * firebaseServerKey: this is the firebase notification cloud server/Authorization key used for
      sending notifications to users

14. imageArguments: this is optional you have to give this when use have added
    isAttachmentSendEnable is true. In this, you have to send an image from the gallery, send an
    image from the camera, or send files or documents value true to use these file

15. these arguments: this is optional you have to give this when you want to change the theme of
    screens like color, text style, border Radius, or add a custom send button widget view only. In
    the custom send widget you don't have to add a tap or other function

These four values with stars are important which you have to give to using this chat component

Both user IDs will be used when creating the chat room ID.

# A example of code to add values to chat services

for passing the arguments use this function 
``` 
Get.putAsync(() => ChatServices().init(
imageBaseUrlFirebase: 'Add firebase storage baseUrl for file ',
firebaseServerKey: 'Add firebase notification cloud server/Authorization key ',
imageArguments: ImageArguments(isImageFromCamera: true),
isAttachmentSendEnable: true,
isAudioCallEnable: true ,
themeArguments: ThemeArguments(
colorArguments: ColorArguments(mainColor: Colors.red),
styleArguments: StyleArguments(appbarNameStyle: TextStyle(color: Colors.white)),
customWidgetsArguments: CustomWidgetsArguments(customSendIconButtonWidgets: CircleAvatar(
backgroundColor: Colors.red,child: Icon(Icons.send_rounded,color: Colors.yellowAccent,),)))));
```

for navigating to chat screen use this function 
``` 
ChatHelpers.instance.chatScreenNavigation(
"Chat Room ID",
"other user Id",
"current user Id ",
"agroa chanel name ",
"agora Token")
``` 

have to add this line in pubspec yaml file then assets of this package will visible to screen
```
ChatComponents-8a0c2b1839847e2b235f82c19200f7d744302f4b/lib/chat_assets/
```
