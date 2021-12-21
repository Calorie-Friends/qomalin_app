import 'dart:developer';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/firestore.dart';
import 'dart:math' as math;

class LatLngRange {
  final List<List<double>> latitudeRange;
  final List<List<double>> longitudeRange;
  LatLngRange({required this.longitudeRange, required this.latitudeRange});
  static LatLngRange fromGoogleMapLatLngRegion(LatLngBounds latLngBounds) {
    // longitude=経度 -180 ~ 0 0 ~ 180
    // latitude=緯度-90 ~ 0 0 ~ 90
    // こうなる時があるLatLngBounds(LatLng(13.158565719803462, 170.82272831350565), LatLng(35.645481152002795, -175.55858977138996))
    // 日付変更線の時や北極点・南極点の時は別途対処が必要

    // 地球は円形のためそのまま愚直に差分を求めてしまうと360度分のデータを取得してしまう可能性がある
    // そのため179と-179のデータを取得する時は179..180 && -179..180の範囲で取得するようにする。
    final longitudeMax = math.max(latLngBounds.northeast.longitude, latLngBounds.southwest.longitude);
    final longitudeMin = math.min(latLngBounds.northeast.longitude, latLngBounds.southwest.longitude);
    final longitudeDiff = longitudeMax - longitudeMin;


    final latitudeMax = math.max(latLngBounds.northeast.latitude, latLngBounds.southwest.latitude);
    final latitudeMin = math.min(latLngBounds.northeast.latitude, latLngBounds.southwest.latitude);
    final latitudeDiff = latitudeMax - latitudeMin;
    final List<List<double>> longitudeRange;
    if(longitudeDiff > 180) {
      longitudeRange = [[-180, longitudeMin], [longitudeMax, 180]];
    }else{
      longitudeRange = [[longitudeMin, longitudeMax]];
    }

    // latitudeの差分が90を超えている場合は北極点、南極点を跨いでいる可能性がある。
    final List<List<double>> latitudeRange;
    if(latitudeDiff > 90) {
      latitudeRange = [[-90, latitudeMin], [latitudeMax, 90]];
    }else{
      latitudeRange = [[latitudeMin, latitudeMax]];
    }
    return LatLngRange(longitudeRange: longitudeRange, latitudeRange: latitudeRange);

  }
}

abstract class QuestionService {
  Stream<List<Question>> nearQuestions(
      {required double radius,
      required double latitude,
      required double longitude});

  Stream<List<Question>> latestQuestions({int limit = 20});
  
  Future<List<Question>> findByLatLngRange({required LatLng center, required double radius});

  Stream<List<Question>> questionsByUser({required String userId});
}

class FirebaseQuestionService extends QuestionService {
  final Reader reader;
  FirebaseQuestionService(this.reader);
  @override
  Stream<List<Question>> nearQuestions(
      {required double radius,
      required double latitude,
      required double longitude}) async* {
    final collection =
        reader(FirestoreProviders.firestoreProvider()).collection("questions");
    final geo = reader(geoFirestoreProvider);
    final dtoListEvents = geo
        .collection(collectionRef: collection)
        .within(
            center: GeoFirePoint(latitude, longitude),
            radius: radius,
            field: "location")
        .map((event) => event.map((e) => QuestionFireDTO.fromDocument(e)).toList());
    await for(final dtoList in dtoListEvents) {
      yield await Future.wait(dtoList.map((e) => e.toEntity()));
    }
  }

  @override
  Stream<List<Question>> latestQuestions({int limit = 20}) async* {
    final events = reader(FirestoreProviders.questionCollectionRefProvider())
        .orderBy("createdAt", descending: true)
        .limit(limit)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());

    await for(final list in events) {
      yield await Future.wait(list.map((e) => e.toEntity()).toList());
    }
  }
  
  @override
  Future<List<Question>> findByLatLngRange({required LatLng center, required double radius}) async {
    log("center:$center, radius:$radius");
    var query = reader(FirestoreProviders.firestoreProvider())
      .collection("questions");
    final stream = reader(geoFirestoreProvider).collection(collectionRef: query)
      .within(
          center: GeoFirePoint(center.latitude, center.longitude),
          radius: radius, field: "location"
    );
    final res = await stream.first;
    log("取得件数:${res.length}");
    final futures = res.map((e) => QuestionFireDTO.fromDocument(e)).map((e) => e.toEntity()).toList();
    return Future.wait(futures);
  }

  @override
  Stream<List<Question>> questionsByUser({required String userId}) async*{
    final events = reader(FirestoreProviders.questionCollectionRefProvider())
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());

    await for(final list in events) {
      yield await Future.wait(list.map((e) => e.toEntity()).toList());
    }
  }
}
