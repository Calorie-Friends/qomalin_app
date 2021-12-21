import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/models/entities/thank.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/thank.dart';

final _commentTextEditingProvider = Provider.autoDispose((ref) {
  return TextEditingController();
});
final _isSendingStateProvider = StateProvider.autoDispose((ref) {
  return false;
});

class ThankEditorDialog extends ConsumerWidget {
  final Answer answer;
  const ThankEditorDialog({Key? key, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = ref.watch(_commentTextEditingProvider);
    final isSending = ref.watch(_isSendingStateProvider);
    return AlertDialog(
      title: const Text("お礼を作成する"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              enabled: !isSending,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("やめる"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("送信"),
          onPressed: isSending ? null : () async {
            final uid = ref.read(authNotifierProvider).fireAuthUser?.uid;
            final thank = Thank.newThank(
                userId: uid!, 
                questionId: answer.questionId, 
                answerId: answer.id, 
                comment: textEditingController.text
            );
            ref.read(ThankProviders.thankRepositoryProvider()).create(thank).then((res) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("お礼作成完了"))
              );
              Navigator.of(context).pop();
            }).onError((error, stackTrace)  {
              log("お礼作成失敗", error: error, stackTrace: stackTrace);
            });
          }
        )
      ],
    );
  }
}