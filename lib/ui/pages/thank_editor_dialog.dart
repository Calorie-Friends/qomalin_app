import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _commentTextEditingProvider = Provider.autoDispose((ref) {
  return TextEditingController();
});
final _isSendingStateProvider = StateProvider.autoDispose((ref) {
  return false;
});

class ThankEditorDialog extends ConsumerWidget {
  const ThankEditorDialog({Key? key}) : super(key: key);

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

          }
        )
      ],
    );
  }
}