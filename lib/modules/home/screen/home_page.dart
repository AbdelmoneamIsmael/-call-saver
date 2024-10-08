
import 'package:call_saver/modules/home/controller/home_page_controller.dart';
import 'package:call_saver/modules/home/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_state/phone_state.dart';

class HomeScreen extends GetView<HomePageController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Tracker'),
            centerTitle: true,
          ),
          body: GetBuilder<HomePageController>(
            builder: (controller) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //     height: 100,
                  //     width: 200,
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //       image: AssetImage('assets/images/app_Icon.png'),
                  //     ))),
                  Padding(
                    padding: const EdgeInsets.all(23.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'The Server ip',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      controller: controller.ipController,
                    ),
                  ),
                  const Text(
                    'Status of call',
                    style: TextStyle(fontSize: 24),
                  ),
                  if (controller.status.status ==
                          PhoneStateStatus.CALL_INCOMING ||
                      controller.status.status == PhoneStateStatus.CALL_STARTED)
                    Text(
                      'Number: ${controller.status.number}',
                      style: const TextStyle(fontSize: 24),
                    ),
                  Icon(
                    getIcons(),
                    color: getColor(),
                    size: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
        GetX<HomePageController>(builder: (controller) {
          return controller.isActivated.value
              ? const SizedBox()
              : const Updatewidget();
        }),
      ],
    );
  }

  IconData getIcons() {
    return switch (controller.status.status) {
      PhoneStateStatus.NOTHING => Icons.clear,
      PhoneStateStatus.CALL_INCOMING => Icons.add_call,
      PhoneStateStatus.CALL_STARTED => Icons.call,
      PhoneStateStatus.CALL_ENDED => Icons.call_end,
    };
  }

  Color getColor() {
    return switch (controller.status.status) {
      PhoneStateStatus.NOTHING || PhoneStateStatus.CALL_ENDED => Colors.red,
      PhoneStateStatus.CALL_INCOMING => Colors.green,
      PhoneStateStatus.CALL_STARTED => Colors.orange,
    };
  }
}
