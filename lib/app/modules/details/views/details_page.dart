import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/modules/home/controllers/home_controller.dart';

import '../components/doing_list.dart';
import '../components/done_list.dart';

class DetailsPage extends GetView<HomeController> {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final task = homeCtrl.task.value;
    final color = HexColor.fromHex(task!.color);
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            ///=================================================================
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 1.0.wp, vertical: 1.0.hp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        homeCtrl.changeTask(null);
                        homeCtrl.editeCtrl.clear();
                      },
                      icon: const Icon(Icons.arrow_back_ios_sharp)),
                ],
              ),
            ),

            ///=================================================================
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 4.0.wp, vertical: 2.0.hp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    IconData(task.icon, fontFamily: 'MaterialIcons'),
                    color: HexColor.fromHex(task.color),
                    size: 30,
                  ),
                  SizedBox(width: 2.0.wp),
                  Text(
                    task.title,
                    style: TextStyle(
                        fontSize: 12.0.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            ///=================================================================
            Obx(() {
              int totalTodos =
                  homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0.wp),
                child: Row(
                  children: [
                    Text(
                      '$totalTodos Total',
                      style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 5.0.wp),
                    Expanded(
                      child: StepProgressIndicator(
                        totalSteps: totalTodos == 0 ? 1 : totalTodos,
                        currentStep: homeCtrl.doneTodos.length,
                        size: 5,
                        padding: 0.1,
                        selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color]),
                        unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!]),
                      ),
                    ),
                  ],
                ),
              );
            }),

            ///=================================================================

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 5.0.wp, vertical: 4.0.hp),
              child: TextFormField(
                controller: homeCtrl.editeCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!)),
                  prefixIcon: Icon(Icons.check_box_outline_blank,
                      color: Colors.grey[400]!),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (homeCtrl.formKey.currentState!.validate()) {
                        var success = homeCtrl.addTodo(homeCtrl.editeCtrl.text);
                        if (success) {
                          EasyLoading.showSuccess("TODO Item Add Success");
                          homeCtrl.changeTask(null);
                        } else {
                          EasyLoading.showError("TODO Item Already Exist");
                        }
                        homeCtrl.editeCtrl.clear();
                      }
                    },
                    icon: const Icon(Icons.check),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter Your TODO";
                  }
                  return null;
                },
              ),
            ),

            ///=================================================================
            const DoingList(),
            const DoneList(),
          ],
        ),
      )),
      // floatingActionButton: DragTarget(
      //   builder: (_, __, ___) => Obx(
      //     () => FloatingActionButton(
      //       onPressed: () {
      //         if (controller.tasks.isNotEmpty) {
      //           Get.to(() => const AddDialog(),
      //               transition: Transition.downToUp);
      //         } else {
      //           EasyLoading.showInfo('Please Create Your Task Type');
      //         }
      //       },
      //       backgroundColor:
      //           controller.deleting.value ? Colors.red : AppColors.blue,
      //       child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
      //     ),
      //   ),
      //   onAccept: (Task task) {
      //     controller.deleteTask(task);
      //     EasyLoading.showSuccess('Delete Success');
      //   },
      // ),
    );
  }
}
