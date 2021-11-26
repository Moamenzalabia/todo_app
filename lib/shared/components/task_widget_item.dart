import 'package:flutter/material.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';

class TaskWidgetItem extends StatelessWidget {
  final Map model;
  TaskWidgetItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Text(
                  '${model['time']}',
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                onPressed: () {
                  AppCubit.getAppCubit(context).updateDataInDatabase(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.getAppCubit(context).updateDataInDatabase(
                    status: 'archive',
                    id: model['id'],
                  );
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.amber,
                ),
              ),
            ],
          )),
      onDismissed: (direction) {
        AppCubit.getAppCubit(context).deleteDataFromDatabase(id: model['id']);
      },
    );
  }
}
