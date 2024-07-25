import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/banner_model.dart';
import 'package:alnoor/models/category_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/category_screen.dart';
import 'package:alnoor/views/widgets/network_image.dart';
import 'package:alnoor/views/widgets/product_tile.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CarouselController controller = CarouselController();
  TextEditingController search = TextEditingController();
  List<CategoryModel> categories =
      staticData.categories.map((e) => CategoryModel.fromJson(e)).toList();
  int current = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            body: RefreshIndicator(
          color: appConstant.primaryColor,
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                        children: [
                                          Image.asset(
                                            'assets/images/empty_data.png',
                                            height: 150,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'noProducts'.tr,
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
                                              childAspectRatio: 0.7),
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
                        : Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: FutureBuilder(
                                  future: firestore.collection('banners').get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<BannerModel> data = snapshot
                                          .data!.docs
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
                                                enlargeCenterPage: true,
                                                autoPlayInterval:
                                                    const Duration(
                                                        seconds: 30)),
                                            items: data.map((i) {
                                              return Container(
                                                width: Get.width,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: NImage(
                                                    url: i.url,
                                                    h: 200,
                                                    w: Get.width,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: data
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              return GestureDetector(
                                                onTap: () => controller
                                                    .animateToPage(entry.key),
                                                child: Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: (appConstant
                                                              .primaryColor)
                                                          .withOpacity(
                                                              current ==
                                                                      entry.key
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
                                            width: Get.width,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                color: appConstant.primaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Categories',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                height: 80,
                                width: Get.width,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 15,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    CategoryModel c = categories[index];
                                    return SizedBox(
                                      width: 75,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (index == 9) {
                                            userCubit.changeIndex(1);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoryScreen(
                                                    category: c,
                                                  ),
                                                ));
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100)),
                                                border: Border.all(
                                                    width: 0.25,
                                                    color: appConstant
                                                        .primaryColor),
                                              ),
                                              child: index == 9
                                                  ? const Icon(
                                                      Icons.more_horiz_rounded)
                                                  : Image.asset(
                                                      'assets/icons/${c.id}.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            Text(
                                              index == 9
                                                  ? 'See more'
                                                  : c.titleEn,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Text(
                                  'New arrivals',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 250,
                                child: FutureBuilder(
                                  future: firestore
                                      .collection('products')
                                      .orderBy('timestamp', descending: true)
                                      .limit(50)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<ProductModel> data = snapshot
                                          .data!.docs
                                          .map((doc) =>
                                              ProductModel.fromJson(doc.data()))
                                          .toList();
                                      if (data.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                width: 15,
                                              ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return ProductTile(
                                                product: data[index]);
                                          });
                                    }
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 6,
                                        itemBuilder: (context, index) =>
                                            Shimmers(
                                                child: ProductTile(
                                                    product: ProductModel(
                                                        favorites: [],
                                                        media: []))));
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const Text(
                                  'Bestsellers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 250,
                                child: FutureBuilder(
                                  future: firestore
                                      .collection('products')
                                      .orderBy('seller')
                                      .limit(50)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<ProductModel> data = snapshot
                                          .data!.docs
                                          .map((doc) =>
                                              ProductModel.fromJson(doc.data()))
                                          .toList();
                                      if (data.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                width: 15,
                                              ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return ProductTile(
                                                product: data[index]);
                                          });
                                    }
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 6,
                                        itemBuilder: (context, index) =>
                                            Shimmers(
                                                child: ProductTile(
                                                    product: ProductModel(
                                                        favorites: [],
                                                        media: []))));
                                  },
                                ),
                              )
                            ],
                          ),
                  ]),
            ),
          ),
        ));
      },
    );
  }
}
