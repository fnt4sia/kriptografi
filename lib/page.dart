import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriptografi/controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    controller.numberKeyController.value.text =
        controller.numberKey.value.toString();
    controller.stringKeyController.value.text = controller.stringKey.value;

    return Placeholder(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff30393b),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kriptografi Converter',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.algorithmList
                          .map(
                            (algorithm) => algorithmContainer(
                              algorithm,
                              controller.selectedAlgorithm.value == algorithm,
                              () {
                                controller.selectAlgorithm(algorithm);
                                controller.updateTextField();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => controller.selectedAlgorithm.value == "Caesar" ||
                          controller.selectedAlgorithm.value == "Scytale"
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          height: 70,
                          child: TextField(
                            controller: controller.numberKeyController.value,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.numberKey.value = 0;
                              } else {
                                try {
                                  controller.numberKey.value = int.parse(value);
                                } catch (e) {
                                  controller.numberKey.value = 0;
                                }
                              }

                              controller.updateTextField();
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              hintText: "Input Key",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w300,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff04d9ef),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          height: 70,
                          child: TextField(
                            controller: controller.stringKeyController.value,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                controller.stringKey.value = "0";
                              } else {
                                try {
                                  controller.stringKey.value = value;
                                } catch (e) {
                                  controller.stringKey.value = "0";
                                }
                              }

                              controller.updateTextField();
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              hintText: "Input Key",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w300,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff04d9ef),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => converterContainer(
                    true,
                    controller.isTopPlainText.value,
                    controller,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    controller.switchContainer();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.swap_vert,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => converterContainer(
                    false,
                    !controller.isTopPlainText.value,
                    controller,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget algorithmContainer(String title, bool isActive, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.black.withOpacity(0.7) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget converterContainer(
      bool isTop, bool isPlainText, HomeController controller) {
    return Obx(
      () => Column(
        children: [
          isTop
              ? Text(
                  isPlainText ? "Plain Text" : "Cipher Text",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          isTop ? const SizedBox(height: 10) : const SizedBox(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      controller.copyToClipboard(isPlainText);
                      controller.updateTextField();
                    },
                    child: const Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  isTop
                      ? InkWell(
                          onTap: () async {
                            await controller.pasteToClipboard(isPlainText);
                            controller.updateTextField();
                          },
                          child: const Icon(
                            Icons.paste,
                            color: Colors.white,
                            size: 28,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                  isTop
                      ? InkWell(
                          onTap: () {
                            controller.clearText(isPlainText);
                            controller.updateTextField();
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xff04d9ef),
                    ),
                  ),
                  height: 200,
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    controller: isPlainText
                        ? controller.plainTextController.value
                        : controller.cipherTextController.value,
                    onChanged: (value) {
                      isPlainText
                          ? controller.plainText.value = value
                          : controller.cipherText.value = value;
                      controller.updateTextField();
                    },
                    enabled: isTop,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      hintText: isTop ? "Input Text" : "",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w300,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          !isTop ? const SizedBox(height: 10) : const SizedBox(),
          !isTop
              ? Text(
                  isPlainText ? "Plain Text" : "Cipher Text",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
