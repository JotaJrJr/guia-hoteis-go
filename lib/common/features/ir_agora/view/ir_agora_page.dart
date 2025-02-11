import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/data/remote/api/hotel_api_service.dart';
import 'package:guia_hoteis_processo/common/data/remote/repositories/hotel_repository_impl.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/viewmodel/ir_agora_view_model.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/widgets/motel_desconto_widget.dart';

import '../widgets/ir_agora_app_bar.dart';
import '../widgets/motel_widget.dart';

class IrAgoraPage extends StatefulWidget {
  final IrAgoraViewModel? viewModel;

  const IrAgoraPage({super.key, this.viewModel});

  @override
  State<IrAgoraPage> createState() => _IrAgoraPageState();
}

class _IrAgoraPageState extends State<IrAgoraPage> {
  late IrAgoraViewModel viewModel;
  late MotelRepository _repository;
  final HotelApiService _hotelApiService = HotelApiService();

  @override
  void initState() {
    super.initState();

    _repository = MotelRepositoryImpl(_hotelApiService);
    viewModel = widget.viewModel ?? IrAgoraViewModel(_repository);
    viewModel.getMoteis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              IrAgoraAppBar(),
              const SizedBox(height: 12.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                  color: Colors.grey[300],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: SizedBox(
                        height: 150,
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
                              controller: viewModel.pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: discountedSuites.length,
                              itemBuilder: (context, index) {
                                final DiscountedSuiteItem item = discountedSuites[index];

                                return MotelDescontoWidget(
                                  item: item,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: ListenableBuilder(
                        listenable: Listenable.merge([viewModel, viewModel.pageController]),
                        builder: (_, __) {
                          final List<DiscountedSuiteItem> discountedSuites = viewModel.discountedSuites;
                          if (discountedSuites.isEmpty) return const SizedBox();
                          return buildDots(discountedSuites.length);
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              Container(),
              AnimatedBuilder(
                animation: viewModel,
                builder: (context, child) {
                  if (viewModel.moteis.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (viewModel.moteis.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.info, size: 120),
                          Text("Houve algume erro na busca..."),
                        ],
                      ),
                    );
                  }

                  return Container(
                    color: Colors.grey[200],
                    height: 1200,
                    child: ListView.separated(
                      itemCount: viewModel.moteis.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        final Motel motel = viewModel.moteis[index];

                        return MotelWidget(
                          model: motel,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDots(int count) {
    final double currentPage;
    if (viewModel.pageController.positions.isEmpty) {
      currentPage = 0;
    } else {
      currentPage = viewModel.pageController.page ?? 0;
    }
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
}
