import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = const FlutterSecureStorage();
    await _safeInitAsync(() async {
      _usersEmail =
          await secureStorage.getString('ff_usersEmail') ?? _usersEmail;
    });
    await _safeInitAsync(() async {
      _mapDownloadProgress =
          await secureStorage.getDouble('ff_mapDownloadProgress') ??
              _mapDownloadProgress;
    });
    await _safeInitAsync(() async {
      _accessToken =
          await secureStorage.getString('ff_accessToken') ?? _accessToken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  bool _ONLINE = false;
  bool get ONLINE => _ONLINE;
  set ONLINE(bool value) {
    _ONLINE = value;
  }

  bool _routeStarted = false;
  bool get routeStarted => _routeStarted;
  set routeStarted(bool value) {
    _routeStarted = value;
  }

  String _usersEmail = '';
  String get usersEmail => _usersEmail;
  set usersEmail(String value) {
    _usersEmail = value;
    secureStorage.setString('ff_usersEmail', value);
  }

  void deleteUsersEmail() {
    secureStorage.delete(key: 'ff_usersEmail');
  }

  bool _startMapDownload = false;
  bool get startMapDownload => _startMapDownload;
  set startMapDownload(bool value) {
    _startMapDownload = value;
  }

  double _mapDownloadProgress = 0.0;
  double get mapDownloadProgress => _mapDownloadProgress;
  set mapDownloadProgress(double value) {
    _mapDownloadProgress = value;
    secureStorage.setDouble('ff_mapDownloadProgress', value);
  }

  void deleteMapDownloadProgress() {
    secureStorage.delete(key: 'ff_mapDownloadProgress');
  }

  String _accessToken =
      'pk.eyJ1IjoicXVhbmJ5IiwiYSI6ImNtMmR2MnQ4ODFnbnoyanE0MWc3Nm1kZDgifQ.dc3sgovzWACKf0JK_DaP7g';
  String get accessToken => _accessToken;
  set accessToken(String value) {
    _accessToken = value;
    secureStorage.setString('ff_accessToken', value);
  }

  void deleteAccessToken() {
    secureStorage.delete(key: 'ff_accessToken');
  }

  List<MapStatsStruct> _listOfMapDownloads = [];
  List<MapStatsStruct> get listOfMapDownloads => _listOfMapDownloads;
  set listOfMapDownloads(List<MapStatsStruct> value) {
    _listOfMapDownloads = value;
  }

  void addToListOfMapDownloads(MapStatsStruct value) {
    listOfMapDownloads.add(value);
  }

  void removeFromListOfMapDownloads(MapStatsStruct value) {
    listOfMapDownloads.remove(value);
  }

  void removeAtIndexFromListOfMapDownloads(int index) {
    listOfMapDownloads.removeAt(index);
  }

  void updateListOfMapDownloadsAtIndex(
    int index,
    MapStatsStruct Function(MapStatsStruct) updateFn,
  ) {
    listOfMapDownloads[index] = updateFn(_listOfMapDownloads[index]);
  }

  void insertAtIndexInListOfMapDownloads(int index, MapStatsStruct value) {
    listOfMapDownloads.insert(index, value);
  }

  String _mapBoxKeyString = '';
  String get mapBoxKeyString => _mapBoxKeyString;
  set mapBoxKeyString(String value) {
    _mapBoxKeyString = value;
  }

  bool _mapLoadedWithInternet = false;
  bool get mapLoadedWithInternet => _mapLoadedWithInternet;
  set mapLoadedWithInternet(bool value) {
    _mapLoadedWithInternet = value;
  }

  int _syncCount = 0;
  int get syncCount => _syncCount;
  set syncCount(int value) {
    _syncCount = value;
  }

  String _whatPage = '';
  String get whatPage => _whatPage;
  set whatPage(String value) {
    _whatPage = value;
  }

  String _captureImageBlob = '';
  String get captureImageBlob => _captureImageBlob;
  set captureImageBlob(String value) {
    _captureImageBlob = value;
  }

  String _capturedArea = '';
  String get capturedArea => _capturedArea;
  set capturedArea(String value) {
    _capturedArea = value;
  }

  String _geoJsonFileName = '';
  String get geoJsonFileName => _geoJsonFileName;
  set geoJsonFileName(String value) {
    _geoJsonFileName = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return const CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: const ListToCsvConverter().convert([value]));
}
