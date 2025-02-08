import 'package:flutter/material.dart';

import '../../../domain/models/suite_model.dart';
import 'image_network_widget.dart';

class SuiteWidget extends StatelessWidget {
  final Suite model;

  const SuiteWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    void showFullScreenModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(
                  model.nome,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 32.0,
                  ),
                ),
                SizedBox(height: 20),
                SeparatorText(text: "Principais itens"),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: model.categoriaItens.map((categoria) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: ImageNetworkWidget(photoUrl: categoria.icone),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(categoria.nome),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                SeparatorText(text: "tem também"),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Text(
                    model.itens.map((item) => item.nome).join(", "),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.keyboard_arrow_down_outlined, size: 40),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        children: [
          _containerWidget(
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
          _containerWidget(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...model.categoriaItens.take(5).map((item) {
                return _iconeCategoria(item.icone);
              }),
              GestureDetector(
                onTap: () => showFullScreenModal(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("ver"),
                    Text("todos"),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => showFullScreenModal(),
                icon: Icon(Icons.arrow_downward),
              )
            ],
          )),
          ...model.periodos.map((periodo) {
            return _containerWidget(
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
      ),
    );
  }

  Widget _containerWidget({required Widget child}) {
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

  Widget _iconeCategoria(String url) {
    return SizedBox(
      height: 40,
      width: 40,
      child: ImageNetworkWidget(photoUrl: url),
    );
  }
}

class SeparatorText extends StatelessWidget {
  final String text;
  const SeparatorText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey, // Color of the text
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
