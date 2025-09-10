import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/model/task_model.dart';
import 'package:to_do_app/app/controller/task_cubit.dart';
import 'package:to_do_app/app/controller/task_state.dart';
import 'package:to_do_app/app/view/screens/add_task.dart';

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
  void dispose() {
    super.dispose();
    BlocProvider.of<TaskCubit>(context).close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: _TaskSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              BlocProvider.of<TaskCubit>(context).logout(context);
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

class _TaskSearchDelegate extends SearchDelegate<String> {
  List<TaskModel> _filterTasks(BuildContext context) {
    final tasks = BlocProvider.of<TaskCubit>(context, listen: false).tasks;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return tasks;
    return tasks.where((t) {
      return t.title.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filterTasks(context);
    if (results.isEmpty) {
      return const Center(child: Text('No matching tasks'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          leading: Checkbox(
            value: task.isChecked,
            onChanged: (_) {
              BlocProvider.of<TaskCubit>(
                context,
                listen: false,
              ).changeStatus(task);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              BlocProvider.of<TaskCubit>(context, listen: false).deleteTask(
                TaskModel(title: task.title, description: task.description),
              );
              // Refresh results after deletion
              showResults(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _filterTasks(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final task = suggestions[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          onTap: () {
            query = task.title;
            showResults(context);
          },
        );
      },
    );
  }
}
