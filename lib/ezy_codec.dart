import 'dart:typed_data';

import 'ezy_proxy.dart';

class EzyKeyPairProxy {
  late String publicKey;
  late Uint8List privateKey;

  EzyKeyPairProxy(this.publicKey, this.privateKey);
}

class EzyRSAProxy {
  static final EzyRSAProxy _INSTANCE = EzyRSAProxy._();

  EzyRSAProxy._();

  static EzyRSAProxy getInstance() {
    return _INSTANCE;
  }

  void _onKeyPairGenerated(Map result, Function(EzyKeyPairProxy) callback) {
    callback(EzyKeyPairProxy(result["publicKey"], result["privateKey"]));
  }

  void generateKeyPair(Function(EzyKeyPairProxy) callback) {
    EzyProxy.run("generateKeyPair", {}).then((result) => {
      _onKeyPairGenerated(result, callback)
    });
  }

  void decrypt(
      Uint8List message,
      Uint8List privateKey, Function(Uint8List) callback) {
    Map<String, Uint8List> params = {
      "message": message,
      "privateKey": privateKey
    };
    EzyProxy.run("rsaDecrypt", params).then((result) => {
      callback(result)
    });
  }
}
