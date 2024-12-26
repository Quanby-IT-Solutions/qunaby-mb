// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'dart:async';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:p_c_i_c_mobile_app/dashboard/geotag/geotagging/geotagging_model.dart';

class MapBox extends StatefulWidget {
  const MapBox({
    Key? key,
    this.width,
    this.height,
    this.accessToken,
    this.taskId,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? accessToken;
  final String? taskId;

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  late GeotaggingModel _model;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;

  ll.LatLng? _currentLocation;
  List<ll.LatLng> _routeCoordinates = [];
  ll.LatLng? _startingPosition;
  final ll.Distance _distance = ll.Distance();

  bool _isTracking = false;
  bool _isMapReady = false;
  bool storeFound = false;

  TileProvider? _tileProvider;
  String? _storeName;

  String? _errorMessage;

  TileLayer? _offlineTileLayer;
  TileLayer? _onlineTileLayer;

  static const double _currentZoom = 19.0;
  static const int _positionStreamIntervalMs = 100;
  static const int _initialPositionSamples = 20;
  static const double _highAccuracyThreshold = 10.0;
  static const double _stationarySpeedThreshold = 0.1;
  static const double _significantMovementThreshold = 0.5;
  static const int _stationaryWindowSize = 20;
  static const double _autoSnapThreshold = 1.0;
  static const int _minPointsForAutosnap = 10;

  late SimpleKalmanFilter _latFilter;
  late SimpleKalmanFilter _lonFilter;

  List<Position> _recentPositions = [];

  ll.LatLng _averagePosition = ll.LatLng(0, 0);
  bool _isStationary = true;

  DateTime _lastUpdateTime = DateTime.now();
  double? _currentHeading;
  ll.LatLng? _lastFilteredLocation;

  @override
  void initState() {
    super.initState();
    _latFilter =
        SimpleKalmanFilter(e: 3, q: 0.02); // Decreased q from 0.5 to 0.02
    _lonFilter =
        SimpleKalmanFilter(e: 3, q: 0.02); // Decreased q from 0.5 to 0.02
    _initializeMapComponents();
  }

  Future<void> _initializeMapComponents() async {
    await _checkConnectivity();
    await _initializeLocation();
    await _initializeTileProvider();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _errorMessage = "No internet connection.";
      });
    } else {
      FFAppState().mapLoadedWithInternet = true;
    }
  }

  Future<ll.LatLng?> _initializeLocation() async {
    try {
      await _checkLocationPermission();
      await _checkLocationAccuracy();

      Position initialPosition = await _getAccuratePosition();

      if (!mounted) return null;

      _currentLocation =
          ll.LatLng(initialPosition.latitude, initialPosition.longitude);
      _routeCoordinates.add(_currentLocation!);
      if (_isMapReady) {
        _mapController.move(_currentLocation!, _currentZoom);
      }

      _startLocationStream();
      return _currentLocation;
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Initialization error: $e";
        });
      }
      return null;
    }
  }

  Future<Position> _getAccuratePosition() async {
    List<Position> samples = [];
    for (int i = 0; i < _initialPositionSamples; i++) {
      Position position = await _getCurrentPositionWithRetry();
      samples.add(position);
      await Future.delayed(Duration(milliseconds: 200));
    }

    double sumLat = 0, sumLon = 0, sumAcc = 0;
    for (var pos in samples) {
      sumLat += pos.latitude;
      sumLon += pos.longitude;
      sumAcc += pos.accuracy;
    }

    double avgLat = sumLat / _initialPositionSamples;
    double avgLon = sumLon / _initialPositionSamples;
    double avgAcc = sumAcc / _initialPositionSamples;

    _latFilter = SimpleKalmanFilter(
        e: avgAcc, q: 0.01); // Increased q from 0.001 to 0.01
    _lonFilter = SimpleKalmanFilter(
        e: avgAcc, q: 0.01); // Increased q from 0.001 to 0.01

    return Position(
      latitude: avgLat,
      longitude: avgLon,
      timestamp: DateTime.now(),
      accuracy: avgAcc,
      altitude: samples.last.altitude,
      heading: samples.last.heading,
      speed: samples.last.speed,
      speedAccuracy: samples.last.speedAccuracy,
      altitudeAccuracy: samples.last.altitudeAccuracy ?? 0,
      headingAccuracy: samples.last.headingAccuracy ?? 0,
    );
  }

  Future<void> _initializeTileProvider() async {
    if (_currentLocation == null) {
      print('Current location is null, trying to get location');
      _currentLocation = await _initializeLocation();
      if (_currentLocation == null) {
        print('Failed to get current location');
        return;
      }
    }

    final stats = FMTC.FMTCRoot.stats;
    final stores = await stats.storesAvailable;

    print('Available stores: ${stores.length}');
    print(
        'Current location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}');

    for (var store in stores) {
      print('Checking store: ${store.storeName}');
      final md = FMTC.FMTCStore(store.storeName).metadata;
      final metadata = await md.read;
      print('Metadata for ${store.storeName}: $metadata');

      if (metadata != null) {
        try {
          // Parse metadata for region boundaries
          double? minLat = double.tryParse(metadata['minLat'] ?? '');
          double? maxLat = double.tryParse(metadata['maxLat'] ?? '');
          double? minLon = double.tryParse(metadata['minLon'] ?? '');
          double? maxLon = double.tryParse(metadata['maxLon'] ?? '');

          if (minLat == null ||
              maxLat == null ||
              minLon == null ||
              maxLon == null) {
            print('Invalid metadata for ${store.storeName}');
            continue;
          }

          print(
              'Parsed region data: minLat: $minLat, maxLat: $maxLat, minLon: $minLon, maxLon: $maxLon');

          // Check if the current location is within this region's boundaries
          if (_isLocationInRegion(
              _currentLocation!, minLat, maxLat, minLon, maxLon)) {
            _storeName = store.storeName;
            print(
                'FOUND MAP BASED ON THE CURRENT LOCATION OF THE USER: $_storeName');
            storeFound = true;
            break;
          }
        } catch (e) {
          print('Error processing metadata for ${store.storeName}: $e');
        }
      } else {
        print('Metadata is null for ${store.storeName}');
      }
    }

    if (!storeFound) {
      print('No matching store found for the current location.');
    } else if (_storeName != null) {
      // Initialize the offline tile layer using the store
      final tileProvider = FMTC.FMTCStore(_storeName!).getTileProvider(
        settings: FMTC.FMTCTileProviderSettings(
          behavior: FMTC.CacheBehavior.cacheFirst,
        ),
      );

      _offlineTileLayer = TileLayer(
        tileProvider: tileProvider,
        urlTemplate:
            'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
        additionalOptions: {
          'accessToken': widget.accessToken ?? '',
        },
      );
      print('Offline tile layer initialized with store: $_storeName');
    } else {
      print('No store available to initialize offline tile layer');
    }

    // Initialize the online tile layer
    _onlineTileLayer = TileLayer(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
      additionalOptions: {
        'accessToken': widget.accessToken ?? '',
      },
    );
  }

  // Helper function to check if a location is within the region's bounds
  bool _isLocationInRegion(ll.LatLng location, double minLat, double maxLat,
      double minLon, double maxLon) {
    print('Checking location: ${location.latitude}, ${location.longitude}');
    print(
        'Region: minLat: $minLat, maxLat: $maxLat, minLon: $minLon, maxLon: $maxLon');

    return location.latitude >= minLat &&
        location.latitude <= maxLat &&
        location.longitude >= minLon &&
        location.longitude <= maxLon;
  }

  num _parseNum(dynamic value) {
    if (value is num) {
      return value;
    } else if (value is String) {
      return num.parse(value);
    } else {
      throw FormatException('Cannot parse $value to num');
    }
  }

  Future<void> _checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
  }

  Future<void> _checkLocationAccuracy() async {
    try {
      LocationAccuracyStatus accuracy = await Geolocator.getLocationAccuracy();
      if (accuracy == LocationAccuracyStatus.reduced && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enable precise location for better accuracy'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('Error checking location accuracy: $e');
    }
  }

  Future<Position> _getCurrentPositionWithRetry({int retries = 0}) async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      if (retries < 3) {
        await Future.delayed(Duration(seconds: 2));
        return _getCurrentPositionWithRetry(retries: retries + 1);
      } else {
        _showSnackbar("Failed to get accurate location, using best effort.");
        return await Geolocator.getLastKnownPosition() ??
            Position(
              longitude: 0.0,
              latitude: 0.0,
              timestamp: DateTime.now(),
              accuracy: 0.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
              altitudeAccuracy: 0.0,
              headingAccuracy: 0.0,
            );
      }
    }
  }

  Future<bool> _isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  void _startLocationStream() {
    final LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
      forceLocationManager: false,
      intervalDuration: Duration(milliseconds: _positionStreamIntervalMs),
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        if (mounted) {
          _processNewPosition(position);
        }
      },
      onError: (error) {
        print("Location stream error: $error");
        _restartLocationStream();
      },
    );
  }

  void _restartLocationStream() {
    _positionStreamSubscription?.cancel();
    Future.delayed(Duration(seconds: 1), _startLocationStream);
  }

  void _processNewPosition(Position position) {
    // Apply Kalman filter for the marker position
    double filteredLat = _latFilter.filter(position.latitude);
    double filteredLon = _lonFilter.filter(position.longitude);
    ll.LatLng filteredLocation = ll.LatLng(filteredLat, filteredLon);

    // Use raw coordinates for the route
    ll.LatLng rawLocation = ll.LatLng(position.latitude, position.longitude);

    _updatePosition(
        filteredLocation, rawLocation, position.heading, position.speed);
  }

  void _updatePosition(ll.LatLng filteredLocation, ll.LatLng rawLocation,
      double heading, double speed) {
    setState(() {
      _currentLocation =
          filteredLocation; // Use filtered location for the marker
      _currentHeading = heading;
      _lastFilteredLocation = filteredLocation;
      _lastUpdateTime = DateTime.now();

      if (_isMapReady && _shouldRecenterMap()) {
        _mapController.move(_currentLocation!, _currentZoom);
        if (speed > _stationarySpeedThreshold) {
          _mapController.rotate(heading);
        }
      }

      if (_isTracking) {
        _addToRoute(rawLocation); // Use raw location for the route
      }
    });
  }

  void _addToRoute(ll.LatLng newLocation) async {
    if (_startingPosition == null) {
      _startingPosition = newLocation;
    }

    setState(() {
      _routeCoordinates.add(newLocation);
    });

    if (_routeCoordinates.length >= _minPointsForAutosnap) {
      double distanceToStart = _distance.as(
        ll.LengthUnit.Meter,
        _startingPosition!,
        newLocation,
      );

      if (distanceToStart <= _autoSnapThreshold) {
        print("Autosnap condition met. Executing completion logic...");

        // Replace the last point with the starting point to ensure proper closure
        _routeCoordinates.last = _startingPosition!;

        // Add the first point again to close the route
        if (_routeCoordinates.first != _routeCoordinates.last) {
          _routeCoordinates.add(_routeCoordinates.first);
        }

        print(
            "Route closed. First and last coordinates: ${_routeCoordinates.first}, ${_routeCoordinates.last}");

        // Perform the autosnap and execute the provided code
        FFAppState().routeStarted = false;

        try {
          if (FFAppState().ONLINE) {
            await TasksTable().update(
              data: {
                'status': 'ongoing',
              },
              matchingRows: (rows) => rows.eq(
                'id',
                widget.taskId,
              ),
            );
            print("Online task status updated");
          }

          await SQLiteManager.instance.updateTaskStatus(
            taskId: widget.taskId,
            status: 'ongoing',
            isDirty: !FFAppState().ONLINE,
          );
          print("SQLite task status updated");

          // Safely update the model
          try {
            _model.isGeotagStart = false;
            _model.isFinished = true;
            print("Model updated successfully");
          } catch (modelError) {
            print("Error updating model: $modelError");
          }

          // Force a rebuild to update the map
          setState(() {});

          print("Attempting navigation to gpxSuccess...");

          // Use a more robust navigation method
          if (mounted && context.mounted) {
            await Future.delayed(Duration.zero, () {
              context.pushNamed(
                'gpxSuccess',
                queryParameters: {
                  'taskId': serializeParam(
                    widget.taskId,
                    ParamType.String,
                  ),
                }.withoutNulls,
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.scale,
                    alignment: Alignment.bottomCenter,
                    duration: Duration(milliseconds: 300),
                  ),
                },
              );
            });
            print("Navigation to gpxSuccess initiated");
          } else {
            print("Context is not available for navigation");
          }
        } catch (e) {
          print("Error during autosnap completion: $e");
          // Attempt navigation even if there was an error
          if (mounted && context.mounted) {
            context.pushNamed('gpxSuccess',
                queryParameters: {'taskId': widget.taskId});
          }
        }
      }
    }
  }

  Future<void> _startTracking() async {
    if (_currentLocation != null && !_isTracking) {
      bool gpsEnabled = await _isGpsEnabled();
      if (!gpsEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'GPS is not enabled. Please turn on GPS to start tracking.'),
          ));
        }
        FFAppState().routeStarted = false;
        return;
      }

      try {
        setState(() {
          _isTracking = true;
          _routeCoordinates.clear();
          _startingPosition = _currentLocation;
        });

        Position startPosition = await _getAccuratePosition();
        if (!mounted) return;

        setState(() {
          _startingPosition =
              ll.LatLng(startPosition.latitude, startPosition.longitude);
          _routeCoordinates.add(_startingPosition!);
        });

        FFAppState().routeStarted = true;
      } catch (e) {
        if (mounted) {
          setState(() {
            _isTracking = false;
            _errorMessage = "Failed to start tracking: $e";
          });
        }
        FFAppState().routeStarted = false;
      }
    }
  }

  void _completeTracking() {
    if (_routeCoordinates.isEmpty) return;

    if (_routeCoordinates.first != _routeCoordinates.last) {
      _routeCoordinates.add(_routeCoordinates.first);
    }

    print('Route completed. Total points: ${_routeCoordinates.length}');

    double totalDistance = calculateTotalDistance(_routeCoordinates);
    print('Total distance: $totalDistance meters');

    double area = 0.0;
    if (_routeCoordinates.length >= 3) {
      area = calculateAreaOfPolygon(_routeCoordinates);
      print('Area: $area square meters');
    }

    String routeCoordinatesString = _routeCoordinates
        .map((point) => '${point.latitude},${point.longitude}')
        .join(' ');

    String lastCoord =
        '${_routeCoordinates.last.latitude},${_routeCoordinates.last.longitude}';
    print("Last coord: $lastCoord");

    String currentDateTime = DateTime.now().toIso8601String();
    print("Current date time: $currentDateTime");

    String areaInHectares = (area / 10000).toString();
    print("Area in hectares: $areaInHectares");

    String distanceInKilometers = (totalDistance / 1000).toString();
    print("Distance in kilometers: $distanceInKilometers");

    saveGpx(
      widget.taskId ?? 'default_task_id',
      routeCoordinatesString,
      lastCoord,
      currentDateTime,
      areaInHectares,
      distanceInKilometers,
    );

    setState(() {
      _routeCoordinates.clear();
      _isTracking = false;
      FFAppState().routeStarted = false;
    });
  }

  double calculateTotalDistance(List<ll.LatLng> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += const ll.Distance().as(
        ll.LengthUnit.Meter,
        points[i],
        points[i + 1],
      );
    }
    return totalDistance;
  }

  double calculateAreaOfPolygon(List<ll.LatLng> points) {
    if (points.length < 3) {
      return 0.0;
    }
    double radius = 6378137.0;
    double area = 0.0;

    for (int i = 0; i < points.length; i++) {
      ll.LatLng p1 = points[i];
      ll.LatLng p2 = points[(i + 1) % points.length];

      double lat1 = p1.latitudeInRad;
      double lon1 = p1.longitudeInRad;
      double lat2 = p2.latitudeInRad;
      double lon2 = p2.longitudeInRad;

      double segmentArea = 2 *
          atan2(
            tan((lon2 - lon1) / 2) * tan((lat1 + lat2) / 2),
            1 + tan(lat1 / 2) * tan(lat2 / 2) * cos(lon1 - lon2),
          );
      area += segmentArea;
    }

    return (area * radius * radius).abs();
  }

  void _recenterMap() {
    if (_currentLocation != null && _isMapReady) {
      _mapController.move(_currentLocation!, _currentZoom);
    }
  }

  bool _shouldRecenterMap() {
    if (!_isMapReady || _currentLocation == null) return false;

    final mapBounds = LatLngBounds.fromPoints(
      [
        _calculateOffset(_currentLocation!, _mapController.camera.zoom, -1, -1),
        _calculateOffset(_currentLocation!, _mapController.camera.zoom, 1, 1),
      ],
    );

    final currentPoint =
        _mapController.camera.latLngToScreenPoint(_currentLocation!);

    return currentPoint == null || !mapBounds.contains(_currentLocation!);
  }

  ll.LatLng _calculateOffset(
      ll.LatLng center, double zoom, double xOffset, double yOffset) {
    final double scaleFactor = 0.01 / zoom;
    return ll.LatLng(
      center.latitude + (scaleFactor * yOffset),
      center.longitude + (scaleFactor * xOffset),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = FFAppState();

    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!appState.mapLoadedWithInternet && storeFound == false) {
      return _buildOfflineMessageBox(this.context);
    }

    if (appState.routeStarted && !_isTracking) {
      _startTracking();
    }

    if (!appState.routeStarted && _isTracking) {
      _completeTracking();
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _initializeLocation();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? MediaQuery.of(context).size.height,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation!,
              initialZoom: _currentZoom,
              minZoom: 18,
              maxZoom: 22,
              onMapReady: () {
                setState(() {
                  _isMapReady = true;
                  if (_currentLocation != null) {
                    _mapController.move(_currentLocation!, _currentZoom);
                  }
                });
              },
            ),
            children: [
              if (appState.ONLINE && _onlineTileLayer != null)
                _onlineTileLayer!
              else if (_offlineTileLayer != null)
                _offlineTileLayer!
              else
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
                  additionalOptions: {
                    'accessToken': widget.accessToken ?? '',
                  },
                ),
              CurrentLocationLayer(
                followOnLocationUpdate: FollowOnLocationUpdate.always,
                style: LocationMarkerStyle(
                  marker: const DefaultLocationMarker(color: Colors.green),
                  markerSize: const Size(12, 12),
                  markerDirection: MarkerDirection.heading,
                  accuracyCircleColor: Colors.green.withOpacity(0.2),
                  headingSectorColor: Colors.green.withOpacity(0.8),
                  headingSectorRadius: 60,
                ),
                moveAnimationDuration: Duration.zero,
              ),
              if (_routeCoordinates.isNotEmpty &&
                  (appState.routeStarted || _isTracking))
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeCoordinates,
                      strokeWidth: 3.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: _startingPosition != null
                    ? [
                        Marker(
                          point: _startingPosition!,
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.red,
                            size: 14.0,
                          ),
                        ),
                      ]
                    : [],
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0x7f0f1113),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.transparent, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: _recenterMap,
                child: Center(
                  child: Icon(
                    Icons.my_location_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SimpleKalmanFilter {
  double _e;
  double _q;
  double? _lastEstimate;

  SimpleKalmanFilter({required double e, required double q})
      : _e = e,
        _q = q;

  double filter(double measurement) {
    if (_lastEstimate == null) {
      _lastEstimate = measurement;
      return measurement;
    }

    double prediction = _lastEstimate!;
    double kalmanGain = _e / (_e + _q);
    double estimate = prediction + kalmanGain * (measurement - prediction);

    _e = (1 - kalmanGain) * _e + ((_lastEstimate! - estimate).abs()) * _q;
    _lastEstimate = estimate;

    return estimate;
  }
}

Widget _buildOfflineMessageBox(BuildContext context) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      constraints: BoxConstraints(maxWidth: 300), // Maximum width
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        children: [
          Icon(Icons.map_outlined, size: 50, color: Colors.white),
          SizedBox(height: 15),
          Text(
            'Map for your current location is not downloaded yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Download the map to use offline features',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.pushNamed(
                'pcicMap',
                extra: <String, dynamic>{
                  kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200),
                  ),
                },
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.green),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: Text('Download Map'),
          ),
        ],
      ),
    ),
  );
}

