import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/view/ir_agora_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const IrAgoraPage(),
    );
  }
}
