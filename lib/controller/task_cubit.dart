import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/helper/cache_helper.dart';
import 'package:to_do_app/controller/task_state.dart';
import 'package:to_do_app/view/screens/my_todos_view.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(Initial());
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TaskModel> tasks = [];
  void addTask(TaskModel model) async {
    final model = TaskModel(title: title.text, description: description.text);
    emit(Loading());
    tasks.add(model);
    final stringList = tasks.map((e) {
      return jsonEncode(
        '{"title": "${e.title}", "description": "${e.description}", "isChecked": ${e.isChecked}}',
      );
    }).toList();
    await CacheHelper().setData(key: 'tasks', value: [stringList]);
    emit((TaskAdded()));
  }

  void loadData() async {
    final stringList = await CacheHelper().getData(key: 'tasks');
    if (stringList != null) {
      tasks = (stringList as List).map((e) {
        final map = jsonDecode(e);
        return TaskModel(title: map['title'], description: map['description']);
      }).toList();
    }
    print('${CacheHelper().getData(key: 'tasks')}');
  }

  void deleteTask(TaskModel task) {
    tasks.removeWhere(
      (e) => e.title == task.title && e.description == task.description,
    );
    emit(TaskRemoved());
  }

  void changeStatus(TaskModel task) {
    task.isChecked = !task.isChecked;
    emit(TaskChangeState());
  }

  void authBtnLogic(BuildContext context) {
    emit(Loading());
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyTaskView()),
      );
    }
  }
}
