// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class OnlineStatusTracker {
  static final OnlineStatusTracker _instance = OnlineStatusTracker._internal();
  factory OnlineStatusTracker() => _instance;

  OnlineStatusTracker._internal();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = false;
  bool _isInitialized = false;
  AppLifecycleListener? _lifecycleListener;
  Timer? _periodicUpdateTimer;

  Future initialize() async {
    if (_isInitialized) return;

    final supabase = SupaFlow.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      print('No authenticated user found');
      return;
    }

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      bool newOnlineStatus = results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);
      if (_isOnline != newOnlineStatus) {
        _isOnline = newOnlineStatus;
        if (_isOnline) {
          await _updatePresenceStatus();
        } else {
          await _setOfflineStatus();
        }
      }
    });

    _lifecycleListener = AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) {
          _setOfflineStatus();
        } else if (state == AppLifecycleState.resumed) {
          _updatePresenceStatus();
        }
      },
    );

    _isOnline =
        (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
    if (_isOnline) {
      await _updatePresenceStatus();
    }

    // Start periodic updates every 10 seconds
    _periodicUpdateTimer = Timer.periodic(Duration(seconds: 30), (_) {
      if (_isOnline) {
        _updatePresenceStatus();
      }
    });

    _isInitialized = true;
  }

  Future _updatePresenceStatus() async {
    try {
      final user = SupaFlow.client.auth.currentUser;
      if (user == null) return;

      await SupaFlow.client.rpc('update_user_online_status', params: {
        'p_user_id': user.id,
        'p_is_online': true,
      });
      print("Successfully updated user online status to true");
    } catch (e) {
      print('Failed to update user online status: $e');
      if (e.toString().contains(
          'column "inactivity_check_time" of relation "users" does not exist')) {
        await _fallbackUpdateStatus(true);
      }
    }
  }

  Future _setOfflineStatus() async {
    try {
      final user = SupaFlow.client.auth.currentUser;
      if (user == null) return;

      await SupaFlow.client.rpc('update_user_online_status', params: {
        'p_user_id': user.id,
        'p_is_online': false,
      });
      print("Successfully updated user online status to false");
    } catch (e) {
      print('Failed to update user offline status: $e');
      if (e.toString().contains(
          'column "inactivity_check_time" of relation "users" does not exist')) {
        await _fallbackUpdateStatus(false);
      }
    }
  }

  Future _fallbackUpdateStatus(bool isOnline) async {
    try {
      final user = SupaFlow.client.auth.currentUser;
      if (user == null) return;

      await UsersTable().update(
        data: {
          'is_online': isOnline,
          'last_seen': DateTime.now().toUtc().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq(
          'id',
          user.id,
        ),
      );
      print(
          "Successfully updated user status to $isOnline using fallback method");
    } catch (e) {
      print('Failed to update user status using fallback method: $e');
    }
  }

  Future dispose() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    _lifecycleListener?.dispose();
    _lifecycleListener = null;

    _periodicUpdateTimer?.cancel();
    _periodicUpdateTimer = null;

    _isInitialized = false;
    await _setOfflineStatus();
  }
}

// This function will be called to update the user's online status
Future updateUserOnlineStatus() async {
  await OnlineStatusTracker().initialize();
}

// This function will be called to dispose of the tracker
Future disposeOnlineStatusTracker() async {
  await OnlineStatusTracker().dispose();
}