//---------------------------- THE RECENT MAP ----------------

// // Automatic FlutterFlow imports
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/backend/sqlite/sqlite_manager.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart' as ll;
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart' as FMTC;
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:p_c_i_c_mobile_app/dashboard/geotag/geotagging/geotagging_model.dart';

// class MapBox extends StatefulWidget {
//   const MapBox({
//     Key? key,
//     this.width,
//     this.height,
//     this.accessToken,
//     this.taskId,
//   }) : super(key: key);

//   final double? width;
//   final double? height;
//   final String? accessToken;
//   final String? taskId;

//   @override
//   State<MapBox> createState() => _MapBoxState();
// }

// class _MapBoxState extends State<MapBox> {
//   late GeotaggingModel _model;
//   final MapController _mapController = MapController();
//   StreamSubscription<Position>? _positionStreamSubscription;

//   ll.LatLng? _currentLocation;
//   List<ll.LatLng> _routeCoordinates = [];
//   ll.LatLng? _startingPosition;
//   final ll.Distance _distance = ll.Distance();

//   bool _isTracking = false;
//   bool _isMapReady = false;
//   bool storeFound = false;

//   TileProvider? _tileProvider;
//   String? _storeName;

//   String? _errorMessage;

//   static const double _currentZoom = 19.0;
//   static const int _positionStreamIntervalMs = 100;
//   static const int _initialPositionSamples = 20;
//   static const double _highAccuracyThreshold = 10.0;
//   static const double _stationarySpeedThreshold = 0.1;
//   static const double _significantMovementThreshold = 0.5;
//   static const int _stationaryWindowSize = 20;
//   static const double _autoSnapThreshold = 1.0;
//   static const int _minPointsForAutosnap = 10;

