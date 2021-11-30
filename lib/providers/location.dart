import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationPositionStreamProvider =
    StreamProvider.autoDispose<Position>((ref) async* {
  final stream = Geolocator.getPositionStream(
      distanceFilter: 1, desiredAccuracy: LocationAccuracy.high);
  await for (final v in stream) {
    log("position:$v");
    yield v;
  }
});

final locationServiceStatusStreamProvider =
    StreamProvider.autoDispose<ServiceStatus>((ref) {
  return Geolocator.getServiceStatusStream();
});
