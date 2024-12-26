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

import 'dart:convert';
import 'dart:typed_data';

class Base64ImageLoader extends StatefulWidget {
  const Base64ImageLoader({
    super.key,
    this.width,
    this.height,
    this.taskId,
    this.imageBase64,
  });

  final double? width;
  final double? height;
  final String? taskId;
  final String? imageBase64;

  @override
  State<Base64ImageLoader> createState() => _Base64ImageLoaderState();
}

class _Base64ImageLoaderState extends State<Base64ImageLoader> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(Base64ImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageBase64 != oldWidget.imageBase64) {
      _loadImage();
    }
  }

  void _loadImage() {
    if (widget.imageBase64 != null && widget.imageBase64!.isNotEmpty) {
      setState(() {
        _imageData = base64.decode(widget.imageBase64!);
      });
    } else {
      setState(() {
        _imageData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 230,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _imageData != null
            ? Image.memory(
                _imageData!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return const Center(child: Text('Failed to load image'));
                },
              )
            : const Center(child: Text('No image available')),
      ),
    );
  }
}
