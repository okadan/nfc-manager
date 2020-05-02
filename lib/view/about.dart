import 'package:flutter/material.dart';
import 'package:flutter_nfc_manager/view/widgets/list.dart';
import 'package:flutter_nfc_manager/viewmodel/about.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static Widget create() => Provider<AboutModel>(
    create: (context) => AboutModel(),
    child: AboutPage(),
  );

  @override
  Widget build(BuildContext context) {
    final AboutModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: SafeArea(
        child: FutureBuilder<PackageInfo>(
          future: model.getPackageInfo(),
          builder: (context, snapshot) =>  ListView(
            padding: EdgeInsets.all(2),
            children: [
              ListCellGroup(children: [
                ListCell(
                  title: Text('Name'),
                  trailing: Text('${snapshot.data?.appName}'),
                ),
                ListCell(
                  title: Text('Version'),
                  trailing: Text('${snapshot.data?.version}'),
                ),
                ListCell(
                  title: Text('Built Number'),
                  trailing: Text('${snapshot.data?.buildNumber}'),
                ),
              ]),
              ListCellGroup(children: [
                ListCell(
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.open_in_browser),
                  onTap: () => launch('https://nfcmanager.naokiokada.com/privacy-policy/'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
