import 'dart:async';
import 'dart:io';
import 'package:chatcomponent/chat_components/model/chatHelper/chat_helper.dart';
import 'package:chatcomponent/chat_components/model/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../view/widgets/log_print/log_print_condition.dart';
import '../models/call_model/call_model.dart';
import '../models/chat_model/chat_model.dart';
import '../models/message_model/message_model.dart';

class FirebaseDataBase {


/// firebase method for fetching user details
  Future<Users?> fetchUser(String id) async {
    Users users = Users();
    try{
      var documentSnapshot = FirebaseFirestore.instance
          .collection(ChatHelpers.instance.users)
          .doc(id)
          .get();
      Map<String, dynamic> data = {};
      await documentSnapshot.then((value) async {
        data = value.data() ?? <String, dynamic>{};
        users = Users.fromJson(data);
      });
    }catch(e){
      logPrint(" error fecthing user : $e");
    }
    return users;
  }

/// upload file o firebase storage and get url of file
  Future<String?> addChatFiles(String messageId, String file) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child(ChatHelpers.instance.chats).child(messageId);
      UploadTask storageUploadTask = ref.putFile(File(file));

      String url = await storageUploadTask.then((res) {
        return res.ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      logPrint("error Uploading Image : $e");
    }
    return null;
  }


/// fetch chatroom details form firebase
  Future<ChatRoomModel> fetchChatRoom(String chatRoomId) async {
    ChatRoomModel chatRoomModel = ChatRoomModel();
    try{
      await FirebaseFirestore.instance
          .collection(ChatHelpers.instance.chats)
          .where('chatroom_id',isEqualTo: chatRoomId).get().then((value) {
            if(value.docs.isNotEmpty){
              chatRoomModel = ChatRoomModel.fromJson(value.docs.first.data());
            }
      });
    }catch(e){
      logPrint("fetch ing error chatRoom: $e");
    }
    return chatRoomModel;
  }

/// chatroom message fetch
  Query<Map<String, dynamic>>? updateChatRoom(String chatRooms, int limit, bool desc) {
    try {
      Query<Map<String, dynamic>> reference = FirebaseFirestore.instance
          .collection(ChatHelpers.instance.chats)
          .doc(chatRooms)
          .collection("messages").limit(limit)
          .orderBy("time", descending: desc);
      return reference;
    } catch (e) {
      logPrint("error fetching messages : $e");
    }
    return null;
  }


/// typing status updates
  Future<void> userTypingStatus(String chatRoom, bool status,String currentUserId) async {
    try {
      DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore
          .instance
          .collection(ChatHelpers.instance.chats)
          .doc(chatRoom);
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await reference.get();
      ChatRoomModel chatRoomModel =
          ChatRoomModel.fromJson(querySnapshot.data() ?? {});
      if (chatRoomModel.userSecondId ==
          currentUserId) {
        chatRoomModel.userSecond?.userTypingStatus = status;
        reference.update(chatRoomModel.toJson());
      } else if (chatRoomModel.userFirstId ==
          currentUserId) {
        chatRoomModel.userFirst?.userTypingStatus = status;
        reference.update(chatRoomModel.toJson());
      }
    } catch (e) {
      logPrint("error fetching messages : $e");
    }
  }


  /// user active status update in chatroom
  Future<ChatRoomModel?> userActiveChatroom(String chatRoom, bool active, Function(bool) isFirstUser,String currentUserId) async {
    try {
      DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore
          .instance
          .collection(ChatHelpers.instance.chats)
          .doc(chatRoom);

      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await reference.get();
      logPrint("chatroom update active status $active ");
      ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(querySnapshot.data() ?? {});

      if (chatRoomModel.userSecondId == currentUserId) {
        chatRoomModel.userSecond?.userActiveStatus = active;
        chatRoomModel.userFirst?.userActiveStatus;

        if(chatRoomModel.recentMessage?.sender != currentUserId){
          chatRoomModel.recentMessage?.isSeen = true;
        }

        reference.update(chatRoomModel.toJson());
        isFirstUser.call(false);

        if (active != false) {
          seenMessage(chatRoom, chatRoomModel.userFirstId ?? "");
        }
        return chatRoomModel;

      }
      else if (chatRoomModel.userFirstId == currentUserId) {
        chatRoomModel.userFirst?.userActiveStatus = active;

        if(chatRoomModel.recentMessage?.sender != currentUserId){
          chatRoomModel.recentMessage?.isSeen = true;
        }

        reference.update(chatRoomModel.toJson());
        isFirstUser.call(true);

        if (active != false) {
          seenMessage(chatRoom, chatRoomModel.userSecondId ?? "");
        }
        return chatRoomModel;
      }

    } catch (e) {
      logPrint("error updating user active status : $e");
      return ChatRoomModel();
    }
    return ChatRoomModel();
  }


