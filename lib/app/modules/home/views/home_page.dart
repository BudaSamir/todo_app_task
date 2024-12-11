import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';
import 'package:todo_app/app/core/values/app_colors.dart';
import 'package:todo_app/app/modules/home/components/add_card.dart';
import 'package:todo_app/app/modules/home/components/add_dialog.dart';
import 'package:todo_app/app/modules/home/controllers/home_controller.dart';

import '../../../data/models/task.dart';
import '../../reports/views/reports_page.dart';
import '../components/task_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(() {
          return IndexedStack(
            index: controller.tabIndex.value,
            children: [
              SafeArea(
                  child: ListView(
                children: [
                  ///===================================================================
                  Padding(
                    padding: EdgeInsets.all(4.0.wp),
                    child: Text(
                      'MY LIST',
                      style: TextStyle(
                          fontSize: 24.0.sp, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ///===================================================================
                  Obx(() => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          ...controller.tasks.map(
                            (task) => LongPressDraggable(
                                data: task,
                                onDragStarted: () =>
                                    controller.changeDeleting(true),
                                onDragCompleted: () =>
                                    controller.changeDeleting(true),
                                onDraggableCanceled: (_, __) =>
                                    controller.changeDeleting(false),
                                onDragEnd: (_) =>
                                    controller.changeDeleting(false),
                                feedback: Opacity(
                                    opacity: 0.8, child: TaskCard(task: task)),
                                child: TaskCard(task: task)),
                          ),
                          const AddCard()
                        ],
                      ))
                ],
              )),
              ReportsPage(),
            ],
          );
        }),
        floatingActionButton: DragTarget<Task>(
          builder: (_, __, ___) => Obx(
            () => FloatingActionButton(
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => const AddDialog(),
                      transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please Create Your Task Type');
                }
              },
              backgroundColor:
                  controller.deleting.value ? Colors.red : AppColors.blue,
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          ),
          onAccept: (Task task) {
            controller.deleteTask(task);
            EasyLoading.showSuccess('Delete Success');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Obx(() {
            return BottomNavigationBar(
                onTap: (value) => controller.changeTabIndex,
                currentIndex: controller.tabIndex.value,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                      label: 'Home', icon: Icon(Icons.apps)),
                  BottomNavigationBarItem(
                      label: 'Report', icon: Icon(Icons.data_usage)),
                ]);
          }),
        ),
      ),
    );
  }
}
