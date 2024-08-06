import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_learn/domain/users/entities/new_user.dart';
import 'package:graphql_learn/presentation/users/providers/user_provider.dart';

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
    await ref.read(userControllerProvider.notifier).addNewUser(
          NewUserInput(
            name: _nameController.text,
            age: int.parse(_ageController.text),
            nationality: Nationality.England,
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
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
              ),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _usernameController,
              ),
              ElevatedButton(
                onPressed: addUser,
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
