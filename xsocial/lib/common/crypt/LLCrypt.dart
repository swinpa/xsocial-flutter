import 'dart:convert';
import 'package:crypto/crypto.dart';


enum HmacAlgorithm {
  md5,
  sha1,
  sha224,
  sha256,
  sha384,
  sha512,
}

final class LLCrypt {

  const LLCrypt._();

/*
  static String encrypt(String input) {
    final key = Key.fromUtf8(iv);
    final ivObj = IV.fromUtf8(iv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(input, iv: ivObj);
    return encrypted.base64;
  }

  static String decrypt(String input) {
    final key = Key.fromUtf8(iv);
    final ivObj = IV.fromUtf8(iv);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(input, iv: ivObj);
    return decrypted;
  }
  */


  static String llmd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String hmac(
      String data,
      HmacAlgorithm algorithm,
      String key,
    ) {
      Hash hash;

      switch (algorithm) {
        case HmacAlgorithm.md5:
          hash = md5;
          break;
        case HmacAlgorithm.sha1:
          hash = sha1;
          break;
        case HmacAlgorithm.sha224:
          hash = sha224;
          break;
        case HmacAlgorithm.sha256:
          hash = sha256;
          break;
        case HmacAlgorithm.sha384:
          hash = sha384;
          break;
        case HmacAlgorithm.sha512:
          hash = sha512;
          break;
      }

      final hmac = Hmac(hash, utf8.encode(key));
      final digest = hmac.convert(utf8.encode(data));
      return digest.toString();
    }
}