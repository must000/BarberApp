import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:longdo_maps_api3_flutter/longdo_maps_api3_flutter.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPage();
}

class _LocationPage extends State<LocationPage> {
  final map = GlobalKey<LongdoMapState>();
  final GlobalKey<ScaffoldMessengerState> messenger =
      GlobalKey<ScaffoldMessengerState>();

  bool _animation = true;
  dynamic _zoomLevel;
  dynamic _min;
  dynamic _max;
  dynamic _lon;
  dynamic _lat;
  dynamic _minLon;
  dynamic _minLat;
  dynamic _maxLon;
  dynamic _maxLat;
  dynamic _rotate;
  dynamic _pitch;

  @override
  Widget build(BuildContext context) {
    Object? marker = map.currentState?.object(
      "Marker",
      "1",
      [
        {"lon": 100.5, "lat": 13.7},
        {"detail": "Home"}
      ],
    );

    return MaterialApp(
      scaffoldMessengerKey: messenger,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Longdo Map API3'),
          ),
          drawer: Drawer(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: ListView(
                children: [
                  ListTile(
                      title: Text(
                    "Configuration",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SwitchListTile(
                    value: _animation,
                    onChanged: (it) {
                      setState(() {
                        _animation = it;
                      });
                    },
                    title: Text("Animation"),
                  ),
                  ListTile(
                      title: Text(
                    "MAP",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  ListTile(
                      title: Text(
                    "Zoom  (1.0 to 22.0)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  ListTile(
                    title: Text("Level"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (it) {
                        _zoomLevel = it;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var zoomLevel =
                                await map.currentState?.call("zoom");
                            messenger.currentState?.showSnackBar(
                                SnackBar(content: Text(zoomLevel)));
                          },
                          child: Text("GET"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call("zoom", [
                              double.parse(_zoomLevel),
                              _animation,
                            ]);
                          },
                          child: Text("SET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text("Range"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TextField(
                              onChanged: (it) {
                                _min = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Min",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              onChanged: (it) {
                                _max = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Max",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var zoomRange =
                                await map.currentState?.call("zoomRange");
                            messenger.currentState?.showSnackBar(
                                SnackBar(content: Text(zoomRange.toString())));
                          },
                          child: Text("GET"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call(
                              "zoomRange",
                              [
                                {
                                  "min": double.parse(_min),
                                  "max": double.parse(_max)
                                }
                              ],
                            );
                          },
                          child: Text("SET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      title: Text(
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TextField(
                              onChanged: (it) {
                                _lon = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Lon",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              onChanged: (it) {
                                _lat = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Lat",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var location =
                                await map.currentState?.call("location");
                            messenger.currentState?.showSnackBar(
                                SnackBar(content: Text(location.toString())));
                          },
                          child: Text("GET"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call(
                              "location",
                              [
                                {
                                  "lon": double.parse(_lon),
                                  "lat": double.parse(_lat),
                                },
                                _animation,
                              ],
                            );
                          },
                          child: Text("SET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      title: Text(
                    "Bound",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TextField(
                              onChanged: (it) {
                                _minLon = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Min Lon",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              onChanged: (it) {
                                _minLat = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Min Lat",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TextField(
                              onChanged: (it) {
                                _maxLon = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Max Lon",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              onChanged: (it) {
                                _maxLat = it;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Max Lat",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var bound = await map.currentState?.call("bound");
                            messenger.currentState?.showSnackBar(
                                SnackBar(content: Text(bound.toString())));
                          },
                          child: Text("GET"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call(
                              "bound",
                              [
                                {
                                  "minLon": double.parse(_minLon),
                                  "minLat": double.parse(_minLat),
                                  "maxLon": double.parse(_maxLon),
                                  "maxLat": double.parse(_maxLat),
                                }
                              ],
                            );
                          },
                          child: Text("SET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      title: Text(
                    "Move",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            map.currentState?.call("move", [
                              {
                                "x": -100.0,
                                "y": 0,
                              },
                              _animation,
                            ]);
                          },
                          child: Text("WEST"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call("move", [
                              {
                                "x": 0,
                                "y": 100,
                              },
                              _animation,
                            ]);
                          },
                          child: Text("SOUTH"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call("move", [
                              {
                                "x": 0,
                                "y": -100,
                              },
                              _animation,
                            ]);
                          },
                          child: Text("NORTH"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call("move", [
                              {
                                "x": 100.0,
                                "y": 0,
                              },
                              _animation,
                            ]);
                          },
                          child: Text("EAST"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      title: Text(
                    "Language",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var language =
                                await map.currentState?.call("language");
                            messenger.currentState?.showSnackBar(
                                SnackBar(content: Text(language)));
                          },
                          child: Text("GET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Rotate (Degree)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (it) {
                        _rotate = it;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var rotate = await map.currentState?.call("rotate");
                            messenger.currentState
                                ?.showSnackBar(SnackBar(content: Text(rotate)));
                          },
                          child: Text("GET"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call(
                              "rotate",
                              [
                                _rotate,
                              ],
                            );
                          },
                          child: Text("SET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Pitch (0 to 60)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: TextField(
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      onChanged: (it) {
                        _pitch = it;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            var pitch = await map.currentState?.call("pitch");
                            messenger.currentState
                                ?.showSnackBar(SnackBar(content: Text(pitch)));
                          },
                          child: Text("GET"),
                        ),
                        TextButton(
                          onPressed: () {
                            map.currentState?.call(
                              "pitch",
                              [
                                _pitch,
                              ],
                            );
                          },
                          child: Text("SET"),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Marker",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (marker != null) {
                              map.currentState?.call("Overlays.add", [
                                marker,
                              ]);
                            }
                            
                          },
                          child: Text("Add"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (marker != null) {
                              map.currentState?.objectCall(marker, "pop", [
                                true,
                              ]);
                            }
                          },
                          child: Text("Show"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (marker != null) {
                              map.currentState?.objectCall(marker, "pop", [
                                false,
                              ]);
                            }
                          },
                          child: Text("Hide"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: LongdoMapWidget(
            apiKey: "192d687fea50c69265ac0c95e88f2599",
            key: map,
            bundleId: "com.flutterthialand.barber",
          )),
    );
  }
}
