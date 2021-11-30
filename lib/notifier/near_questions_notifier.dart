
import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/firestore.dart';
import 'package:qomalin_app/providers/questions.dart';

enum NearQuestionsStateType {
  loading, error, fixed
}

class NearQuestionsState {
  final List<Question> questions;
  final double? radius;
  final double? latitude;
  final double? longitude;
  final NearQuestionsStateType type;
  NearQuestionsState({
    required this.questions,
    required this.radius,
    required this.latitude,
    required this.longitude,
    this.type = NearQuestionsStateType.fixed
  });

  NearQuestionsState copyWith({
    List<Question>? questions,
    double? radius,
    double? latitude,
    double? longitude,
    NearQuestionsStateType? type
  }) {
    return NearQuestionsState(
      questions: questions ?? this.questions,
      radius: radius ?? this.radius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type
    );
  }
}

const double defaultRadius = 1;

class NearQuestionsNotifier extends StateNotifier<NearQuestionsState> {
  Reader reader;
  NearQuestionsNotifier(this.reader) : super(
    NearQuestionsState(questions: [], radius: null, latitude: null, longitude: null)
  );
  StreamSubscription<List<Question>>? _streamSubscription;
  Future fetch() async {

    state = state.copyWith(type: NearQuestionsStateType.loading);
    final pos = await GeolocatorPlatform.instance.getCurrentPosition();
    final distance = reader(geoFirestoreProvider)
      .point(latitude: pos.latitude, longitude: pos.longitude)
      .distance(lat: state.latitude ?? 0, lng: state.longitude ?? 0);
    if(!(distance > ((state.radius ?? defaultRadius) / 4))) {
      state = state.copyWith(type: NearQuestionsStateType.fixed);
      return;
    }
    final stream = reader(QuestionProviders.questionServiceProvider())
      .nearQuestions(radius: defaultRadius, latitude: pos.latitude, longitude: pos.longitude);

    final broadcastStream = stream.asBroadcastStream();
    await _streamSubscription?.cancel();
    _streamSubscription = broadcastStream.listen((event) {
      state = state.copyWith(
        questions: event,
        type: NearQuestionsStateType.fixed,
        radius: defaultRadius,
        longitude: pos.longitude,
        latitude: pos.latitude,
      );
    });
    log("listen開始したらしい");
    await broadcastStream.first;
    log("state更新前");
    state = state.copyWith(type: NearQuestionsStateType.fixed);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}