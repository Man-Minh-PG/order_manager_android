import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';


// https://fonts.google.com/icons
const _configPage = <String, IconData> {
  'home'       : Icons.home, // icon for home page add order
  'assignment' : Icons.assessment, // icon for list order page with status inprosess
  'schedule'   : Icons.schedule,  /// icon for list order page with status done 
  'product'    : Icons.fastfood, // icon for product manager
  'dashboard'  : Icons.dashboard, // icon for dashboard
};

class MyApp extends StatefulWidget {
  const MyApp({Key ? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // config tab
  final TabStyle _tabStyle = TabStyle.reactCircle;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length        :  5, 
      initialIndex  :  0,
      child: Scaffold(
        body: Column(
          children: [
            const Divider(),
            Expanded(
              child: TabBarView(
                children: [ 
                  for (final icon in _configPage.values) Icon(icon, size: 64),
                ],
              ))
          ],
        ),
        
        // this is config for butom bar
        bottomNavigationBar: ConvexAppBar.badge( // Optional badge argument: keys are tab indices, values can be
          // String, IconData, Color or Widget.
          /*badge=*/ const <int, dynamic>{3: '99+'}, // config value show for button value is three
          style: _tabStyle,
          items: <TabItem>[
            for(final entry in _configPage.entries) 
              TabItem(icon: entry.value, title: entry.key),
          ],
          // ignore: avoid_print
          onTap: (int i) => print('click index=$i'),
          ),
      )
    ); 
  }
}
