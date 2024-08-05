import 'package:flutter/material.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.username),
    );
  }
}
