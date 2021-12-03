import 'package:flutter/cupertino.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/ui/components/question_card.dart';

typedef QuestionCardSelectedListener = Function(Question);
typedef QuestionUserPressedListener = Function(User);

class QuestionCardList extends StatelessWidget{
  final QuestionCardSelectedListener onQuestionSelectedListener;
  final QuestionUserPressedListener onQuestionUserPressedListener;
  final List<Question> questions;

  const QuestionCardList(
  {Key? key,
    required this.onQuestionSelectedListener,
    required this.onQuestionUserPressedListener,
    required this.questions})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(4),
      itemBuilder:(BuildContext context,int index){
        final question = questions[index];
        return QuestionCard(
            title: question.title,
            text: question.text ?? '',
            avatarIcon: question.user!.avatarIcon,
            username: question.user!.username,
            onQuestionPressed: () {onQuestionSelectedListener(question); },
            onUserPressed: () { onQuestionUserPressedListener(question.user!); }
          );
      },
      itemCount: questions.length,
    );
  }
}
