import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_learn/domain/users/entities/edit_user_input.dart';
import 'package:graphql_learn/domain/users/entities/new_user_input.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/presentation/users/controller/user_controller.dart';

class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({this.user, super.key});

  final UserEntity? user;

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
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _ageController.text = widget.user!.age.toString();
      _usernameController.text = widget.user!.username;
    }
    super.initState();
  }

  Future<void> addOrEditUser() async {
    log(_nameController.text);
    log(_ageController.text);
    log(_usernameController.text);
    if (widget.user != null) {
      await ref
          .read(userControllerProvider.notifier)
          .editUsernameEvent(
            EditUserInput(
              id: int.parse(widget.user!.id),
              username: _usernameController.text,
            ),
          )
          .then(
        (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Username has been updated'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
              ),
            );
          }
        },
      );
    } else {
      await ref
          .read(userControllerProvider.notifier)
          .addNewUserEvent(
            NewUserInput(
              name: _nameController.text,
              age: int.parse(_ageController.text),
              username: 'username',
            ),
          )
          .then(
            (_) => const ScaffoldMessenger(
              child: SnackBar(
                content: Text('Username has been Added'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
              ),
            ),
          );
    }

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
                    onPressed: addOrEditUser,
                    child: Text('${widget.user == null ? 'Add' : 'Edit'} User'),
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
