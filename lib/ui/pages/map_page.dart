import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
/*
class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}*/
class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MapState();
  }
}

class MapState extends ConsumerState {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onCameraMove: (position) {
          //log("カメラが動いた position:$position");
        },
        onLongPress: (latLng) {

        },
        onCameraIdle: () async {
          final ct = await _controller.future;
          final visibleRegion = await ct.getVisibleRegion();
          log("onCameraIdle region:$visibleRegion");
          // longitude=経度 -180 ~ 0 0 ~ 180
          // latitude=緯度-90 ~ 0 0 ~ 90
          // こうなる時があるLatLngBounds(LatLng(13.158565719803462, 170.82272831350565), LatLng(35.645481152002795, -175.55858977138996))
          // 日付変更線の時や北極点・南極点の時は別途対処が必要

          // 地球は円形のためそのまま愚直に差分を求めてしまうと360度分のデータを取得してしまう可能性がある
          // そのため179と-179のデータを取得する時は179..180 && -179..180の範囲で取得するようにする。
          final longitudeMax = math.max(visibleRegion.northeast.longitude, visibleRegion.southwest.longitude);
          final longitudeMin = math.min(visibleRegion.northeast.longitude, visibleRegion.southwest.longitude);
          final longitudeDiff = longitudeMax - longitudeMin;


          final latitudeMax = math.max(visibleRegion.northeast.latitude, visibleRegion.southwest.latitude);
          final latitudeMin = math.min(visibleRegion.northeast.latitude, visibleRegion.southwest.latitude);
          final latitudeDiff = latitudeMax - latitudeMin;
          final List<List<double>> longitudeRange;
          if(longitudeDiff > 180) {
            longitudeRange = [[0, latitudeMin], [latitudeMax, 180]];
          }else{
            longitudeRange = [[longitudeMin, longitudeMax]];
          }

          final List<List<double>> latitudeRange;
          // latitudeの差分が90を超えている場合は北極点、南極点を跨いでいる可能性がある。
          if(latitudeDiff > 90) {
            latitudeRange = [[0, longitudeMin], [longitudeMax, 180]];
          }else{
            latitudeRange = [[latitudeMin, latitudeMax]];
          }
          log("検索範囲 longitude:$longitudeRange, latitude:$latitudeRange");
        },



      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}