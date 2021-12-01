import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionDetailPage extends ConsumerWidget {
  final String questionId;
  const QuestionDetailPage({required this.questionId, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("質問詳細"),
      ),
      body: const Text("test"),
    );
  }

}