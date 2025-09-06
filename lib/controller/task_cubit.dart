import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/controller/task_state.dart';
import 'package:to_do_app/view/screens/my_todos_view.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(Initial());
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TaskModel> tasks = [];
  void addTask(TaskModel task) {
    emit(Loading());
    tasks.add(task);
    emit((TaskAdded()));
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