  /// chat room reference for active status of chatroom
  Future<DocumentReference<Map<String, dynamic>>> userActiveChatroomReference(String chatRoom) async {
      DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection(ChatHelpers.instance.chats).doc(chatRoom);
      return reference;
  }


  /// seen message update method for updating all unseen messages to seen status
  Future<void> seenMessage(String chatRoomId, String userId) async {
    FirebaseFirestore.instance
        .collection(ChatHelpers.instance.chats)
        .doc(chatRoomId)
        .collection("messages")
        .where("sender", isEqualTo: userId)
        .get()
        .then((event) {
      for (var element in event.docs) {
        MessageModel message = MessageModel.fromJson(element.data());
        message.isSeen = true;
        FirebaseFirestore.instance
            .collection(ChatHelpers.instance.chats)
            .doc(chatRoomId)
            .collection("messages")
            .doc(message.id)
            .update(message.toJson());
      }
    });
  }

  /// add message in firebase database
  Future<void> addMessage(MessageModel message, ChatRoomModel chatRoomModel) async {
    try {
      DocumentReference<Map<String, dynamic>> reference = await chatRoomIdReference(chatRoomModel.chatRoomId ?? "");
      await reference.set(chatRoomModel.toJson());
      await reference.collection("messages")
          .doc(message.id)
          .set(message.toJson());
    } catch (e) {
      logPrint("Error updating messages : $e");
    }
  }


/// chat room refernce for  listner
  Future<DocumentReference<Map<String, dynamic>>> chatRoomIdReference(String chatRoomId) async {
    DocumentReference<Map<String, dynamic>> reference ;
    reference = FirebaseFirestore.instance.collection(ChatHelpers.instance.chats).doc(chatRoomId);
    return reference;
  }


  /// read typing status in chat room
  Future<DocumentReference<Map<String, dynamic>>?> readTypingStatus(String chatRoom) async {
    DocumentReference<Map<String, dynamic>>? reference;
    try {
      reference = FirebaseFirestore.instance
          .collection(ChatHelpers.instance.chats)
          .doc(chatRoom);
    } catch (e) {
      logPrint("error fetching messages : $e");
    }
    return reference;
  }

/// read user presence in app
  Future<DocumentReference<Map<String, dynamic>>> readPresence(String userId) async {
      DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection(ChatHelpers.instance.users).doc(userId);
      return reference;
  }



  /// add call in firebase database
  Future<void> addCall(CallModel callModel) async {
    CollectionReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.collection(ChatHelpers.instance.calls);
    await reference.doc(callModel.callId ?? "").set(callModel.toJson());
  }

  /// update call status in database
  Future<void> updateCallStatus(CallModel callModel) async {
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore
        .instance
        .collection(ChatHelpers.instance.calls)
        .doc(callModel.callId);
    await reference.update(callModel.toJson());
  }

  Future<void> updatePresence(String status, String userId) async {
    Users users = Users();
    try {
      var documentSnapshot = FirebaseFirestore.instance
          .collection(ChatHelpers.instance.users)
          .doc(userId)
          .get();
      Map<String, dynamic> data = {};
      await documentSnapshot.then((value) async {
        data = value.data() ?? <String, dynamic>{};
        users = Users.fromJson(data);
        users.presence = status;
        FirebaseFirestore.instance
            .collection(ChatHelpers.instance.users)
            .doc(users.id)
            .set(users.toJson());
      });
    }
    catch(e){
      logPrint("Error updating presence :$e");
    }
  }

/// call reference for listners
  DocumentReference<Map<String, dynamic>> callReferenceById(String id) {
    return FirebaseFirestore.instance
        .collection(ChatHelpers.instance.calls)
        .doc(id);
  }

  /// recent message refernce of chat room messages
  DocumentReference<Map<String, dynamic>> recentMessageRef(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection(ChatHelpers.instance.chats)
        .doc(chatRoomId);
  }

}