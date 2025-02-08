import 'package:flutter/material.dart';

import '../../../domain/models/motel_model.dart';
import '../../../domain/models/suite_model.dart';
import 'image_network_widget.dart';
import 'suite_widget.dart';

class MotelWidget extends StatelessWidget {
  final Motel model;
  const MotelWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(
          height: 500,
          child: PageView.builder(
            itemCount: model.suites.length,
            itemBuilder: (context, index) {
              final Suite suite = model.suites[index];

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SuiteWidget(model: suite),
              );
            },
          ),
        ),
      ],
    );
  }
}
