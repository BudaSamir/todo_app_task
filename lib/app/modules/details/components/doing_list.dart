import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/extensions.dart';

import '../../home/controllers/home_controller.dart';

class DoingList extends StatelessWidget {
  const DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
          ? Center(
              child: Image.asset(
                "assets/images/to-do-list.png",
                fit: BoxFit.cover,
                width: 65.0.wp,
              ),
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeCtrl.doingTodos.map((doingTodo) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp, horizontal: 9.0.wp),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              fillColor: WidgetStateProperty.resolveWith(
                                  (states) => Colors.white),
                              value: doingTodo['done'],
                              onChanged: (value) {
                                homeCtrl.doneTodo(doingTodo["title"]);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                            child: Text(
                              doingTodo["title"],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    )),
                if (homeCtrl.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Divider(thickness: 2),
                  ),
              ],
            ),
    );
  }
}
