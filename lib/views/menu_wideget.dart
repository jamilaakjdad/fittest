import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        onPressed: () => ZoomDrawer.of(context)!.toggle(),
      );
}
