import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/data/remote/api/hotel_api_service.dart';
import 'package:guia_hoteis_processo/common/data/remote/repositories/hotel_repository_impl.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/viewmodel/ir_agora_view_model.dart';

class IrAgoraPage extends StatefulWidget {
  const IrAgoraPage({super.key});

  @override
  State<IrAgoraPage> createState() => _IrAgoraPageState();
}

class _IrAgoraPageState extends State<IrAgoraPage> {
  late IrAgoraViewModel viewModel;
  late MotelRepository _repository;
  late HotelApiService _hotelApiService;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _hotelApiService = HotelApiService();
    _repository = MotelRepositoryImpl(_hotelApiService);
    viewModel = IrAgoraViewModel(_repository);
    viewModel.getMoteis();

    _pageController = PageController();
    _pageController.addListener(() {
      viewModel.updateCurrentPage(_pageController.page ?? 0.0);

      debugPrint("index da lista : ${viewModel.currentPage}");
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildDots(int count) {
    final double currentPage = viewModel.currentPage;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final double difference = (currentPage - index).abs();
        final double selectedness = Curves.easeOut.transform(max(0.0, 1.0 - difference));
        final double dotSize = 8.0 + (12.0 - 8.0) * selectedness;

        final Color dotColor = Color.lerp(Colors.grey, Colors.grey[600], selectedness)!;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: dotSize,
          width: dotSize,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            // ISSO VIRA UM WIDGET A LÁ APP BAR
            Row(
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
            ),
            // APP BAR
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.grey[300],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 190,
                        child: AnimatedBuilder(
                          animation: viewModel,
                          builder: (_, __) {
                            if (viewModel.isLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final List<DiscountedSuiteItem> discountedSuites = viewModel.discountedSuites;

                            if (discountedSuites.isEmpty) {
                              return Center(
                                child: Text("Sem suíte com desconto"),
                              );
                            }

                            return PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: discountedSuites.length,
                              itemBuilder: (context, index) {
                                final DiscountedSuiteItem item = discountedSuites[index];

                                // final double originalPrice = item.suite.periodos.first.valor;
                                // final double discountValue = item.suite.periodos.first.desconto?.desconto ?? 0.0;
                                // final double discountedPrice = originalPrice - discountValue;
                                // final double discountPercentage = (discountValue / originalPrice) * 100;

                                final double originalPrice = item.suite.periodos.first.valor;
                                final double discountValue = item.suite.periodos.first.desconto?.desconto ?? 0.0;

// Avoid division by zero
                                final double discountPercentage = originalPrice > 0 ? (discountValue / originalPrice) * 100 : 0.0;
                                final double discountedPrice = originalPrice - discountValue;

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
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            item.suite.fotos[0],
                                            fit: BoxFit.fill,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: progress.expectedTotalBytes != null
                                                      ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(child: Icon(Icons.error));
                                            },
                                          ),
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
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: viewModel,
                      builder: (_, __) {
                        final List<DiscountedSuiteItem> discountedSuites = viewModel.discountedSuites;
                        if (discountedSuites.isEmpty) return const SizedBox();
                        return buildDots(discountedSuites.length);
                      },
                    ),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: viewModel,
                        builder: (_, __) {
                          if (viewModel.moteis.isEmpty) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (viewModel.moteis.isEmpty) {
                            return Center(
                              child: Text("0 hotéis"),
                            );
                          }

                          return ListView.separated(
                            itemCount: viewModel.moteis.length,
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (context, index) {
                              final Motel motel = viewModel.moteis[index];

                              return Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(motel.bairro),
                                    Text(motel.fantasia),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmoothToggleSwitch extends StatefulWidget {
  @override
  _SmoothToggleSwitchState createState() => _SmoothToggleSwitchState();
}

class _SmoothToggleSwitchState extends State<SmoothToggleSwitch> {
  int selectedIndex = 0;

  void _selectOption(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: selectedIndex == 0 ? 0 : MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _selectOption(0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      FlutterLogo(),
                      const SizedBox(width: 1.0),
                      Text(
                        'ir agora',
                        style: TextStyle(
                          color: selectedIndex == 0 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: () => _selectOption(1),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month),
                      const SizedBox(width: 1.0),
                      Text(
                        'ir outro dia',
                        style: TextStyle(
                          color: selectedIndex == 1 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
