import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';

import '../../home/controllers/home_controller.dart';

class DoneList extends StatelessWidget {
  const DoneList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Obx(
      () => homeCtrl.doneTodos.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                  child: Text(
                    "Complete (${homeCtrl.doneTodos.length})",
                    style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                ),
                ...homeCtrl.doneTodos.map((doneTodo) => Dismissible(
                      key: ObjectKey(doneTodo),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) =>
                          homeCtrl.deleteDoneToDo(doneTodo['title']),
                      background: Container(
                        color: Colors.red.withOpacity(0.8),
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.0.wp, horizontal: 9.0.wp),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: Icon(Icons.done),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                              child: Text(
                                doneTodo["title"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            )
          : SizedBox(),
    );
  }
}
