import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/firestore.dart';
import 'package:qomalin_app/providers/questions.dart';

enum StateType {
  fixed, loading, error
}
class QuestionMapState {
  final Set<Question> questions;
  final StateType type;
  QuestionMapState({required this.questions, required this.type});

  QuestionMapState copyWith({Set<Question>? q, StateType? t}) {
    return QuestionMapState(questions: q ?? questions, type: t ?? type);
  }
}
class QuestionMapNotifier extends StateNotifier<QuestionMapState> {
  Reader reader;
  QuestionMapNotifier(this.reader) : super(QuestionMapState(questions: {}, type: StateType.fixed));

  Future fetch(LatLng center, LatLngBounds latLng) async {
    state = state.copyWith(t: StateType.loading);
    try {
    final distance = reader(geoFirestoreProvider)
      .point(latitude: latLng.northeast.latitude, longitude: latLng.northeast.longitude)
      .distance(lat: latLng.southwest.latitude, lng: latLng.southwest.longitude);
    final res = await reader(QuestionProviders.questionServiceProvider())
          .findByLatLngRange(center: center, radius: distance);
      state = state.copyWith(q: ([...state.questions, ...res]).toSet(), t: StateType.fixed);

    } catch (e, st) {
      log("エラー:$e, $st");
      state = state.copyWith(t: StateType.error);
    }

  }
}