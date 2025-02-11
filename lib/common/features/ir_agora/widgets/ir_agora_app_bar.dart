import 'package:flutter/material.dart';

import 'smooth_toggle_switch_widget.dart';

class IrAgoraAppBar extends StatelessWidget {
  const IrAgoraAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
        SmoothToggleSwitch(),
        Icon(
          Icons.search,
          color: Colors.white,
        ),
      ],
    );
  }
}
