import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/controller/task_cubit.dart';
import 'package:to_do_app/app/controller/task_state.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Log in to manage your to-do lists.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  return Form(
                    key: BlocProvider.of<TaskCubit>(context).formKey,
                    child: aurhField(context),
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  return loginBtn(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox loginBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<TaskCubit>(context).authBtnLogic(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Login", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  TextFormField aurhField(context) {
    return TextFormField(
      controller: BlocProvider.of<TaskCubit>(context).userEmail,
      validator: (value) => value!.isEmpty ? "Enter your email" : null,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
