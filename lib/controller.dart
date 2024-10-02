import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<String> algorithmList = [
    "Caesar",
    "Vigenere",
  ].obs;

  RxString selectedAlgorithm = "Caesar".obs;

  void selectAlgorithm(String algorithm) {
    selectedAlgorithm.value = algorithm;
  }

  RxInt numberKey = 3.obs;
  RxString stringKey = "A".obs;

  final Rx<TextEditingController> numberKeyController =
      TextEditingController().obs;
  final Rx<TextEditingController> stringKeyController =
      TextEditingController().obs;

  RxBool isTopPlainText = true.obs;

  void switchContainer() {
    isTopPlainText.value = !isTopPlainText.value;
  }

  RxString plainText = "".obs;
  RxString cipherText = "".obs;

  final Rx<TextEditingController> plainTextController =
      TextEditingController().obs;
  final Rx<TextEditingController> cipherTextController =
      TextEditingController().obs;

  void copyToClipboard(bool isPlainText) {
    Clipboard.setData(
      ClipboardData(
        text: isPlainText ? plainText.value : cipherText.value,
      ),
    );
  }

  Future<void> pasteToClipboard(bool isPlainText) async {
    var clipboardData = await Clipboard.getData('text/plain');

    if (clipboardData != null && clipboardData.text != null) {
      if (isPlainText) {
        plainTextController.value.text = clipboardData.text!;
        plainText.value = clipboardData.text!;
      } else {
        cipherTextController.value.text = clipboardData.text!;
        cipherText.value = clipboardData.text!;
      }

      updateTextField();
    }
  }

  void clearText(bool isPlainText) {
    if (isPlainText) {
      plainTextController.value.clear();
      plainText = "".obs;
    } else {
      cipherTextController.value.clear();
      cipherText = "".obs;
    }
  }

  void updateTextField() {
    if (selectedAlgorithm.value == "Caesar") {
      if (isTopPlainText.value) {
        cipherText.value = caesarEncrypt(plainText.value, numberKey.value);
        cipherTextController.value.text = cipherText.value;
      } else {
        plainText.value = caesarEncrypt(cipherText.value, -numberKey.value);
        plainTextController.value.text = plainText.value;
      }
    } else if (selectedAlgorithm.value == "Vigenere") {
      if (isTopPlainText.value) {
        cipherText.value =
            vigenereCipher(plainText.value, stringKey.value, true);
        cipherTextController.value.text = cipherText.value;
      } else {
        plainText.value =
            vigenereCipher(cipherText.value, stringKey.value, false);
        plainTextController.value.text = plainText.value;
      }
    }
  }

  String caesarEncrypt(String plainText, int shift) {
    const int asciiLowerA = 97;
    const int asciiLowerZ = 122;
    const int asciiUpperA = 65;
    const int asciiUpperZ = 90;

    String encryptedText = '';

    for (int i = 0; i < plainText.length; i++) {
      int charCode = plainText.codeUnitAt(i);

      if (charCode >= asciiUpperA && charCode <= asciiUpperZ) {
        charCode = ((charCode - asciiUpperA + shift) % 26) + asciiUpperA;
      } else if (charCode >= asciiLowerA && charCode <= asciiLowerZ) {
        charCode = ((charCode - asciiLowerA + shift) % 26) + asciiLowerA;
      }

      encryptedText += String.fromCharCode(charCode);
    } 

    return encryptedText;
  }

  String vigenereCipher(String text, String key, bool isEncrypt) {
    key = key.toUpperCase();
    String result = '';
    int keyIndex = 0;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        int charCode = char.toUpperCase().codeUnitAt(0) - 65;
        int keyCode = key[keyIndex % key.length].codeUnitAt(0) - 65;
        int shift = isEncrypt ? keyCode : -keyCode;
        int newCharCode = (charCode + shift) % 26;
        if (newCharCode < 0) newCharCode += 26;
        result += String.fromCharCode(
            newCharCode + (char == char.toUpperCase() ? 65 : 97));
        keyIndex++;
      } else {
        result += char;
      }
    }

    return result;
  }
}
