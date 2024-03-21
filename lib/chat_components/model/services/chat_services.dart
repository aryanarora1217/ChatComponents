import 'package:chatcomponent/chat_components/model/chat_arguments/chat_arguments.dart';
import 'package:get/get.dart';

class ChatServices extends GetxService{

  late ChatArguments chatArguments;

  Future<ChatServices> init(ChatArguments chatArgument) async {
    chatArguments = chatArgument;
    return this;
  }

}