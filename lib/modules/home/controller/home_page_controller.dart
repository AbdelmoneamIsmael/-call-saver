import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:call_saver/modules/home/database/acticvate_db.dart';
import 'package:call_saver/modules/networking/api_server.dart';
import 'package:dio/dio.dart' as dd;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

class HomePageController extends GetxController {
  PhoneState status = PhoneState.nothing();
  final box = GetStorage();
  bool granted = false;
  bool isCallingStreamOpened = false;
  RxBool isActivated = false.obs;
  String activationKey = "";
  TextEditingController ipController = TextEditingController();
  StreamSubscription? subscription;

  @override
  Future<void> onInit() async {
    getSavedActivationKey();
    checkActivationKey();

    super.onInit();
  }

  void checkActivationKey() async {
    try {
      if (subscription != null) {
        subscription!.cancel();
      }
      var snapshot = await ActicvateDb.getActivationKey();

      subscription = snapshot.listen((snapshot) async {
        printInfo(info: snapshot.data().toString());
        if (snapshot.data()!["activation_key"] == activationKey) {
          isActivated.value = true;
          if (isCallingStreamOpened == false) {
            await intiateCallTrack();
          }
        } else {
          isActivated.value = false;
        }
        printInfo(info: isActivated.value.toString());
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> intiateCallTrack() async {
    if (Platform.isIOS) setStream();
    if (Platform.isAndroid) {
      while (granted != true) {
        bool temp = await requestPermission();
        granted = temp;
        if (granted) {
          setStream();
        }
      }
    }
  }

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  void setStream() {
    log("opening stream is");
    PhoneState.stream.listen((event) async {
      status = event;
      if (status.status == PhoneStateStatus.CALL_INCOMING ||
          status.status == PhoneStateStatus.CALL_STARTED) {
        if (status.number != null) {
          log(status.status.toString());
          log(status.number.toString());

          try {
            var res = await addNumber();
            log("response is");
            log(res.toString());
          } on Exception catch (e) {
            log(e.toString());
            Get.snackbar("Error", "this ip is not a server ip");
          }
        }
      }

      update();
    });
  }

  Future<Map<String, dynamic>> addNumber() async {
    if (ipController.text.isEmpty) {
      Get.snackbar("Error", "ip is empty");
      return {"message": "ip is empty"};
    }
    try {
      log("heeeeeeeeeeere call");
      ApiServer().setDio(
        dd.Dio(
          dd.BaseOptions(
            baseUrl: "http://${ipController.text}:5000/api/",
          ),
        ),
      );
      var res = await ApiServer().post(
        baseUrl: "http://${ipController.text}:5000/api/",
        endPoint: "number",
        data: dd.FormData.fromMap({
          "phoneNumber": "${status.number}",
        }),
      );
      return res;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar("Error", "this ip is not a server ip");
      return {"message": e.toString()};
    }
  }

  void getSavedActivationKey() {
    activationKey = box.read("activationKey") ?? "fEEH6Cnsq5FWWRqLgJv";
  }

  void setActivationKey(String text) {
    box.write("activationKey", text);

    getSavedActivationKey();
    checkActivationKey();
  }
}
