import 'package:connectivity_plus/connectivity_plus.dart';

// For checking internet connectivity
abstract class NetworkInfoI {
  Future<bool> isConnected();

  Future<ConnectivityResult> get connectivityResult;

  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  final Connectivity connectivity;

  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity);

  /// Checks if the device is connected to the internet.
  /// Returns [true] if connected (Wi-Fi, mobile, etc.), else [false].
  @override
  Future<bool> isConnected() async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
  }

  /// Gets the current connectivity type (e.g., Wi-Fi, mobile).
  @override
  Future<ConnectivityResult> get connectivityResult async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  /// Streams changes in connectivity type.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged =>
      connectivity.onConnectivityChanged.map((results) =>
          results.isNotEmpty ? results.first : ConnectivityResult.none);
}