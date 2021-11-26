import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';
import 'package:todo_app/shared/components/empty_widget.dart';
import 'package:todo_app/shared/components/task_widget_item.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        var tasks = AppCubit.getAppCubit(context).archivedTasks;
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => tasks.length > 0,
          widgetBuilder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                TaskWidgetItem(model: tasks[index]),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            itemCount: tasks.length,
          ),
          fallbackBuilder: (context) => EmptyWidget(),
        );
      },
    );
  }
}
