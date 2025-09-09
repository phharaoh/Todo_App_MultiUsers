import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/model/task_model.dart';
import 'package:to_do_app/app/controller/task_state.dart';
import 'package:to_do_app/app/controller/task_cubit.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Todo Title"),
            const SizedBox(height: 8),
            titleTxtField(context),
            const SizedBox(height: 20),
            const Text("Description"),
            const SizedBox(height: 8),
            descTxtField(context),
            const SizedBox(height: 20),
            datetxtField(),
            const Spacer(),
            BlocConsumer<TaskCubit, TaskState>(
              listener: (context, state) {
                if (state is TaskAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Task Added Successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return saveBtn(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  SizedBox saveBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (BlocProvider.of<TaskCubit>(context).title.text.isNotEmpty &&
              BlocProvider.of<TaskCubit>(context).title.text != "") {
            BlocProvider.of<TaskCubit>(context).addTask(
              TaskModel(
                title: BlocProvider.of<TaskCubit>(context).title.text,
                description: BlocProvider.of<TaskCubit>(
                  context,
                ).description.text,
              ),
            );
          }
          BlocProvider.of<TaskCubit>(context).title.clear();
          BlocProvider.of<TaskCubit>(context).description.clear();
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Save", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Row datetxtField() {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "mm/dd/yyyy",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField descTxtField(context) {
    return TextField(
      controller: BlocProvider.of<TaskCubit>(context).description,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Add a description...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  TextField titleTxtField(BuildContext context) {
    return TextField(
      controller: BlocProvider.of<TaskCubit>(context).title,
      decoration: InputDecoration(
        hintText: "Add a title...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text("Add Details"),
      centerTitle: true,
    );
  }
}
