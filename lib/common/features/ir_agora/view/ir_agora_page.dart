import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/data/remote/api/hotel_api_service.dart';
import 'package:guia_hoteis_processo/common/data/remote/repositories/hotel_repository_impl.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/viewmodel/ir_agora_view_model.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/widgets/motel_desconto_widget.dart';

import '../widgets/image_network_widget.dart';
import '../widgets/motel_widget.dart';
import '../widgets/smooth_toggle_switch_widget.dart';

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

  final List<Widget> widgetList = [
    /// PRIMEIRO WIDGET
    Row(
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
    ),

    /// SEGUNDO WIDGET
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

                        final double originalPrice = item.suite.periodos.first.valor;
                        final double discountValue = item.suite.periodos.first.desconto?.desconto ?? 0.0;

                        final double discountPercentage = originalPrice > 0 ? (discountValue / originalPrice) * 100 : 0.0;
                        final double discountedPrice = originalPrice - discountValue;

                        return MotelDescontoWidget(item: item, discountPercentage: discountPercentage, discountedPrice: discountedPrice);
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

                  return Expanded(
                    child: ListView.separated(
                      itemCount: viewModel.moteis.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        final Motel motel = viewModel.moteis[index];

                        return SizedBox(
                          height: 200,
                          child: MotelWidget(
                            model: motel,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  ];

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
            Row(
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
            ),
            SizedBox(
              height: 12.0,
            ),
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

                                final double originalPrice = item.suite.periodos.first.valor;
                                final double discountValue = item.suite.periodos.first.desconto?.desconto ?? 0.0;

                                final double discountPercentage = originalPrice > 0 ? (discountValue / originalPrice) * 100 : 0.0;
                                final double discountedPrice = originalPrice - discountValue;

                                return MotelDescontoWidget(item: item, discountPercentage: discountPercentage, discountedPrice: discountedPrice);
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

                          return Expanded(
                            child: ListView.separated(
                              itemCount: viewModel.moteis.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (context, index) {
                                final Motel motel = viewModel.moteis[index];

                                return SizedBox(
                                  height: 200,
                                  child: MotelWidget(
                                    model: motel,
                                  ),
                                );
                              },
                            ),
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
