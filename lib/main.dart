import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/helper/cache_helper.dart';
import 'package:to_do_app/app/controller/task_cubit.dart';
import 'package:to_do_app/app/view/screens/auth_view.dart';
import 'package:to_do_app/app/view/screens/my_todos_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  final savedEmail = CacheHelper().getDataString(key: 'user_email');
  runApp(
    MyApp(
      initialRouteIsLoggedIn: (savedEmail != null && savedEmail.isNotEmpty),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool initialRouteIsLoggedIn;
  const MyApp({super.key, required this.initialRouteIsLoggedIn});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit(),
      child: MaterialApp(
        theme: ThemeData(),
        home: initialRouteIsLoggedIn ? const MyTaskView() : const AuthView(),
      ),
    );
  }
}
