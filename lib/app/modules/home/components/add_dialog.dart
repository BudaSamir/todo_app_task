import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';

import '../../../core/values/app_colors.dart';
import '../controllers/home_controller.dart';

class AddDialog extends StatelessWidget {
  const AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              ///=================================================================
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                          homeCtrl.editeCtrl.clear();
                          homeCtrl.changeTask(null);
                        },
                        icon: const Icon(Icons.close)),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            if (homeCtrl.task.value == null) {
                              EasyLoading.showError("Please Select Task Type");
                            } else {
                              var success = homeCtrl.updateTask(
                                homeCtrl.task.value!,
                                homeCtrl.editeCtrl.text,
                              );
                              if (success) {
                                EasyLoading.showSuccess(
                                    "TODO Item Add Success");
                                Get.back();
                                homeCtrl.changeTask(null);
                              } else {
                                EasyLoading.showError(
                                    "TODO Item Already Exist");
                              }
                              homeCtrl.editeCtrl.clear();
                            }
                          }
                        },
                        child: Text(
                          "DONE",
                          style: TextStyle(
                            fontSize: 14.0.sp,
                          ),
                        ))
                  ],
                ),
              ),

              ///=================================================================
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.0.wp, vertical: 6.0.wp),
                child: TextFormField(
                  controller: homeCtrl.editeCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "NEW TASK",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please Enter Your Task Title";
                    }
                    return null;
                  },
                ),
              ),

              ///=================================================================

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  "ADD To",
                  style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                ),
              ),

              ///=================================================================

              ...homeCtrl.tasks.map((task) => Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp, horizontal: 4.0.wp),
                      child: InkWell(
                        onTap: () => homeCtrl.changeTask(task),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  IconData(task.icon,
                                      fontFamily: 'MaterialIcons'),
                                  color: HexColor.fromHex(task.color),
                                ),
                                SizedBox(width: 2.0.wp),
                                Text(
                                  task.title,
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            if (homeCtrl.task.value == task)
                              const Icon(
                                Icons.check,
                                color: AppColors.green,
                              )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
