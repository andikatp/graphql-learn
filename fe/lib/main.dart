import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_learn/presentation/app_widget.dart';

void main() {
  runApp(const ProviderScope(child: AppWidget()));
}
