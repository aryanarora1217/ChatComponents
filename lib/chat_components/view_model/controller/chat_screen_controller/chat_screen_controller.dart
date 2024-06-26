import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:chatcomponent/chat_components/model/function_helper/downlaod_helper.dart';
import 'package:chatcomponent/chat_components/model/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../model/firebase_notification/firebase_notification.dart';
import '../../../model/function_helper/file_extension.dart';
import '../../../model/function_helper/get_image_function.dart';
import '../../../model/models/call_model/call_model.dart';
import '../../../model/models/chat_model/chat_model.dart';
import '../../../model/models/message_model/message_model.dart';
import '../../../model/models/picker_file_modal/picker_file_modal.dart';
import '../../../model/models/user_model/user_model.dart';
import '../../../model/network_services/firebase_database.dart';
import '../../../model/randomkey/randomkey.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../../view/widgets/toast_view/toast_view.dart';

class ChatController extends GetxController with WidgetsBindingObserver {
  /// emojis list for reaction
  List<String> emoji = Get.find<ChatServices>().chatArguments.reactionsEmojisIcons ?? ["❤️", "😀", "😁", "😎", "👆"];

  /// initial index for reaction list when display in chats
  RxInt reactionIndex = 7.obs;

  /// select index for reaction list
  RxString selectReactionIndex = "".obs;

  /// messages box textfeild controller
  TextEditingController messageController = TextEditingController();

  /// scrolling controller for message list view
  ScrollController scrollController = ScrollController();

  /// textfeild focus
  FocusNode messageFocus = FocusNode();

  /// user details current and other user
  Rx<Users> users = Users().obs;
  Rx<Users> currentUser = Users().obs;

  /// chat room details
  Rx<ChatRoomModel> chatRoomModel = ChatRoomModel().obs;
  RxBool isFirstUser = false.obs;
  RxBool isFirstCurrent = false.obs;
  RxBool isUserId = false.obs;
  RxBool isReaction = false.obs;

  /// message model list
  RxList<MessageModel> messages = <MessageModel>[].obs;
  List<MessageModel> oldMessages = <MessageModel>[];

  /// permissions for camera and photos
  RxBool isPermissionCameraGranted = false.obs;
  RxBool isPermissionPhotosGranted = false.obs;

  /// image file variable
  Rx<File> image = File('').obs;

  /// typing status
  RxBool userTypingStatus = false.obs;

  /// firebase functions file import
  var firebase = FirebaseDataBase();

  /// firebase notification file import
  var firebaseNotification = FirebaseNotification();

  /// message , typing , active status , presence listner
  StreamSubscription<QuerySnapshot>? messageListener;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? typingListener;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      activeStatusListener;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? presenceListener;

  /// loading values
  RxBool isLoading = true.obs;
  RxBool isLoadingPreviousChats = true.obs;
  RxBool isError = false.obs;
  RxBool isLoadingChats = true.obs;
  RxBool isScreenOn = false.obs;
  RxBool isDownloadingStart = false.obs;
  RxBool isAudioRecorderStart = false.obs;

  /// dailog open boolean value
  RxBool isDialogOpen = false.obs;

  /// chat room reference variable
  DocumentReference<Map<String, dynamic>>? reference;

  /// chip messages list text
  List<String> suggestions =
      Get.find<ChatServices>().chatArguments.suggestionsMessages ??
          <String>[
            'Hii',
            "Hello",
            'Hey there',
            'how are you',
            'What are you doing',
            "What's up"
          ];

  RxList<PickerFileModal> imageList = <PickerFileModal>[].obs;
  RxList<TextEditingController> imageMessageControllerList = <TextEditingController>[].obs;

  RecorderController recorderController = RecorderController();


  /// arguments get
  late ChatArguments chatArguments;
  ImageArguments? imageArguments;
  ThemeArguments? themeArguments;
  RxString chatRoomID = "".obs;
  RxString currentUserId = "".obs;
  RxString otherUserId = "".obs;
  RxString agoraChannelName = "".obs;
  RxString agoraToken = "".obs;

