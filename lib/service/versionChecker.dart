import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VersionChecker {
  final BuildContext context;

  VersionChecker(this.context);

  // Method to fetch the latest version from Play Store
  Future<String?> _getLatestVersionFromPlayStore() async {
    final String? packageName =
        await _getPackegeName(); // Replace with your app package name
    final url =
        'https://play.google.com/store/apps/details?id=$packageName&hl=en&gl=US';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final regex = RegExp(r'Current Version.*?>([\d.]+)<');
        final match = regex.firstMatch(response.body);
        if (match != null) {
          return match.group(1);
        }
      } else {}
    } catch (e, s) {
      print('Error fetching latest version: $e => $s');
    }
    return null;
  }

  // Method to get the current version of the app
  Future<String?> _getCurrentVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // Method to get the current version of the app
  Future<String?> _getPackegeName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  // Method to compare versions and show an update prompt if needed
  Future<void> checkVersion() async {
    debugPrint("Checking version");
    WidgetsFlutterBinding.ensureInitialized();
    final latestVersion = await _getLatestVersionFromPlayStore();
    final currentVersion = await _getCurrentVersion();

    if (latestVersion != null && currentVersion != null) {
      debugPrint("Checking version Difference");
      if (_isUpdateAvailable(currentVersion, latestVersion)) {
        _showUpdateDialog();
      }
    }
  }

  bool _isUpdateAvailable(String currentVersion, String latestVersion) {
    // Compare the versions
    List<int> currentVersionParts =
        currentVersion.split('.').map((e) => int.parse(e)).toList();
    List<int> latestVersionParts =
        latestVersion.split('.').map((e) => int.parse(e)).toList();

    for (int i = 0; i < latestVersionParts.length; i++) {
      if (i >= currentVersionParts.length ||
          latestVersionParts[i] > currentVersionParts[i]) {
        return true;
      } else if (latestVersionParts[i] < currentVersionParts[i]) {
        return false;
      }
    }
    return false;
  }

  // Method to show update dialog
  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Available"),
          content: const Text(
              "A new version of the Delalaye Broker app is available. Please update to the latest version."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Later"),
            ),
            TextButton(
              onPressed: () async {
                final Uri url = Uri(
                  scheme: 'https',
                  host: 'play.google.com',
                  path: '/store/apps/details',
                  queryParameters: {
                    'id': 'com.delalayebrokers.app'
                  }, // Replace with your app package
                );

                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
