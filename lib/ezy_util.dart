import 'dart:math';

class UUID {
  static const _CHARS = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  UUID._(){}

  static String random() {
    return "${_randomString(8)}-${_randomString(8)}-${_randomString(8)}-${_randomString(8)}";
  }

  static String _randomString(int length) {
    Random random = Random();
    return String.fromCharCodes(
        Iterable.generate(
            length, (_) => _CHARS.codeUnitAt(random.nextInt(_CHARS.length))
        )
    );
  }
}