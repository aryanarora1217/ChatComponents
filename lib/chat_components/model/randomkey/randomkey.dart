import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString() => String.fromCharCodes(Iterable.generate(
    20, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));