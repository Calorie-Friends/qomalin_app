import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/answer.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/ui/components/answer_card_list.dart';
import 'package:qomalin_app/ui/pages/thank_editor_dialog.dart';

final _questionFutureProvider = FutureProvider.autoDispose.family<Question, String>((ref, questionId) {
  return ref.read(QuestionProviders.questionRepositoryProvider())
      .find(questionId);
});

final _answersStreamProvider = StreamProvider.autoDispose.family((ref, String questionId) {
  return ref.read(AnswerProviders.answerServiceProvider()).findByQuestion(questionId);
});

class QuestionDetailPage extends ConsumerWidget {
  final String questionId;
  const QuestionDetailPage({required this.questionId, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return ref.watch(_questionFutureProvider(questionId)).map(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: Text(data.value.title),
          ),
          body: ListView(
            children: [
              QuestionDetail(question: data.value),
              QuestionDetailAnswers(questionId: questionId)
            ],
            padding: const EdgeInsets.only(bottom: 80),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              GoRouter.of(context).push('/questions/$questionId/answers/create');
            },
            label: const Text('回答する'),
            icon: const Icon(Icons.add),
          ),
        );
      },
      error: (state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("読み込み失敗"),
          ),
          body: Container(alignment: Alignment.center, child: const Text("取得失敗")),
        );
      },
      loading: (e) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("質問読み込み中")
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
    );

  }
}

class QuestionDetail extends ConsumerWidget {
  final Question question;
  const QuestionDetail({required this.question, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          if(question.text?.isNotEmpty == true)
            Text(
              question.text ?? '',
            ),
          if(question.imageUrls.isNotEmpty)
            QuestionDetailImages(
              imageUrls: question.imageUrls,
              onImageTapped: (index, url) {
                final query = Uri(
                    queryParameters: {
                      'current': [index.toString()]
                    },
                    path: '/photos'
                  );
                GoRouter.of(context).push(query.toString(), extra: question.imageUrls);
              },
            ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            height: 2,
          ),
          Row(
            children: [
              const Icon(Icons.location_on_outlined),
              Flexible(
                child: Text(
                  question.address ??
                      "[${question.location.latitude}, ${question.location.longitude}]",
                ),
              )
            ],
          ),
          const Divider(
            height: 2,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: CircleAvatar(
                  foregroundImage: question.user?.avatarIcon == null
                      ? const NetworkImage(
                          'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6')
                      : NetworkImage(question.user!.avatarIcon!),
                  backgroundImage: const NetworkImage(
                      'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6'),
                  radius: 16,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(question.user?.username ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                  ))
            ],
          )
        ],
      ),
    ));
  }
}


class QuestionDetailImages extends ConsumerWidget {
  final List<String> imageUrls;
  final Function(int, String) onImageTapped;
  const QuestionDetailImages({required this.imageUrls, required this.onImageTapped, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 16 * 9,

      child: PageView.builder(
        itemCount: imageUrls.length,
        controller: PageController(viewportFraction: 0.85),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Ink.image(
                  image: CachedNetworkImageProvider(
                    imageUrls[index]
                  ),
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {
                      onImageTapped(index, imageUrls[index]);
                    },
                  ),
              )
          );
        },
      )
    );
  }
}

class QuestionDetailAnswers extends ConsumerWidget {
  final String questionId;
  const QuestionDetailAnswers({Key? key, required this.questionId}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_answersStreamProvider(questionId)).map(
        data: (data) {
          return Padding(
              padding: const EdgeInsets.only(left: 24),
              child: AnswerCardList(
                onAnswerCardSelectedListener:(a) {},
                onAnswerUserPressedListener: (u) {},
                onAnswerFavoritePressedListener: (a) {
                    showDialog(context: context, builder: (BuildContext context) {
                      return ThankEditorDialog();
                    });
                },
                answers: data.value,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              )
          );
        },
        error: (e) {
          return const Text("回答の取得に失敗しました。");
        },
        loading: (e) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator())
          );
        }
    );
  }
}