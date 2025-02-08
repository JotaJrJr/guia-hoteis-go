import 'package:flutter/material.dart';

import 'smooth_toggle_switch_widget.dart';

class IrAgoraAppBar extends StatelessWidget {
  final VoidCallback onPressed;
  const IrAgoraAppBar({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            )),
        SmoothToggleSwitch(),
        Icon(
          Icons.search,
          color: Colors.white,
        ),
      ],
    );
  }
}
