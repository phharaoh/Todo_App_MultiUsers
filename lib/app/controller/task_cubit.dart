import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/model/task_model.dart';
import 'package:to_do_app/app/helper/cache_helper.dart';
import 'package:to_do_app/app/controller/task_state.dart';
import 'package:to_do_app/app/view/screens/auth_view.dart';
import 'package:to_do_app/app/view/screens/my_todos_view.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(Initial());
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TaskModel> tasks = [];
  String? currentUserEmail;
  void addTask(TaskModel model) async {
    final model = TaskModel(title: title.text, description: description.text);
    emit(Loading());
    tasks.add(model);
    final stringList = tasks.map((e) {
      return jsonEncode(
        '{"title": "${e.title}", "description": "${e.description}", "isChecked": ${e.isChecked}}',
      );
    }).toList();
    if (currentUserEmail != null && currentUserEmail!.isNotEmpty) {
      await CacheHelper().setData(
        key: 'tasks_${currentUserEmail!}',
        value: stringList,
      );
    } else {
      await CacheHelper().setData(key: 'tasks', value: stringList);
    }
    emit((TaskAdded()));
  }

  void loadData() async {
    final email = CacheHelper().getDataString(key: 'user_email');
    currentUserEmail = email;
    final stringList = await CacheHelper().getData(
      key: email != null && email.isNotEmpty ? 'tasks_$email' : 'tasks',
    );
    if (stringList != null) {
      tasks = (stringList as List).map((e) {
        final map = jsonDecode(e);
        final model = TaskModel(
          title: map['title'],
          description: map['description'],
        );
        model.isChecked = (map['isChecked'] ?? false) == true;
        return model;
      }).toList();
    }
    // print('${CacheHelper().getData(key: 'tasks')}');
  }

  void deleteTask(TaskModel task) {
    tasks.removeWhere(
      (e) => e.title == task.title && e.description == task.description,
    );
    final stringList = tasks.map((e) {
      return jsonEncode(
        '{"title": "${e.title}", "description": "${e.description}", "isChecked": ${e.isChecked}}',
      );
    }).toList();
    if (currentUserEmail != null && currentUserEmail!.isNotEmpty) {
      CacheHelper().setData(
        key: 'tasks_${currentUserEmail!}',
        value: stringList,
      );
    } else {
      CacheHelper().setData(key: 'tasks', value: stringList);
    }
    emit(TaskRemoved());
  }

  void changeStatus(TaskModel task) {
    task.isChecked = !task.isChecked;
    final stringList = tasks.map((e) {
      return jsonEncode(
        '{"title": "${e.title}", "description": "${e.description}", "isChecked": ${e.isChecked}}',
      );
    }).toList();
    if (currentUserEmail != null && currentUserEmail!.isNotEmpty) {
      CacheHelper().setData(
        key: 'tasks_${currentUserEmail!}',
        value: stringList,
      );
    } else {
      CacheHelper().setData(key: 'tasks', value: stringList);
    }
    emit(TaskChangeState());
  }

  void authBtnLogic(BuildContext context) {
    emit(Loading());
    if (formKey.currentState!.validate()) {
      currentUserEmail = userEmail.text.trim();
      CacheHelper().setData(key: 'user_email', value: currentUserEmail);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyTaskView()),
      );
    }
  }

  void logout(BuildContext context) async {
    await CacheHelper().removeData(key: 'user_email');
    currentUserEmail = null;
    tasks = [];
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AuthView()),
    );
  }
}
