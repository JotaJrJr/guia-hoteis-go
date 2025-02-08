import 'package:flutter/material.dart';

import '../../../domain/models/suite_model.dart';
import 'image_network_widget.dart';

class SuiteWidget extends StatelessWidget {
  final Suite model;

  const SuiteWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        containerWidget(
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ImageNetworkWidget(
                  photoUrl: model.fotos[0],
                ),
              ),
              Text(model.nome),
            ],
          ),
        ),
        containerWidget(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...model.categoriaItens.map((item) {
              return iconeCategoria(item.icone);
            }),
            // todo : vai ser o texto e o ícone clicáveis
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("ver"),
                Text("todos"),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_downward),
            )
          ],
        )),
        ...model.periodos.map((periodo) {
          return containerWidget(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          periodo.tempoFormatado,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          "R\$ ${periodo.valor}",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget containerWidget({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  Widget iconeCategoria(String url) {
    return SizedBox(
      height: 20,
      width: 20,
      child: ImageNetworkWidget(photoUrl: url),
    );
  }
}
