import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      await ref.read(userControllerProvider.notifier).editUsernameEvent(
            EditUserInput(
              id: int.parse(widget.user!.id),
              username: _usernameController.text,
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username has been updated'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.white,
          ),
        );
      }
    } else {
      try {
        await ref.read(userControllerProvider.notifier).addNewUserEvent(
              NewUserInput(
                name: _nameController.text,
                age: int.parse(_ageController.text),
                username: 'username',
              ),
            );

        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Username has been added'),
        //       behavior: SnackBarBehavior.floating,
        //       backgroundColor: Colors.white,
        //     ),
        //   );
        // }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.white,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(userControllerProvider, (_, state) {
      if (state.hasError) {
        log('errorrr');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.asError?.error.toString() ?? '')),
        );
      }
    });
    final state = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(40),
        child: Center(
          child: state.when(
            data: (data) => Column(
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
            ),
            error: (error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning, size: 50),
                Text(state.error.toString(), textAlign: TextAlign.center),
              ],
            ),
            loading: CircularProgressIndicator.new,
          ),
        ),
      ),
    );
  }
}
