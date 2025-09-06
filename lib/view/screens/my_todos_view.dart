import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/controller/task_cubit.dart';
import 'package:to_do_app/controller/task_state.dart';
import 'package:to_do_app/view/screens/add_task.dart';

class MyTaskView extends StatelessWidget {
  const MyTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return BlocProvider.of<TaskCubit>(context).tasks.isEmpty
              ? Center(
                  child: Text(
                    "No tasks available. Add a new task!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _buildTodoItem("Task ${index + 1}", index % 2 == 0);
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

  Widget _buildTodoItem(String title, bool completed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Checkbox(value: completed, onChanged: (_) {}),
        title: Text(
          title,
          style: TextStyle(
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {},
        ),
      ),
    );
  }
}
