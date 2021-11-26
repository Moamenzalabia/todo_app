import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/outline_textfield_border.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var titleEditingController = TextEditingController();
  var timeEditingController = TextEditingController();
  var dateEditingController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.getAppCubit(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.screensTitle[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  // cubit.insertToDatabase(
                  //   title: "First",
                  //   date: "10-2-2022",
                  //   time: "1:00pm",
                  // );
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleEditingController.text,
                      date: dateEditingController.text,
                      time: timeEditingController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlineTextfieldBorder(
                                        controller: titleEditingController,
                                        textInputType: TextInputType.text,
                                        labelText: "Task Title",
                                        prefixIcon: Icons.title,
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter task title';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      OutlineTextfieldBorder(
                                        controller: timeEditingController,
                                        textInputType: TextInputType.datetime,
                                        labelText: "Task Timee",
                                        prefixIcon: Icons.watch_later_outlined,
                                        onTap: () async {
                                          await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeEditingController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter task Time';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      OutlineTextfieldBorder(
                                        controller: dateEditingController,
                                        textInputType: TextInputType.datetime,
                                        labelText: "Task Date",
                                        prefixIcon: Icons.calendar_today,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2101))
                                                  .then((value) {
                                            dateEditingController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter task Date';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.floatingButtonIcon),
            ),
            body: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! AppGetDatabaseLoadingState,
                widgetBuilder: (context) => cubit.screens[cubit.currentIndex],
                fallbackBuilder: (context) =>
                    Center(child: CircularProgressIndicator())),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeCurrentIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
