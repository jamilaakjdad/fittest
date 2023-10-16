import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: MenuWidget(),
        ),
      );
}