//   late SimpleKalmanFilter _latFilter;
//   late SimpleKalmanFilter _lonFilter;

//   List<Position> _recentPositions = [];

//   ll.LatLng _averagePosition = ll.LatLng(0, 0);
//   bool _isStationary = true;

//   DateTime _lastUpdateTime = DateTime.now();
//   double? _currentHeading;
//   ll.LatLng? _lastFilteredLocation;

//   @override
//   void initState() {
//     super.initState();
//     _latFilter =
//         SimpleKalmanFilter(e: 3, q: 0.02); // Decreased q from 0.5 to 0.02
//     _lonFilter =
//         SimpleKalmanFilter(e: 3, q: 0.02); // Decreased q from 0.5 to 0.02
//     _initializeMapComponents();
//   }

//   Future<void> _initializeMapComponents() async {
//     await _checkConnectivity();
//     await _initializeLocation();
//     await _initializeTileProvider();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> _checkConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         _errorMessage = "No internet connection.";
//       });
//     } else {
//       FFAppState().mapLoadedWithInternet = true;
//     }
//   }

//   Future<ll.LatLng?> _initializeLocation() async {
//     try {
//       await _checkLocationPermission();
//       await _checkLocationAccuracy();

//       Position initialPosition = await _getAccuratePosition();

