import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app/app/core/utils/extensions.dart';

import '../../../data/models/task.dart';
import '../../details/views/details_page.dart';
import '../controllers/home_controller.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final squareWidth = Get.width - 12.0.wp;
    final color = HexColor.fromHex(task.color);

    return GestureDetector(
      onTap: () {
        homeCtrl.changeTask(task);
        homeCtrl.changeTodos(task.todos ?? []);
        Get.to(() => const DetailsPage());
      },
      child: Container(
        width: squareWidth / 2,
        height: squareWidth / 2,
        margin: EdgeInsets.all(3.0.wp),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 7,
            offset: const Offset(0, 7),
          )
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///===================================================================
            StepProgressIndicator(
              totalSteps: homeCtrl.isToDosEmpty(task) ? 1 : task.todos!.length,
              currentStep:
                  homeCtrl.isToDosEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
              size: 5,
              padding: 0,
              selectedGradientColor: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.5), color]),
              unselectedGradientColor: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.white]),
            ),

            ///===================================================================
            Padding(
              padding: EdgeInsets.all(6.0.wp),
              child: Icon(
                IconData(task.icon, fontFamily: "MaterialIcons"),
                color: color,
                size: 30,
              ),
            ),

            ///===================================================================
            Padding(
              padding: EdgeInsets.all(5.0.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 1.0.wp),
                  Text("${task.todos?.length ?? 0} Task"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
