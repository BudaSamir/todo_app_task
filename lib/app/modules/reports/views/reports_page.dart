import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/core/values/app_colors.dart';
import 'package:todo_app/app/modules/home/controllers/home_controller.dart';

class ReportsPage extends GetView<HomeController> {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final task = homeCtrl.task.value;
    final color = HexColor.fromHex(task!.color);
    return Scaffold(
      body: SafeArea(child: Obx(() {
        var createdTasks = homeCtrl.getTotalTask();
        var completedTasks = homeCtrl.getTotalDoneTask();
        var liveTasks = createdTasks - completedTasks;
        var percent = (completedTasks / createdTasks * 100).toStringAsFixed(0);
        return ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0.wp),
              child: Text(
                'MY REPORTS',
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
              child: Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 3.0.wp, vertical: 4.0.wp),
              child: const Divider(thickness: 2),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 5.0.wp, vertical: 3.0.wp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatus(Colors.green, liveTasks, "Live Tasks"),
                  _buildStatus(
                      Colors.orange, completedTasks, "Completed Tasks"),
                  _buildStatus(Colors.blue, createdTasks, "Created Tasks"),
                ],
              ),
            ),
            SizedBox(height: 8.0.wp),
            UnconstrainedBox(
              child: SizedBox(
                width: 70.0.wp,
                height: 70.0.wp,
                child: CircularStepProgressIndicator(
                  totalSteps: createdTasks == 0 ? 1 : createdTasks,
                  currentStep: completedTasks,
                  stepSize: 20,
                  selectedColor: AppColors.green,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 150,
                  height: 150,
                  selectedStepSize: 22,
                  roundedCap: (_, __) => true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${createdTasks == 0 ? 0 : percent}%",
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.0.wp),
                      Text(
                        "Efficiency",
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      })),
    );
  }

  Row _buildStatus(Color color, int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3.0.wp,
          width: 3.0.wp,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 0.5.wp, color: color)),
        ),
        SizedBox(width: 3.0.wp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.0.wp),
            Text(
              text,
              style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }
}