//       if (!mounted) return null;

//       _currentLocation =
//           ll.LatLng(initialPosition.latitude, initialPosition.longitude);
//       _routeCoordinates.add(_currentLocation!);
//       if (_isMapReady) {
//         _mapController.move(_currentLocation!, _currentZoom);
//       }

//       _startLocationStream();
//       return _currentLocation;
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = "Initialization error: $e";
//         });
//       }
//       return null;
//     }
//   }

//   Future<Position> _getAccuratePosition() async {
//     List<Position> samples = [];
//     for (int i = 0; i < _initialPositionSamples; i++) {
//       Position position = await _getCurrentPositionWithRetry();
//       samples.add(position);
//       await Future.delayed(Duration(milliseconds: 200));
//     }

//     double sumLat = 0, sumLon = 0, sumAcc = 0;
//     for (var pos in samples) {
//       sumLat += pos.latitude;
//       sumLon += pos.longitude;
//       sumAcc += pos.accuracy;
//     }

//     double avgLat = sumLat / _initialPositionSamples;
//     double avgLon = sumLon / _initialPositionSamples;
//     double avgAcc = sumAcc / _initialPositionSamples;

//     _latFilter = SimpleKalmanFilter(
//         e: avgAcc, q: 0.01); // Increased q from 0.001 to 0.01
//     _lonFilter = SimpleKalmanFilter(
//         e: avgAcc, q: 0.01); // Increased q from 0.001 to 0.01

