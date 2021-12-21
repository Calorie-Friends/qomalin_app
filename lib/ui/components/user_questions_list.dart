import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/components/question_card_list.dart';

final _userQuestionsStreamProvider = StreamProvider.autoDispose((ref) {
  //TODO: ページ呼び出し元から渡されるUserIdをquestionsByUserメソッドの引数にセットする
  return ref.read(QuestionProviders.questionServiceProvider()).questionsByUser(userId: "IJsmDX5VZxY3qnc8Qz2K3qRwmth2");
});
class UserQuestionList extends ConsumerWidget {
  final userId;
  const UserQuestionList(this.userId, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Question>> latestQuestionsStream = ref.watch(_userQuestionsStreamProvider);

    return latestQuestionsStream.when(
        data: (questions){
          return QuestionCardList(
              onQuestionSelectedListener: (q){
                context.push('/questions/${q.id}/show');
              },
              onQuestionUserPressedListener: (u){},
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



