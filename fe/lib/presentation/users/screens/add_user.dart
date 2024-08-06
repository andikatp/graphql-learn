import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_learn/domain/users/entities/new_user.dart';
import 'package:graphql_learn/presentation/users/controller/user_controller.dart';

class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({super.key});
  @override
  ConsumerState<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends ConsumerState<AddUserPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _usernameController = TextEditingController();
    super.initState();
  }

  Future<void> addUser() async {
    log(_nameController.text);
    log(_ageController.text);
    log(_usernameController.text);
    await ref.read(userControllerProvider.notifier).addNewUserEvent(
          NewUserInput(
            name: _nameController.text,
            age: int.parse(_ageController.text),
            username: 'username',
          ),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(40),
        child: Center(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final state = ref.watch(userControllerProvider);
              if (state.isLoading) {
                return const CircularProgressIndicator();
              }
              if (state.error != null) {
                return Text(state.error.toString());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Age',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: addUser,
                    child: const Text('Add User'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