//     return Position(
//       latitude: avgLat,
//       longitude: avgLon,
//       timestamp: DateTime.now(),
//       accuracy: avgAcc,
//       altitude: samples.last.altitude,
//       heading: samples.last.heading,
//       speed: samples.last.speed,
//       speedAccuracy: samples.last.speedAccuracy,
//       altitudeAccuracy: samples.last.altitudeAccuracy ?? 0,
//       headingAccuracy: samples.last.headingAccuracy ?? 0,
//     );
//   }

//   Future<void> _initializeTileProvider() async {
//     if (_currentLocation == null) {
//       print('Current location is null, trying to get location');
//       _currentLocation = await _initializeLocation();
//       if (_currentLocation == null) {
//         print('Failed to get current location');
//         return;
//       }
//     }

//     final stats = FMTC.FMTCRoot.stats;
//     final stores = await stats.storesAvailable;

//     print('Available stores: ${stores.length}');
//     print(
//         'Current location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}');

//     for (var store in stores) {
//       print('Checking store: ${store.storeName}');
//       final md = FMTC.FMTCStore(store.storeName).metadata;
//       final metadata = await md.read;
//       print('Metadata for ${store.storeName}: $metadata');

//       if (metadata != null) {
//         try {
//           Map<String, num> regionData = {
//             'region_south': _parseNum(metadata['region_south']),
//             'region_north': _parseNum(metadata['region_north']),
//             'region_west': _parseNum(metadata['region_west']),
//             'region_east': _parseNum(metadata['region_east']),
//           };
//           print('Parsed region data: $regionData');

//           if (_isLocationInRegion(_currentLocation!, regionData)) {
//             _storeName = store.storeName;
//             print(
//                 'FOUND MAP BASE ON THE CURRENT LOCATION OF THE USER ----------------------: $_storeName');
//             storeFound = true;
//             break;
//           }
//         } catch (e) {
//           print('Error processing metadata for ${store.storeName}: $e');
//         }
//       } else {
//         print('Metadata is null for ${store.storeName}');
//       }
//     }

//     if (!storeFound) {
//       print('No matching store found for the current location.');
//     } else if (_storeName != null) {
//       _tileProvider = FMTC.FMTCStore(_storeName!).getTileProvider(
//         settings: FMTC.FMTCTileProviderSettings(
//           behavior: FMTC.CacheBehavior.cacheFirst,
//         ),
//       );
//       print('Tile provider initialized with store: $_storeName');
//       print('_tileProvider: $_tileProvider');
//     } else {
//       print('No store available to initialize tile provider');
//     }
//   }

