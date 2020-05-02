import 'package:package_info/package_info.dart';

class AboutModel {
  Future<PackageInfo> getPackageInfo() async {
    return PackageInfo.fromPlatform();
  }
}
