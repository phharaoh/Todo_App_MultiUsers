import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/controller/task_cubit.dart';
import 'package:to_do_app/controller/task_state.dart';
import 'package:to_do_app/view/screens/add_task.dart';
import 'package:to_do_app/view/screens/auth_view.dart';

class MyTaskView extends StatefulWidget {
  const MyTaskView({super.key});

  @override
  State<MyTaskView> createState() => _MyTaskViewState();
}

class _MyTaskViewState extends State<MyTaskView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AuthView()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocProvider.of<TaskCubit>(context).tasks.isEmpty
              ? Center(
                  child: Text(
                    "No tasks available. Add a new task!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: BlocProvider.of<TaskCubit>(context).tasks.length,
                  itemBuilder: (context, index) {
                    final task = BlocProvider.of<TaskCubit>(
                      context,
                    ).tasks[index];
                    return ListTile(
                      //!
                      leading: Checkbox(
                        value: task.isChecked,
                        onChanged: (_) {
                          BlocProvider.of<TaskCubit>(
                            context,
                          ).changeStatus(task);
                        },
                      ),
                      //!
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      //!
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          BlocProvider.of<TaskCubit>(context).deleteTask(
                            TaskModel(
                              title: task.title,
                              description: task.description,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddTask()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
