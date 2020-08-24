import 'package:app/view/common/list.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static Widget create() => AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(2),
          children: [
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, ss) => ListCellGroup(children: [
                ListCell(
                  title: Text('App Name'),
                  trailing: Text('${ss.data?.appName}'),
                ),
                ListCell(
                  title: Text('Version'),
                  trailing: Text('${ss.data?.version}'),
                ),
                ListCell(
                  title: Text('Build Number'),
                  trailing: Text('${ss.data?.buildNumber}'),
                ),
              ]),
            ),
            ListCellGroup(children: [
              ListCell(
                title: Text('Privacy Policy'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => launch('https://nfcmanager.naokiokada.com/privacy-policy/'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
