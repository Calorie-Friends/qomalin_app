import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';

class QuestionDetailPage extends ConsumerWidget {
  final String questionId;
  const QuestionDetailPage({required this.questionId, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("質問詳細"),
      ),
      body: FutureBuilder<Question>(
        future: ref
            .read(QuestionProviders.questionRepositoryProvider())
            .find(questionId),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Container(
                alignment: Alignment.center, child: const Text("取得失敗"));
          }
          return ListView(
            children: [QuestionDetail(question: snapshot.requireData)],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          GoRouter.of(context).push('/questions/$questionId/answers/create');
        },
        label: const Text('回答する'),
        icon: const Icon(Icons.add),
      ),
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
            QuestionDetailImages(imageUrls: question.imageUrls),
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
  const QuestionDetailImages({required this.imageUrls, Key? key}) : super(key: key);

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
                  image: NetworkImage(imageUrls[index]),
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {

                    },
                  ),
              )
          );
        },
      )
    );
  }
}