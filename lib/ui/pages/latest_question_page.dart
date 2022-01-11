import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/components/question_card_list.dart';

final _latestQuestionsStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.read(QuestionProviders.questionServiceProvider()).latestQuestions();
});
class LatestQuestionPage extends ConsumerWidget {
  const LatestQuestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Question>> latestQuestionsStream = ref.watch(_latestQuestionsStreamProvider);

    return latestQuestionsStream.when(
        data: (questions){
          return QuestionCardList(
              onQuestionSelectedListener: (q){
                context.push('/questions/${q.id}/show');
              },
              onQuestionUserPressedListener: (u){
                GoRouter.of(context).push("/users/${u.id}/show");
              },
              questions: questions
          );
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
