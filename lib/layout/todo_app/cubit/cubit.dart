import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';
import 'package:todo_app/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit getAppCubit(context) => BlocProvider.of(context);

  bool isBottomSheetShown = false;
  IconData floatingButtonIcon = Icons.edit;
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> screensTitle = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print('Database Created Successfully');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created Successfully');
        }).catchError((error) {
          print('Error When Create Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('Database Opened Successfully');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((tan) async {
      await tan
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value Inserted InTo Database Successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record  ${error.toString()}');
      });
      return null;
    });
  }

  void updateDataInDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDataFromDatabase({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    floatingButtonIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
