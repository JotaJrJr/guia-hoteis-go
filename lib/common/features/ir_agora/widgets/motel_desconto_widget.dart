import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/viewmodel/ir_agora_view_model.dart';

import 'image_network_widget.dart';

class MotelDescontoWidget extends StatelessWidget {
  final double discountPercentage;
  final double discountedPrice;
  final DiscountedSuiteItem item;
  const MotelDescontoWidget({super.key, required this.item, required this.discountPercentage, required this.discountedPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 170,
            height: double.infinity,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ImageNetworkWidget(
              photoUrl: item.suite.fotos[0],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "🔥",
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.motel.fantasia,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              item.motel.bairro,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${discountPercentage.toStringAsFixed(1)}% de desconto",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Divider(
                            indent: 25,
                            endIndent: 25,
                            color: Colors.white,
                          ),
                          Text(
                            "a partir de R\$ ${discountedPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.green,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "reservar  ",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
