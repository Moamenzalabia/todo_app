import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';
import 'package:todo_app/layout/todo_app/home_layout.dart';
import 'package:todo_app/shared/bloc_observer.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

//Stateless
//Stateful
class MyApp extends StatelessWidget {
  @override
  // constructor
  // build
  // this is manager of my app that will build the design and show on screen
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          // if (state is AppInsertDatabaseState) Navigator.pop(context);
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.getAppCubit(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
            ),
            home: Directionality(
                textDirection: TextDirection.ltr, child: HomeLayout()),
          );
        },
      ),
    );
  }
}
