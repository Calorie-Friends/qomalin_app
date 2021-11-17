import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/models/services/question_service.dart';
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

  Future fetch(LatLngBounds latLng) async {
    state = state.copyWith(t: StateType.loading);
    try {
      final res = await reader(QuestionProviders.questionServiceProvider())
          .findByLatLngRange(LatLngRange.fromGoogleMapLatLngRegion(latLng));
      state = state.copyWith(q: ([...state.questions, ...res]).toSet(), t: StateType.fixed);

    } catch (e) {
       state = state.copyWith(t: StateType.error);
    }

  }
}