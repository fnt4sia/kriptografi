import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<String> algorithmList = [
    "Caesar",
    "Vigenere",
    "XOR",
    "Stream",
    "Super",
  ].obs;

  RxString selectedAlgorithm = "Caesar".obs;

  void selectAlgorithm(String algorithm) {
    selectedAlgorithm.value = algorithm;
  }

  RxInt caesarKey = 3.obs;
  RxString vigenereKey = 'KEY'.obs;
  RxInt xorKey = 3.obs;
  RxList<int> streamKey = <int>[1, 2].obs;

  void setStreamKeyFromInput(String input) {
    streamKey.value =
        input.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
  }

  final Rx<TextEditingController> caesarKeyController =
      TextEditingController().obs;
  final Rx<TextEditingController> vigenereKeyController =
      TextEditingController().obs;
  final Rx<TextEditingController> xorKeyController =
      TextEditingController().obs;
  final Rx<TextEditingController> streamKeyController =
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
        cipherText.value = caesarEncrypt(plainText.value, caesarKey.value);
        cipherTextController.value.text = cipherText.value;
      } else {
        plainText.value = caesarEncrypt(cipherText.value, -caesarKey.value);
        plainTextController.value.text = plainText.value;
      }
    } else if (selectedAlgorithm.value == "Vigenere") {
      if (isTopPlainText.value) {
        cipherText.value =
            vigenereCipher(plainText.value, vigenereKey.value, true);
        cipherTextController.value.text = cipherText.value;
      } else {
        plainText.value =
            vigenereCipher(cipherText.value, vigenereKey.value, false);
        plainTextController.value.text = plainText.value;
      }
    } else if (selectedAlgorithm.value == "XOR") {
      if (isTopPlainText.value) {
        cipherText.value = xorCipher(plainText.value, xorKey.value);
        cipherTextController.value.text = cipherText.value;
      } else {
        plainText.value = xorCipher(cipherText.value, xorKey.value);
        plainTextController.value.text = plainText.value;
      }
    } else if (selectedAlgorithm.value == "Stream") {
      if (isTopPlainText.value) {
        cipherText.value =
            streamCipher(plainText.value, List<int>.from(streamKey));
        cipherTextController.value.text = cipherText.value;
      } else {
        plainText.value =
            streamCipher(cipherText.value, List<int>.from(streamKey));
        plainTextController.value.text = plainText.value;
      }
    } else {
      if (isTopPlainText.value) {
        String tempText = plainText.value;

        tempText = caesarEncrypt(tempText, caesarKey.value);
        tempText = vigenereCipher(tempText, vigenereKey.value, true);
        tempText = xorCipher(tempText, xorKey.value);
        cipherText.value = streamCipher(tempText, List<int>.from(streamKey));
        cipherTextController.value.text = cipherText.value;
      } else {
        String tempText = cipherText.value;

        tempText = streamCipher(tempText, List<int>.from(streamKey));
        tempText = xorCipher(tempText, xorKey.value);
        tempText = vigenereCipher(tempText, vigenereKey.value, false);
        plainText.value = caesarEncrypt(tempText, -caesarKey.value);
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

  String xorCipher(String text, int key) {
    return String.fromCharCodes(text.codeUnits.map((unit) => unit ^ key));
  }

  String streamCipher(String text, List<int> keyStream) {
    if (text.isEmpty || keyStream.isEmpty) {
      return text;
    }

    try {
      return String.fromCharCodes(text.codeUnits.asMap().entries.map((entry) {
        int i = entry.key;
        return entry.value ^ keyStream[i % keyStream.length];
      }));
    } catch (e) {
      return text;
    }
  }
}
