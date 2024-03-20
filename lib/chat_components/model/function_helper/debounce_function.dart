import 'package:easy_debounce/easy_debounce.dart';

class DebounceHelper {
  static DebounceHelper? _instance;
  static DebounceHelper get instance => _instance ??= DebounceHelper();

  void debounceFunction({required Function() onDebounceCall, Duration? duration}) {
    EasyDebounce.debounce('my-debounce', duration??const Duration(milliseconds: 500), (){onDebounceCall();});
  }

}