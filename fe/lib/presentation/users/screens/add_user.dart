import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              ),
              TextField(
                controller: _usernameController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
