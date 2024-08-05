import 'package:flutter/material.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        tileColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(user.name),
        subtitle: Text(user.username),
        leading: Text(user.id),
      ),
    );
  }
}