//   bool _isLocationInRegion(ll.LatLng location, Map<String, num> region) {
//     print('Checking location: ${location.latitude}, ${location.longitude}');
//     print('Region: $region');

//     return location.latitude >= region['region_south']! &&
//         location.latitude <= region['region_north']! &&
//         location.longitude >= region['region_west']! &&
//         location.longitude <= region['region_east']!;
//   }

//   num _parseNum(dynamic value) {
//     if (value is num) {
//       return value;
//     } else if (value is String) {
//       return num.parse(value);
//     } else {
//       throw FormatException('Cannot parse $value to num');
//     }
//   }

//   Future<void> _checkLocationPermission() async {
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) throw Exception('Location services are disabled.');

//     var permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied');
//     }
//   }

//   Future<void> _checkLocationAccuracy() async {
//     try {
//       LocationAccuracyStatus accuracy = await Geolocator.getLocationAccuracy();
//       if (accuracy == LocationAccuracyStatus.reduced && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Please enable precise location for better accuracy'),
//             action: SnackBarAction(
//               label: 'Settings',
//               onPressed: () {
//                 Geolocator.openAppSettings();
//               },
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error checking location accuracy: $e');
//     }
//   }

//   Future<Position> _getCurrentPositionWithRetry({int retries = 0}) async {
//     try {
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//         timeLimit: Duration(seconds: 10),
//       );
//     } catch (e) {
//       if (retries < 3) {
//         await Future.delayed(Duration(seconds: 2));
//         return _getCurrentPositionWithRetry(retries: retries + 1);
//       } else {
//         _showSnackbar("Failed to get accurate location, using best effort.");
//         return await Geolocator.getLastKnownPosition() ??
//             Position(
//               longitude: 0.0,
//               latitude: 0.0,
//               timestamp: DateTime.now(),
//               accuracy: 0.0,
//               altitude: 0.0,
//               heading: 0.0,
//               speed: 0.0,
//               speedAccuracy: 0.0,
//               altitudeAccuracy: 0.0,
//               headingAccuracy: 0.0,
//             );
//       }
//     }
//   }

//   Future<bool> _isGpsEnabled() async {
//     return await Geolocator.isLocationServiceEnabled();
//   }

//   void _startLocationStream() {
//     final LocationSettings locationSettings = AndroidSettings(
//       accuracy: LocationAccuracy.bestForNavigation,
//       distanceFilter: 1,
//       forceLocationManager: false,
//       intervalDuration: Duration(milliseconds: _positionStreamIntervalMs),
//     );

//     _positionStreamSubscription = Geolocator.getPositionStream(
//       locationSettings: locationSettings,
//     ).listen(
//       (Position position) {
//         if (mounted) {
//           _processNewPosition(position);
//         }
//       },
//       onError: (error) {
//         print("Location stream error: $error");
//         _restartLocationStream();
//       },
//     );
//   }

//   void _restartLocationStream() {
//     _positionStreamSubscription?.cancel();
//     Future.delayed(Duration(seconds: 1), _startLocationStream);
//   }

//   void _processNewPosition(Position position) {
//     // Apply Kalman filter for the marker position
//     double filteredLat = _latFilter.filter(position.latitude);
//     double filteredLon = _lonFilter.filter(position.longitude);
//     ll.LatLng filteredLocation = ll.LatLng(filteredLat, filteredLon);

//     // Use raw coordinates for the route
//     ll.LatLng rawLocation = ll.LatLng(position.latitude, position.longitude);

//     _updatePosition(
//         filteredLocation, rawLocation, position.heading, position.speed);
//   }

//   void _updatePosition(ll.LatLng filteredLocation, ll.LatLng rawLocation,
//       double heading, double speed) {
//     setState(() {
//       _currentLocation =
//           filteredLocation; // Use filtered location for the marker
//       _currentHeading = heading;
//       _lastFilteredLocation = filteredLocation;
//       _lastUpdateTime = DateTime.now();

//       if (_isMapReady && _shouldRecenterMap()) {
//         _mapController.move(_currentLocation!, _currentZoom);
//         if (speed > _stationarySpeedThreshold) {
//           _mapController.rotate(heading);
//         }
//       }

//       if (_isTracking) {
//         _addToRoute(rawLocation); // Use raw location for the route
//       }
//     });
//   }

//   void _addToRoute(ll.LatLng newLocation) async {
//     if (_startingPosition == null) {
//       _startingPosition = newLocation;
//     }

//     setState(() {
//       _routeCoordinates.add(newLocation);
//     });

//     if (_routeCoordinates.length >= _minPointsForAutosnap) {
//       double distanceToStart = _distance.as(
//         ll.LengthUnit.Meter,
//         _startingPosition!,
//         newLocation,
//       );

//       if (distanceToStart <= _autoSnapThreshold) {
//         print("Autosnap condition met. Executing completion logic...");

//         // Replace the last point with the starting point to ensure proper closure
//         _routeCoordinates.last = _startingPosition!;

//         // Add the first point again to close the route
//         if (_routeCoordinates.first != _routeCoordinates.last) {
//           _routeCoordinates.add(_routeCoordinates.first);
//         }

//         print(
//             "Route closed. First and last coordinates: ${_routeCoordinates.first}, ${_routeCoordinates.last}");

//         // Perform the autosnap and execute the provided code
//         FFAppState().routeStarted = false;

//         try {
//           if (FFAppState().ONLINE) {
//             await TasksTable().update(
//               data: {
//                 'status': 'ongoing',
//               },
//               matchingRows: (rows) => rows.eq(
//                 'id',
//                 widget.taskId,
//               ),
//             );
//             print("Online task status updated");
//           }

