import 'dart:developer';

import 'package:geoflutterfire/geoflutterfire.dart';
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
  final double distance;
  final double latitude;
  final double longitude;
  QuestionMapState({required this.questions, required this.type, this.distance = 0, this.latitude = 0, this.longitude = 0});

  QuestionMapState copyWith({Set<Question>? q, StateType? t, double? distance, double? lat, double? log}) {
    return QuestionMapState(questions: q ?? questions, type: t ?? type, distance: distance ?? this.distance, latitude: lat?? latitude, longitude: log ?? longitude);
  }

  Set<Question> distancedBy() {
    final point = GeoFirePoint(latitude, longitude);
    return questions.where((element) {
      return point.distance(
        lat: element.location.latitude,
        lng: element.location.longitude
      ) <= distance;
    }).toSet();
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
      state = state.copyWith(
        q: ([...state.questions, ...res]).toSet(),
        t: StateType.fixed,
        distance: distance,
        lat: center.latitude,
        log: center.longitude
      );

    } catch (e, st) {
      log("エラー:$e, $st");
      state = state.copyWith(t: StateType.error);
    }

  }
}