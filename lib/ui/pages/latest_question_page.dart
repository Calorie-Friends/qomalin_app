import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/components/question_card_list.dart';

final _latestQuestionsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.read(QuestionProviders.questionServiceProvider()).latestQuestions();
});
class LatestQuestionPage extends ConsumerWidget {

  void onQuestionPressed(Question question) {
    log('questionが押されました。');
  }

  void onUserPressed(User user) {
    log('userが押されました。');
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Question>> latestQuestionsStream = ref.watch(_latestQuestionsStreamProvider);

    return latestQuestionsStream.when(
        data: (questions){
          return QuestionCardList(onQuestionSelectedListener: onQuestionPressed, onQuestionUserPressedListener: onUserPressed, questions: questions);
        },
        error: (err, stack){
          return const Text("取得失敗");
        },
        loading: (){
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
