import 'dart:async';
import 'dart:convert';
import 'dart:io' as file;
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageTools {
  static String convertImagesToBase64(File images) {
    List<int> imageBytes = images.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  // Function to decode base64 string to File
  static File decodeBase64ToFile(String base64String) {
    // File path where you want to save the decoded image
    String filePath = "decoded_image.png";
    // Decode base64 string to bytes
    List<int> bytes = base64Decode(base64String);
    // Write bytes to file
    File file = File(filePath);
    file.writeAsBytesSync(bytes);

    return file;
  }

  /// cache avatar for the chat
  static CachedNetworkImage getCachedAvatar(String avatarUrl) {
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  static BoxFit boxFit(
    String? fit, {
    BoxFit? defaultValue,
  }) {
    switch (fit) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'scaleDown':
        return BoxFit.scaleDown;
      case 'cover':
        return BoxFit.cover;
      default:
        return defaultValue ?? BoxFit.cover;
    }
  }

  // Function to decode base64 string to Uint8List
  static Uint8List decodeBase64ToUint8List(String base64String) {
    return base64.decode(base64String);
  }

  static Future<file.File> writeToFile(Uint8List? data,
      {String? fileName, String? fileExtension}) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    var filePath = '$tempPath/${fileName ?? 'file_01'}.$fileExtension';
    var f = file.File(filePath);
    if (data != null) {
      await f.writeAsBytes(data);
    }
    return f;
  }
}