//           await SQLiteManager.instance.updateTaskStatus(
//             taskId: widget.taskId,
//             status: 'ongoing',
//             isDirty: !FFAppState().ONLINE,
//           );
//           print("SQLite task status updated");

//           // Safely update the model
//           try {
//             _model.isGeotagStart = false;
//             _model.isFinished = true;
//             print("Model updated successfully");
//           } catch (modelError) {
//             print("Error updating model: $modelError");
//           }

//           // Force a rebuild to update the map
//           setState(() {});

//           print("Attempting navigation to gpxSuccess...");

//           // Use a more robust navigation method
//           if (mounted && context.mounted) {
//             await Future.delayed(Duration.zero, () {
//               context.pushNamed(
//                 'gpxSuccess',
//                 queryParameters: {
//                   'taskId': serializeParam(
//                     widget.taskId,
//                     ParamType.String,
//                   ),
//                 }.withoutNulls,
//                 extra: <String, dynamic>{
//                   kTransitionInfoKey: const TransitionInfo(
//                     hasTransition: true,
//                     transitionType: PageTransitionType.scale,
//                     alignment: Alignment.bottomCenter,
//                     duration: Duration(milliseconds: 300),
//                   ),
//                 },
//               );
//             });
//             print("Navigation to gpxSuccess initiated");
//           } else {
//             print("Context is not available for navigation");
//           }
//         } catch (e) {
//           print("Error during autosnap completion: $e");
//           // Attempt navigation even if there was an error
//           if (mounted && context.mounted) {
//             context.pushNamed('gpxSuccess',
//                 queryParameters: {'taskId': widget.taskId});
//           }
//         }
//       }
//     }
//   }

//   Future<void> _startTracking() async {
//     if (_currentLocation != null && !_isTracking) {
//       bool gpsEnabled = await _isGpsEnabled();
//       if (!gpsEnabled) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(
//                 'GPS is not enabled. Please turn on GPS to start tracking.'),
//           ));
//         }
//         FFAppState().routeStarted = false;
//         return;
//       }

//       try {
//         setState(() {
//           _isTracking = true;
//           _routeCoordinates.clear();
//           _startingPosition = _currentLocation;
//         });

//         Position startPosition = await _getAccuratePosition();
//         if (!mounted) return;

//         setState(() {
//           _startingPosition =
//               ll.LatLng(startPosition.latitude, startPosition.longitude);
//           _routeCoordinates.add(_startingPosition!);
//         });

//         FFAppState().routeStarted = true;
//       } catch (e) {
//         if (mounted) {
//           setState(() {
//             _isTracking = false;
//             _errorMessage = "Failed to start tracking: $e";
//           });
//         }
//         FFAppState().routeStarted = false;
//       }
//     }
//   }

//   void _completeTracking() {
//     if (_routeCoordinates.isEmpty) return;

//     if (_routeCoordinates.first != _routeCoordinates.last) {
//       _routeCoordinates.add(_routeCoordinates.first);
//     }

//     print('Route completed. Total points: ${_routeCoordinates.length}');

//     double totalDistance = calculateTotalDistance(_routeCoordinates);
//     print('Total distance: $totalDistance meters');

//     double area = 0.0;
//     if (_routeCoordinates.length >= 3) {
//       area = calculateAreaOfPolygon(_routeCoordinates);
//       print('Area: $area square meters');
//     }

//     String routeCoordinatesString = _routeCoordinates
//         .map((point) => '${point.latitude},${point.longitude}')
//         .join(' ');

//     String lastCoord =
//         '${_routeCoordinates.last.latitude},${_routeCoordinates.last.longitude}';
//     print("Last coord: $lastCoord");

//     String currentDateTime = DateTime.now().toIso8601String();
//     print("Current date time: $currentDateTime");

//     String areaInHectares = (area / 10000).toString();
//     print("Area in hectares: $areaInHectares");

//     String distanceInKilometers = (totalDistance / 1000).toString();
//     print("Distance in kilometers: $distanceInKilometers");

//     saveGpx(
//       widget.taskId ?? 'default_task_id',
//       routeCoordinatesString,
//       lastCoord,
//       currentDateTime,
//       areaInHectares,
//       distanceInKilometers,
//     );

//     setState(() {
//       _routeCoordinates.clear();
//       _isTracking = false;
//       FFAppState().routeStarted = false;
//     });
//   }

//   double calculateTotalDistance(List<ll.LatLng> points) {
//     double totalDistance = 0.0;
//     for (int i = 0; i < points.length - 1; i++) {
//       totalDistance += const ll.Distance().as(
//         ll.LengthUnit.Meter,
//         points[i],
//         points[i + 1],
//       );
//     }
//     return totalDistance;
//   }

//   double calculateAreaOfPolygon(List<ll.LatLng> points) {
//     if (points.length < 3) {
//       return 0.0;
//     }
//     double radius = 6378137.0;
//     double area = 0.0;

//     for (int i = 0; i < points.length; i++) {
//       ll.LatLng p1 = points[i];
//       ll.LatLng p2 = points[(i + 1) % points.length];

//       double lat1 = p1.latitudeInRad;
//       double lon1 = p1.longitudeInRad;
//       double lat2 = p2.latitudeInRad;
//       double lon2 = p2.longitudeInRad;

//       double segmentArea = 2 *
//           atan2(
//             tan((lon2 - lon1) / 2) * tan((lat1 + lat2) / 2),
//             1 + tan(lat1 / 2) * tan(lat2 / 2) * cos(lon1 - lon2),
//           );
//       area += segmentArea;
//     }

