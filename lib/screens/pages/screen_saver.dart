/*
  * Yeal loading welcome in 3 seconds
*/

import 'package:flutter/material.dart';

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    final listTiles = <Widget>[
      const ListTile(
        title: Text('Tile 0: basic'),
      ),
      const Divider(),
      const ListTile(
        leading: Icon(Icons.face),
        title: Text('Tile 1: with leading/trailing widgets'),
        trailing: Icon(Icons.tag_faces),
      ),
      const Divider(),
      const ListTile(
        title: Text('Tile 2 title'),
        subtitle: Text('subtitle of tile 2'),
      ),
      const Divider(),
      const ListTile(
        title: Text('Tile 3: 3 lines'),
        isThreeLine: true,
        subtitle: Text('subtitle of tile 3'),
      ),
      const Divider(),
      const ListTile(
        title: Text('Tile 4: dense'),
        dense: true,
      ),
      const Divider(),
      const ListTile(
        title: Text('Tile5: tile with badge'),
        subtitle: Text('(This uses the badges package)'),
        trailing: Badge(
          label: Text('3'),
          child: Icon(Icons.message),
        ),
      ),
    ];
    // Directly returning a list of widgets is not common practice.
    // People usually use ListView.builder, c.f. "ListView.builder" example.
    // Here we mainly demostrate ListTile.
    return ListView(children: listTiles);
  }
}