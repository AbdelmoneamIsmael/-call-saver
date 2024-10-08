import 'dart:ui';

import 'package:call_saver/modules/home/controller/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Updatewidget extends StatefulWidget {
  const Updatewidget({super.key});

  @override
  State<Updatewidget> createState() => _UpdatewidgetState();
}

class _UpdatewidgetState extends State<Updatewidget> {
  TextEditingController activationKeyController = TextEditingController();

  @override
  void dispose() {
    activationKeyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
  @override

  /// Build the widget for the update dialog.
  ///
  /// This widget is shown when there is an update available.
  ///
  /// The widget is a [BackdropFilter] that blurs the background and a
  /// [Container] that contains the contents of the dialog.
  ///
  /// The contents of the dialog include a progress bar, a text that says
  /// "Update Available", and a text that says "Please Enter Your Activation Key".
  ///
  /// The dialog is positioned at the bottom of the screen.
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 4,
        sigmaY: 4,
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black.withOpacity(0.65),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: GetBuilder<HomePageController>(
              builder: (controller) => Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 3,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 165, 164, 164),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Activation Key',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Please Enter Your Activation Key",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextFormField(
                        controller: activationKeyController,
                        decoration: const InputDecoration(
                          hintText: "Enter Activation Key",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.setActivationKey(activationKeyController.text);
                      },
                      child: const Text('Activate'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
