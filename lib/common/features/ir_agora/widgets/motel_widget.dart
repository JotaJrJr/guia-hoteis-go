import 'package:flutter/material.dart';

import '../../../domain/models/motel_model.dart';
import '../../../domain/models/suite_model.dart';
import 'image_network_widget.dart';
import 'suite_widget.dart';

class MotelWidget extends StatelessWidget {
  final Motel model;
  const MotelWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CircleAvatar(
                radius: 30,
                child: ImageNetworkWidget(photoUrl: model.logo),
              ),
            ),
            Column(
              children: [
                Text(model.fantasia),
                Text(model.bairro),
              ],
            ),
            FlutterLogo(),
          ],
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          height: 900,
          child: PageView.builder(
            itemCount: model.suites.length,
            itemBuilder: (context, index) {
              final Suite suite = model.suites[index];

              return SuiteWidget(
                model: suite,
              );
            },
          ),
        )
      ],
    );
  }
}
