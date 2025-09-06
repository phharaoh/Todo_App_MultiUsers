import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/controller/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(Initial());
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  List<TaskModel> tasks = [];
  void addTask(TaskModel task) {
    tasks.add(task);
    emit((TaskAdded()));
  }

  void deleteTask(TaskModel task) {
    tasks.remove(task);
    emit(TaskRemoved());
  }

  void changeStatus(TaskModel task) {
    task.isChecked = !task.isChecked;
    emit(TaskChangeState());
  }
}