//     return (area * radius * radius).abs();
//   }

//   void _recenterMap() {
//     if (_currentLocation != null && _isMapReady) {
//       _mapController.move(_currentLocation!, _currentZoom);
//     }
//   }

//   bool _shouldRecenterMap() {
//     if (!_isMapReady || _currentLocation == null) return false;

//     final mapBounds = LatLngBounds.fromPoints(
//       [
//         _calculateOffset(_currentLocation!, _mapController.camera.zoom, -1, -1),
//         _calculateOffset(_currentLocation!, _mapController.camera.zoom, 1, 1),
//       ],
//     );

//     final currentPoint =
//         _mapController.camera.latLngToScreenPoint(_currentLocation!);

//     return currentPoint == null || !mapBounds.contains(_currentLocation!);
//   }

//   ll.LatLng _calculateOffset(
//       ll.LatLng center, double zoom, double xOffset, double yOffset) {
//     final double scaleFactor = 0.01 / zoom;
//     return ll.LatLng(
//       center.latitude + (scaleFactor * yOffset),
//       center.longitude + (scaleFactor * xOffset),
//     );
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   void dispose() {
//     _positionStreamSubscription?.cancel();
//     _mapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appState = FFAppState();

//     if (_currentLocation == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (!appState.mapLoadedWithInternet && storeFound == false) {
//       return _buildOfflineMessageBox(this.context);
//     }

//     if (appState.routeStarted && !_isTracking) {
//       _startTracking();
//     }

//     if (!appState.routeStarted && _isTracking) {
//       _completeTracking();
//     }

//     if (_errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Error: $_errorMessage'),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _errorMessage = null;
//                 });
//                 _initializeLocation();
//               },
//               child: Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         SizedBox(
//           width: widget.width ?? MediaQuery.of(context).size.width,
//           height: widget.height ?? MediaQuery.of(context).size.height,
//           child: FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: _currentLocation!,
//               initialZoom: _currentZoom,
//               minZoom: 18,
//               maxZoom: 22,
//               onMapReady: () {
//                 setState(() {
//                   _isMapReady = true;
//                   if (_currentLocation != null) {
//                     _mapController.move(_currentLocation!, _currentZoom);
//                   }
//                 });
//               },
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}@2x?access_token=${widget.accessToken}',
//                 additionalOptions: {
//                   'accessToken': widget.accessToken ?? '',
//                 },
//                 tileProvider: _tileProvider,
//               ),
//               CurrentLocationLayer(
//                 followOnLocationUpdate: FollowOnLocationUpdate.always,
//                 style: LocationMarkerStyle(
//                   marker: const DefaultLocationMarker(color: Colors.green),
//                   markerSize: const Size(12, 12),
//                   markerDirection: MarkerDirection.heading,
//                   accuracyCircleColor: Colors.green.withOpacity(0.2),
//                   headingSectorColor: Colors.green.withOpacity(0.8),
//                   headingSectorRadius: 60,
//                 ),
//                 moveAnimationDuration: Duration.zero,
//               ),
//               if (_routeCoordinates.isNotEmpty &&
//                   (appState.routeStarted || _isTracking))
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _routeCoordinates,
//                       strokeWidth: 3.0,
//                       color: Colors.blue,
//                     ),
//                   ],
//                 ),
//               MarkerLayer(
//                 markers: _startingPosition != null
//                     ? [
//                         Marker(
//                           point: _startingPosition!,
//                           child: Icon(
//                             Icons.pin_drop,
//                             color: Colors.red,
//                             size: 14.0,
//                           ),
//                         ),
//                       ]
//                     : [],
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 50,
//           right: 20,
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Color(0x7f0f1113),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.transparent, width: 1),
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(30),
//                 onTap: _recenterMap,
//                 child: Center(
//                   child: Icon(
//                     Icons.my_location_outlined,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SimpleKalmanFilter {
//   double _e;
//   double _q;
//   double? _lastEstimate;

//   SimpleKalmanFilter({required double e, required double q})
//       : _e = e,
//         _q = q;

//   double filter(double measurement) {
//     if (_lastEstimate == null) {
//       _lastEstimate = measurement;
//       return measurement;
//     }

//     double prediction = _lastEstimate!;
//     double kalmanGain = _e / (_e + _q);
//     double estimate = prediction + kalmanGain * (measurement - prediction);

//     _e = (1 - kalmanGain) * _e + ((_lastEstimate! - estimate).abs()) * _q;
//     _lastEstimate = estimate;

//     return estimate;
//   }
// }

// Widget _buildOfflineMessageBox(BuildContext context) {
//   return Center(
//     child: Container(
//       width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
//       constraints: BoxConstraints(maxWidth: 300), // Maximum width
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.green,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Use minimum space needed
//         children: [
//           Icon(Icons.map_outlined, size: 50, color: Colors.white),
//           SizedBox(height: 15),
//           Text(
//             'Map for your current location is not downloaded yet',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Download the map to use offline features',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               context.pushNamed(
//                 'pcicMap',
//                 extra: <String, dynamic>{
//                   kTransitionInfoKey: const TransitionInfo(
//                     hasTransition: true,
//                     transitionType: PageTransitionType.rightToLeft,
//                     duration: Duration(milliseconds: 200),
//                   ),
//                 },
//               );
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.white),
//               foregroundColor: MaterialStateProperty.all(Colors.green),
//               padding: MaterialStateProperty.all(
//                   EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
//               shape: MaterialStateProperty.all(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             child: Text('Download Map'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
