import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool favorite = false;
  CarouselController controller = CarouselController();
  int current = 0, count = 1;

  @override
  void initState() {
    favorite =
        widget.product.favorites!.contains(firebaseAuth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            bottomNavigationBar: widget.product.stock == 0
                ? SafeArea(
                    child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      'out'.tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: appConstant.primaryColor),
                    ),
                  ))
                : null,
            appBar: const AppBarCustom(action: {}),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Column(
                        children: [
                          CarouselSlider(
                            carouselController: controller,
                            options: CarouselOptions(
                                autoPlay: true,
                                height: 200,
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                autoPlayInterval: const Duration(seconds: 20)),
                            items: widget.product.media!.map((i) {
                              return Container(
                                width: Get.width,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: NImage(
                                    url: i,
                                    h: 200,
                                    w: Get.width,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.product.media!
                                .asMap()
                                .entries
                                .map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    controller.animateToPage(entry.key),
                                child: Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (appConstant.primaryColor)
                                          .withOpacity(current == entry.key
                                              ? 0.9
                                              : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        child: StreamBuilder(
                            stream: firestore
                                .collection('products')
                                .doc(widget.product.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                ProductModel product = ProductModel.fromJson(
                                    snapshot.data!.data() as Map);
                                return IconButton(
                                  icon: Icon(
                                    product.favorites!.contains(
                                            firebaseAuth.currentUser!.uid)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  onPressed: () async {
                                    await userCubit.favoriteStatus(product);
                                  },
                                );
                              }

                              return IconButton(
                                icon: Icon(
                                  widget.product.favorites!.contains(
                                          firebaseAuth.currentUser!.uid)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  await userCubit
                                      .favoriteStatus(widget.product);
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Get.locale!.languageCode == 'ar'
                                ? widget.product.titleAr
                                : widget.product.titleEn,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${'AED'.tr} ${widget.product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        decoration: widget.product.discount == 0
                                            ? null
                                            : TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (widget.product.discount != 0)
                                    Text(
                                      (widget.product.price -
                                              (widget.product.price *
                                                  (widget.product.discount /
                                                      100)))
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                              const Spacer(),
                              widget.product.stock == 0
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () {
                                        userCubit.addToCart(
                                            widget.product, count);
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.add_shopping_cart,
                                        color: appConstant.primaryColor,
                                      )),
                              IconButton(
                                  onPressed: () {
                                    staticFunctions
                                        .shareData(widget.product.link);
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: appConstant.primaryColor,
                                  ))
                            ],
                          ),
                          if (widget.product.descriptionEn.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                'description'.tr,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (widget.product.descriptionEn.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: appConstant.primaryColor),
                                  ),
                                  const Divider(),
                                  Text(
                                    widget.product.descriptionEn,
                                  ),
                                ],
                              ),
                            )
                        ]),
                  )
                ],
              ),
            ));
      },
    );
  }
}
