import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/models/banner_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/widgets/network_image.dart';
import 'package:alnoor/views/widgets/product_tile.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CarouselController controller = CarouselController();
  TextEditingController search = TextEditingController();
  int current = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            body: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoSearchTextField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    search.text.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 20),
                            child: FutureBuilder(
                              future: firestore.collection('products').get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<ProductModel> data = snapshot.data!.docs
                                      .map((doc) =>
                                          ProductModel.fromJson(doc.data()))
                                      .toList();

                                  Iterable result = data.where((element) =>
                                      element.titleEn
                                          .toLowerCase()
                                          .contains(search.text) ||
                                      element.titleAr.contains(search.text));
                                  if (result.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/empty_data.png',
                                            height: 150,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'noProducts'.tr(context),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 15,
                                              childAspectRatio: 0.65),
                                      itemCount: result.length,
                                      itemBuilder: (context, index) {
                                        ProductModel product =
                                            result.toList()[index];
                                        return ProductTile(product: product);
                                      });
                                }
                                return GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 15,
                                            mainAxisSpacing: 15,
                                            childAspectRatio: 0.65),
                                    itemCount: 6,
                                    itemBuilder: (context, index) => Shimmers(
                                        child: ProductTile(
                                            product: ProductModel(
                                                favorites: [], media: []))));
                              },
                            ),
                          )
                        : FutureBuilder(
                            future: firestore.collection('banners').get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<BannerModel> data = snapshot.data!.docs
                                    .map((doc) =>
                                        BannerModel.fromJson(doc.data()))
                                    .toList();
                                if (data.isEmpty) {
                                  return const SizedBox();
                                }
                                return Column(
                                  children: [
                                    CarouselSlider(
                                      carouselController: controller,
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          height: 200,
                                          viewportFraction: 1,
                                          autoPlayInterval:
                                              const Duration(seconds: 30)),
                                      items: data.map((i) {
                                        return Container(
                                          width: dWidth,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: NImage(
                                            url: i.url,
                                            h: 200,
                                            w: dWidth,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          data.asMap().entries.map((entry) {
                                        return GestureDetector(
                                          onTap: () => controller
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (primaryColor)
                                                    .withOpacity(
                                                        current == entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }
                              return CarouselSlider(
                                options: CarouselOptions(
                                  height: 200,
                                  enlargeCenterPage: true,
                                ),
                                items: [1, 2].map((i) {
                                  return Shimmers(
                                    child: Container(
                                      width: dWidth,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Text(
                        'best'.tr(context),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: FutureBuilder(
                        future: firestore
                            .collection('products')
                            .orderBy('seller')
                            .limit(50)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<ProductModel> data = snapshot.data!.docs
                                .map((doc) => ProductModel.fromJson(doc.data()))
                                .toList();
                            if (data.isEmpty) {
                              return const SizedBox();
                            }
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 15,
                                        childAspectRatio: 0.7),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return ProductTile(product: data[index]);
                                });
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 0.7),
                              itemCount: 6,
                              itemBuilder: (context, index) => Shimmers(
                                  child: ProductTile(
                                      product: ProductModel(
                                          favorites: [], media: []))));
                        },
                      ),
                    )
                  ]),
            ),
          ),
        ));
      },
    );
  }
}