  /// for generating chatroom Id
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      chatRoomID.value = "${b}_$a";
    } else {
      chatRoomID.value = "${a}_$b";
    }
  }

  /// open attachments dialog from  message box(textfield)
  void openDialog() {
    if (isDialogOpen.isTrue) {
      isDialogOpen.value = false;
      isAudioRecorderStart.isTrue ? stopRecorder(false) : null;
      isAudioRecorderStart.isTrue ? isAudioRecorderStart.value = false : null;
    } else {
      isDialogOpen.value = true;
    }
  }

  void onScreenTap() {
    selectReactionIndex.value = "";
    isReaction.value = false;
    isDialogOpen.value = false;
  }


  /// send messages form message box( text field ) and updating message chatroom and messages list
  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      String id = getRandomString();
      MessageModel message = MessageModel(
          id: id,
          message: messageController.text,
          messageType: MessageType.text.name,
          sender: currentUserId.value,
          isSeen: false,
          time: DateTime.now().toUtc().toString());
      messageController.clear();
      messages.add(message);
      try {
        ChatRoomModel chatRoomModel = addChatRoomModel(message);
        firebase.addMessage(message, chatRoomModel);

        firebaseNotification.sendNotification("", currentUser.value, users.value.deviceToken ?? "", CallModel(), true, message, chatRoomModel.chatRoomId, chatArguments.firebaseServerKey, users.value, CallArguments(
                agoraChannelName: '',
                agoraToken: '',
                user: Users(),
                currentUser: Users(),
                callType: '',
                callId: '',
                imageBaseUrl: '',
                agoraAppId: '',
                agoraAppCertificate: '',
                userId: '',
                currentUserId: '',
                firebaseServerKey: ''));

        if (otherUserId.value != ChatHelpers.instance.userId) {
          await chatroomUpdates();
        }
      } catch (e) {
        logPrint("error messaging : $e");
      }
    } else {
      toastShow(massage: "please Enter message", error: true);
    }
  }

  void addReaction(int index, int messageIndex) {
    try {
      isReaction.value = isReaction.value;
      messages[messageIndex].reaction = index;
      selectReactionIndex.value = "";
      logPrint("select value is : ${selectReactionIndex.value} , ${messages[messageIndex].reaction}");
      ChatRoomModel chatRoomModel = addChatRoomModel(messages[messageIndex]);

      firebase.addMessage(messages[messageIndex], chatRoomModel);
    } catch (e) {
      logPrint("error in updating reactions : $e ");
    }
  }

  /// update chatroom model when sending messages or files
  ChatRoomModel addChatRoomModel(MessageModel message) {
    return ChatRoomModel(
        chatRoomId: chatRoomID.value,
        userFirst: UserDetails(
          userToken: users.value.deviceToken,
          userId: users.value.id,
          userProfile: users.value.profileImage,
          userName: users.value.profileName,
          userEmail: users.value.email,
          userSignType: users.value.signInType,
          userActiveStatus:
              chatRoomModel.value.userFirstId == currentUserId.value
                  ? chatRoomModel.value.userSecond?.userActiveStatus
                  : chatRoomModel.value.userFirst?.userActiveStatus ?? false,
          userTypingStatus: false,
        ),
        userSecond: UserDetails(
          userToken: currentUser.value.deviceToken,
          userId: currentUserId.value,
          userSignType: currentUser.value.signInType,
          userEmail: currentUser.value.email,
          userName: currentUser.value.profileName,
          userProfile: currentUser.value.profileImage,
          userActiveStatus: true,
          userTypingStatus: false,
        ),
        userFirstId: users.value.id,
        userSecondId: currentUserId.value,
        recentMessage: message,
        chatMembers: [users.value.id ?? "", currentUserId.value]);
  }

  /// chip message send update message chatroom and messages list
  Future<void> chipMessage(int index) async {
    String id = getRandomString();
    MessageModel message = MessageModel(
        id: id,
        message: suggestions[index],
        messageType: MessageType.text.name,
        sender: currentUserId.value,
        isSeen: false,
        time: DateTime.now().toUtc().toString());

    messageController.clear();

    ChatRoomModel chatRoomModel = addChatRoomModel(message);

    firebase.addMessage(message, chatRoomModel);
    messages.add(message);

    firebaseNotification.sendNotification("", currentUser.value, users.value.deviceToken ?? "", CallModel(), true, message, chatRoomModel.chatRoomId, chatArguments.firebaseServerKey, users.value, CallArguments(agoraChannelName: '', agoraToken: '', user: Users(), currentUser: Users(), callType: '', callId: '', imageBaseUrl: '', agoraAppId: '', agoraAppCertificate: '', userId: '', currentUserId: '', firebaseServerKey: ''));

    if (otherUserId.value != ChatHelpers.instance.userId) {
      await chatroomUpdates();
    }
  }

  /// pick up file for storage and upload in firebase storage and send in chats
  void pickFile() async {
    /// pick up file for storage
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    isDialogOpen.value = false;
    /// genrate id
    String id = getRandomString();
    if (result == null)
    {
      logPrint("file not found ");
    }
    else {
      try {
        MessageModel loadingMessage = MessageModel(id: id,file: Files(fileName: result.files.first.name, fileMimeType: result.files.first.extension, fileType: FileTypes.document.name, fileUrl: result.files.first.path,isAdding: false), messageType: MessageType.file.name, sender: currentUserId.value, isSeen: false, time: DateTime.now().toUtc().toString());
        messages.add(loadingMessage);

        /// upload file in firebase storage
        String? url = await firebase.addChatFiles(id, result.files.first.path!);

        List storagePath = url!.split(chatArguments.imageBaseUrlFirebase);

        messageController.clear();

        /// update chatroom and message list
        MessageModel message = MessageModel(id: id, file: Files(fileName: result.files.first.name, fileMimeType: result.files.first.extension, fileType: FileTypes.document.name, fileUrl: storagePath[1],isAdding: true), messageType: MessageType.file.name, sender: currentUserId.value, isSeen: false, time: DateTime.now().toUtc().toString());
        ChatRoomModel chatRoomModel = addChatRoomModel(message);

        firebase.addMessage(message, chatRoomModel);
        firebaseNotification.sendNotification("", currentUser.value, users.value.deviceToken ?? "", CallModel(), true, message, chatRoomModel.chatRoomId, chatArguments.firebaseServerKey, users.value, CallArguments(agoraChannelName: '', agoraToken: '', user: Users(), currentUser: Users(), callType: '', callId: '', imageBaseUrl: '', agoraAppId: '', agoraAppCertificate: '', userId: '', currentUserId: '', firebaseServerKey: ''));

        final index = messages.indexWhere((element) => element.id == message.id);
        messages[index] = message;
        messageController.clear();

        if (otherUserId.value != ChatHelpers.instance.userId) {
          await chatroomUpdates();
        }
      } catch (e) {
        final index = messages.indexWhere((element) => element.id == id);
        messages.removeAt(index);
        toastShow(massage: "Error sending document", error: true);
      }
    }
  }

  /// pick photo form gallery send photo in chats function
  Future<void> photoPermission() async {
    PermissionStatus photosStatus = await Permission.photos.status;
    isDialogOpen.value = false;
    if (photosStatus.isGranted) {
      isPermissionPhotosGranted.value = true;
      /// image picker
      image.value = (await GetImageHelper.instance.getImage(2)) ?? File("");

      if (image.value.path != "") {

        Get.toNamed(ChatHelpers.cameraScreen,arguments: image.value)?.
        then((value) async {
          logPrint("Image get form back : ${value.toString()}");
          imageList.value = value["ImageList"];
          imageMessageControllerList.value = value["textMessageList"];

          logPrint("List of image and text : ${imageList.length} ${imageList.toString()} , ${imageMessageControllerList.toString()}");

          if(imageList.isNotEmpty) {
            await uploadListImages();
          }

        });

      }
    } else {
      Permission.photos.request();
    }
  }

  /// update typing status in chatroom
  void typingStatus(bool status) {
    firebase.userTypingStatus(chatRoomID.value, status, currentUserId.value);
  }

  /// read all messages of chat room
  Future<void> updateChats() async {
    try {
      Query<Map<String, dynamic>>? reference =
          await firebase.updateChatRoom(chatRoomID.value, 15, true);
      QuerySnapshot<Map<String, dynamic>> data = await reference!.get();
      messages.clear();
      for (var element in data.docs) {
        MessageModel messageModel = MessageModel.fromJson(element.data());
        bool isFile = messageModel.messageType == "file";
        bool isAdded =  messageModel.file?.fileUrl?.contains(chatArguments.imageBaseUrlFirebase) ?? true;
        messageModel.file?.fileUrl = isFile && (isAdded == false)? chatArguments.imageBaseUrlFirebase+(messageModel.file?.fileUrl??"") : (messageModel.file?.fileUrl??"");
        messageModel.file?.fileImageThumbnail = isFile && (isAdded == false)? chatArguments.imageBaseUrlFirebase+(messageModel.file?.fileImageThumbnail??"") : (messageModel.file?.fileImageThumbnail??"");
        messages.add(messageModel);
        logPrint("update chats : $isAdded , ${messageModel.file?.fileUrl}");
        // logPrint("update chats video file  : $isAdded , ${ messageModel.messageType == "file" ? messageModel.file?.fileType == FileTypes.video.name ?  await getVideoThumbnail(messageModel.file?.fileUrl??"") : "" :""}");
      }
      isLoadingChats.value = false;
      messages.value = messages.reversed.toList();
      oldMessages = messages.reversed.toList();
    } catch (e) {
      logPrint("error message fetch : $e");
    }
  }

  /// read last message in chat room
  void recentMessage() async {
    try {
      Query<Map<String, dynamic>>? reference =
          await firebase.updateChatRoom(chatRoomID.value, 1, true);
      messageListener = reference!.snapshots().listen((event) {
        for (var element in event.docs) {
          MessageModel messageModel = MessageModel.fromJson(element.data());
          messages.removeWhere((message) => message.id == messageModel.id);
          bool isFile = messageModel.messageType == "file";
          bool isAdded =  messageModel.file?.fileUrl?.contains(chatArguments.imageBaseUrlFirebase) ?? true;
          messageModel.file?.fileUrl = isFile && (isAdded == false)? chatArguments.imageBaseUrlFirebase+(messageModel.file?.fileUrl??"") : (messageModel.file?.fileUrl??"");
          messageModel.file?.fileImageThumbnail = isFile && (isAdded == false)? chatArguments.imageBaseUrlFirebase+(messageModel.file?.fileImageThumbnail??"") : (messageModel.file?.fileImageThumbnail??"");
          messages.add(messageModel);
          logPrint("update chats : ${messageModel.file?.fileUrl}  , ${messageModel.file?.fileImageThumbnail}");
        }
        if (messages.last.sender != currentUserId.value) {
          MessageModel message = messages.last;
          message.isSeen = true;
          message.file?.fileUrl?.replaceAll(chatArguments.imageBaseUrlFirebase, "");
          FirebaseFirestore.instance.collection(ChatHelpers.instance.chats).doc(chatRoomID.value).collection("messages").doc(message.id).update(message.toJson());
        }
      });
    } catch (e) {
      logPrint("error message fetch : $e");
    }
  }

  /// updating reading typing pressence in chatroom
  Future<void> readingTypingPresence() async {
    try {
      DocumentReference<Map<String, dynamic>>? typingPresence =
          await firebase.readTypingStatus(chatRoomID.value);
      typingListener = typingPresence!.snapshots().listen((event) async {
        if (event.exists) {
          ChatRoomModel chatRoomModel =
              ChatRoomModel.fromJson(event.data() ?? {});
          if (chatRoomModel.userFirstId == currentUserId.value) {
            userTypingStatus.value =
                chatRoomModel.userSecond?.userTypingStatus ?? false;
          } else {
            userTypingStatus.value =
                chatRoomModel.userFirst?.userTypingStatus ?? false;
          }
        }
      });
    } catch (e) {
      logPrint("error update presence => $e");
    }
  }

  void readPresence() async {
    try {
      DocumentReference<Map<String, dynamic>> presenceReference =
          await firebase.readPresence(users.value.id ?? "");
      presenceListener = presenceReference.snapshots().listen((event) async {
        users.value = Users.fromJson(event.data() ?? <String, dynamic>{});
      });
    } catch (e) {
      logPrint("error update presence => $e");
    }
  }

  void updatePresence(String presence) {
    firebase.updatePresence(presence, currentUserId.value);
  }

  /// destroy or close method controller
  @override
  Future<void> onClose() async {
    isScreenOn.value = false;
    updatePresence(PresenceStatus.offline.name);
    await firebase.userActiveChatroom(chatRoomID.value, isScreenOn.value,
        isFirstUser.call, currentUserId.value);
    scrollController.dispose();
    messageListener?.cancel();
    typingListener?.cancel();
    presenceListener?.cancel();
    activeStatusListener?.cancel();


    super.onClose();
  }

  /// init method
  @override
  Future<void> onInit() async {
    WidgetsBinding.instance.addObserver(this);
    initServices();
    // initializer();
    super.onInit();
  }

  Future<void> goToCameraScreen() async {
    Get.toNamed(ChatHelpers.cameraScreen,arguments: File(""))?.
    then((value) async {
      logPrint("Image get form back : ${value.toString()}");
      imageList.value = value["ImageList"] ?? [];
      imageMessageControllerList.value = value["textMessageList"];

      logPrint("List of image and text : ${imageList.length} ${imageList.toString()} , ${imageMessageControllerList.toString()}");

      if(imageList.isNotEmpty) {
        await uploadListImages();
      }

    });
  }

  Future<void> uploadListImages() async {
    try{
      selectReactionIndex.value = "";
      isReaction.value = false;
      isDialogOpen.value = false;
      for (int counter = 0; counter < imageList.length; counter++){

        File cameraImage = imageList[counter].file ?? File("");
        TextEditingController imageMessage = imageMessageControllerList[counter];
        String id = getRandomString();
        if (cameraImage != File("")) {
          try {
            String fileName = cameraImage.path.split('/').last;

            /// get file extension of a file
            String fileExt = getFileExtension(fileName)!;

            String thumbnail = await getVideoThumbnail(imageList[counter].file?.path ?? "");


            MessageModel loadingMessage = MessageModel(id: id,message: imageMessage.text,file: Files(fileName: fileName, fileMimeType: fileExt, fileType: imageList[counter].isVideo ?? false ? FileTypes.video.name : FileTypes.image.name , fileUrl: cameraImage.path,fileImageThumbnail: imageList[counter].isVideo ?? false ? thumbnail : "", isAdding:false), messageType: MessageType.file.name, sender: currentUserId.value, isSeen: false, time: DateTime.now().toUtc().toString());
            messages.add(loadingMessage);

            /// add image in firebase storage
            String? url = await firebase.addChatFiles(id, cameraImage.path);
            String? thumbnailUrl = await firebase.addChatFiles("$id+thumbnail", thumbnail);

            logPrint("url : - $url , ${imageMessage.text} , $thumbnailUrl");

            List storagePath = url!.split(chatArguments.imageBaseUrlFirebase);
            List thumbnailStoragePath = thumbnailUrl!.split(chatArguments.imageBaseUrlFirebase);

            /// update chatroom and messages list
            logPrint("url : - $url , ${imageMessage.text} , ${storagePath[1]}");
            MessageModel message = MessageModel(id: id,message: imageMessage.text, file: Files(fileName: fileName, fileMimeType: fileExt, fileType: imageList[counter].isVideo ?? false ? FileTypes.video.name : FileTypes.image.name, fileUrl: storagePath[1],isAdding:true, fileImageThumbnail: imageList[counter].isVideo ?? false ? thumbnailStoragePath[1] : ""), messageType: MessageType.file.name, sender: currentUserId.value, isSeen: false, time: DateTime.now().toUtc().toString());

            ChatRoomModel chatRoomModel = addChatRoomModel(message);
            firebase.addMessage(message, chatRoomModel);
            final index = messages.indexWhere((element) => element.id == message.id);
            messages[index] = message;
            File file = File(cameraImage.path);
            await file.delete(recursive: true);

            firebaseNotification.sendNotification("", currentUser.value, users.value.deviceToken ?? "", CallModel(), true, message, chatRoomModel.chatRoomId, chatArguments.firebaseServerKey, users.value, CallArguments(agoraChannelName: '', agoraToken: '', user: Users(), currentUser: Users(), callType: '', callId: '', imageBaseUrl: '', agoraAppId: '', agoraAppCertificate: '', userId: '', currentUserId: '', firebaseServerKey: ''));

            if (otherUserId.value != ChatHelpers.instance.userId) {
              await chatroomUpdates();
            }
          } catch (e) {
            final index = messages.indexWhere((element) => element.id == id);
            messages.removeAt(index);
            toastShow(massage: "Error sending image", error: true);
          }
        }

      }
    }catch(e){
      logPrint("Error uploading images ing : $e");
      toastShow(massage: "Error uploading images", error: true);
    }
  }

  Future<String> getVideoThumbnail(String url) async {
   try{
     final uint8list = await VideoThumbnail.thumbnailData(
       video: url,
       imageFormat: ImageFormat.JPEG,
       maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
       quality: 25,
     );
     Permission.storage.isGranted;
     var tempDir = await getExternalStorageDirectory();
     final imagePath = await File('${tempDir?.path}/image.png').create();
     await imagePath.writeAsBytes(uint8list??[]);
     logPrint("vidoe file thumbnail : ${imagePath.path} $uint8list , ${uint8list.runtimeType}");
     return imagePath.path;
   }catch(e){
     logPrint("error in video thumbnail fetching : $e}");
     return "";
   }
    // return uint8list ?? "";
  }

  /// app life cycle  state manage with online status
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        firebase.userActiveChatroom(chatRoomID.value, isScreenOn.value,
            isFirstUser.call, currentUserId.value);
        updatePresence(PresenceStatus.offline.name);
      case AppLifecycleState.resumed:
        firebase.userActiveChatroom(chatRoomID.value, isScreenOn.value,
            isFirstUser.call, currentUserId.value);
        updatePresence(PresenceStatus.online.name);
      case AppLifecycleState.paused:
        firebase.userActiveChatroom(chatRoomID.value, isScreenOn.value,
            isFirstUser.call, currentUserId.value);
        updatePresence(PresenceStatus.offline.name);
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
    }
  }

  ///  chat room updates all functions of chatroom call here
  Future<void> chatroomUpdates() async {
    /// fetch chat room detail
    chatRoomModel.value = await firebase.fetchChatRoom(chatRoomID.value);

    /// chatroom reference
    reference = await firebase.userActiveChatroomReference(chatRoomID.value);

    /// call fetch all messages
    updateChats();

    /// call last message updated
    recentMessage();

    scrollerListener();

    /// check current user is first or not in chatroom
    isFirstCurrent.value =
        chatRoomModel.value.userFirstId == currentUserId.value ? true : false;

    /// fetch other user details
    users.value = (isFirstCurrent.isTrue
            ? await firebase
                .fetchUser(chatRoomModel.value.userSecond?.userId ?? "")
            : await firebase
                .fetchUser(chatRoomModel.value.userFirst?.userId ?? "")) ??
        Users();

    /// call read typing status
    await readingTypingPresence();

    /// update active status of current user in chat room
    firebase.userActiveChatroom(chatRoomID.value, isScreenOn.value,
        isFirstUser.call, currentUserId.value);

    /// read active status of users with listner
    await updateActiveStatus();

    /// update user prescnse in app
    readPresence();
  }

  /// update active status of users if he is online in chat room
  Future<void> updateActiveStatus() async {
    try {
      activeStatusListener = reference!.snapshots().listen((event) {
        if (event.exists) {
          chatRoomModel.value = ChatRoomModel.fromJson(event.data() ?? {});
          return;
        } else {
          return;
        }
      });
    } catch (e) {
      logPrint("error updating active status :$e");
    }
  }

  downloadFileFromServer(int index) async {
    isDownloadingStart.value = true;

    try {
      DownloadHelper().createFolderAndDownloadFile(
          url: chatArguments.imageBaseUrlFirebase +
              (messages[index].file?.fileUrl ?? ""),
          fileName: messages[index].file?.fileName ?? "",
          onSuccess: () {
            isDownloadingStart.value = false;
          },
          onError: () {
            isDownloadingStart.value = false;
          });
    } catch (e) {
      logPrint("error downloading file : $e");
      isDownloadingStart.value = false;
    }
  }

  void scrollerListener(){
    scrollController.addListener(() async {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      if(oldMessages.isNotEmpty){
        if (maxScroll == currentScroll) {
          try {
            oldMessages.clear();
            isLoadingPreviousChats.value = false;
            Query<Map<String, dynamic>>? reference =
            await firebase.updateMessages(chatRoomID.value, 15, true,messages.first);
            QuerySnapshot<Map<String, dynamic>> data = await reference!.get();
            for (var element in data.docs) {
              MessageModel messageModel = MessageModel.fromJson(element.data());
              bool isFile = messageModel.messageType == "file";
              messageModel.file?.fileUrl = isFile ? chatArguments.imageBaseUrlFirebase+(messageModel.file?.fileUrl??"") : (messageModel.file?.fileUrl??"");
              oldMessages.add(messageModel);
            }
            if(oldMessages.isNotEmpty){
              messages.insertAll(0, oldMessages.reversed.toList());
            }else{
              toastShow(massage: "no previous Chats Available", error: false);
            }
            isLoadingPreviousChats.value = true;
          } catch (e) {
            isLoadingPreviousChats.value = true;
            logPrint("error message fetch : $e");
          }
        }
      }
    });
  }

  /// call in init method
  Future<void> initServices() async {
    /// get all details with arguments
    chatArguments = Get.find<ChatServices>().chatArguments;
    logPrint("image arguments : ${chatArguments.imageArguments?.isAudioRecorderEnable}");
    imageArguments = chatArguments.imageArguments;
    themeArguments = chatArguments.themeArguments;

    if ((Get.arguments[ChatHelpers.instance.currentUserID] == "" &&
        Get.arguments[ChatHelpers.instance.otherUserID] == "")) {
      isError.value = true;
      isLoadingChats.value = false;
      // Future.delayed(const Duration(seconds: 5),toastShow(massage: "required details are missing", error: true));
    } else {
      currentUserId.value = Get.arguments[ChatHelpers.instance.currentUserID];
      agoraToken.value = Get.arguments[ChatHelpers.instance.agoraToken];
      otherUserId.value = Get.arguments[ChatHelpers.instance.otherUserID];
      agoraChannelName.value =
          Get.arguments[ChatHelpers.instance.agoraChannelName];

      isScreenOn.value = true;

      updatePresence(PresenceStatus.online.name);

      if (otherUserId.value != "" || currentUserId.value != "") {
        users.value = (await firebase.fetchUser(otherUserId.value)) ?? Users();
        currentUser.value =
            (await firebase.fetchUser(currentUserId.value)) ?? Users();
        isUserId.value = true;
        getChatRoomId(otherUserId.value, currentUserId.value);
        chatRoomModel.value = await firebase.fetchChatRoom(chatRoomID.value);
        chatRoomModel.value.chatRoomId?.isNotEmpty ?? false
            ? chatroomUpdates()
            : null;
        isLoadingChats.value = false;
      }
    }
  }


  /// for audio record
  Future<void> record() async {
    try{
      final hasPermission = await recorderController.checkPermission();  // Check mic permission (also called during record)
      if(hasPermission){
        recorderController = RecorderController()
          ..androidEncoder = AndroidEncoder.aac
          ..androidOutputFormat = AndroidOutputFormat.mpeg4
          ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
          ..sampleRate = 16000;
        isAudioRecorderStart.value = true;
        await recorderController.record();
      }else{
        PermissionStatus status = await Permission.microphone.request();
        if(status.isGranted){
          recorderController = RecorderController();
          isAudioRecorderStart.value = true;
          await recorderController.record();
        }else{
          toastShow(massage: "Please allow microphone permission to record", error: true);
        }
      }
    }catch(e){
      logPrint("error in starting record file : $e");
    }
  }

  void stopRecorder(bool isStop) async {
    try{
      if(isStop) {
        final path = await recorderController.stop();
        isAudioRecorderStart.value = false;
        recorderController.refresh();
        recorderController.dispose();
        uploadAudioFile(path??"");
      }
      else{
        isAudioRecorderStart.value = false;
        recorderController.refresh();
        recorderController.dispose();
      }
    }catch(e){
      logPrint("error in stopping record file : $e");
    }
  }

  uploadAudioFile(String path) async {
    String id = getRandomString();
    if ( path != "") {
      try {
        File audioFile = File(path);
        String fileName = audioFile.path.split('/').last;

        /// get file extension of a file
        String fileExt = getFileExtension(fileName)!;



        MessageModel loadingMessage = MessageModel(id: id,file: Files(fileName: fileName, fileMimeType: fileExt, fileType: FileTypes.audio.name, fileUrl: audioFile.path,isAdding:false), messageType: MessageType.file.name, sender: currentUserId.value, isSeen: false, time: DateTime.now().toUtc().toString());
        messages.add(loadingMessage);

        /// add image in firebase storage
        String? url = await firebase.addChatFiles(id, audioFile.path);

        logPrint("url : - $url ");

        List storagePath = url!.split(chatArguments.imageBaseUrlFirebase);

        /// update chatroom and messages list
        logPrint("url : - $url , ${storagePath[1]}");
        MessageModel message = MessageModel(id: id,file: Files(fileName: fileName, fileMimeType: fileExt, fileType: FileTypes.audio.name, fileUrl: storagePath[1],isAdding:true), messageType: MessageType.file.name, sender: currentUserId.value, isSeen: false, time: DateTime.now().toUtc().toString());

        ChatRoomModel chatRoomModel = addChatRoomModel(message);
        firebase.addMessage(message, chatRoomModel);
        final index = messages.indexWhere((element) => element.id == message.id);
        messages[index] = message;


        firebaseNotification.sendNotification("", currentUser.value, users.value.deviceToken ?? "", CallModel(), true, message, chatRoomModel.chatRoomId, chatArguments.firebaseServerKey, users.value, CallArguments(agoraChannelName: '', agoraToken: '', user: Users(), currentUser: Users(), callType: '', callId: '', imageBaseUrl: '', agoraAppId: '', agoraAppCertificate: '', userId: '', currentUserId: '', firebaseServerKey: ''));

        if (otherUserId.value != ChatHelpers.instance.userId) {
          await chatroomUpdates();
        }

        File file = File(audioFile.path);
        await file.delete(recursive: true);
      } catch (e) {
        final index = messages.indexWhere((element) => element.id == id);
        messages.removeAt(index);
        toastShow(massage: "Error sending audio file ", error: true);
      }
    }
  }

}
