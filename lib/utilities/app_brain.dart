import 'dart:math';
import 'package:encrypt/encrypt.dart';

class Brain {
  Brain({required this.key}) {
    setUp();
  }
  String key;
  String letters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890@#\$%!@#\$% ';
  Random random = Random();
  Encrypter? encryptor;
  IV? iv;

  void setUp() {
    print("We are in the brain's setup method");
    final _key = Key.fromUtf8(key);
    iv = IV.fromLength(16);
    encryptor = Encrypter(AES(_key));
  }

  String encrypt(String message) {
    print("We are in the brain's encrypt method");
    return encryptor!.encrypt(message, iv: iv).base64;
  }

  static generateKey(String username, String password, bool mode) {
    print("We are in the brain's generate key static method");
    String text = '$username.$password.${mode.toString()}';
    return text.padLeft(32, '*').substring(0, 32);
  }

  String decrypt(
    String message,
  ) {
    print("We are in the brain's decrypt method");
    return encryptor!.decrypt(Encrypted.fromBase64(message), iv: iv);
  }

  String generatePassword() {
    print("We are in the brain's generate password method");
    List<String> characters = letters.split('');
    characters.shuffle();
    int startPoint = random.nextInt(7);
    List<String> password =
        characters.sublist(startPoint, startPoint + 10 + random.nextInt(7));
    return password.join();
  }
}
