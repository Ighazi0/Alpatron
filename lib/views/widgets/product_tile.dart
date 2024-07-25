import 'package:alnoor/controllers/auth_controller.dart';
import 'package:alnoor/controllers/user_controller.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:alnoor/views/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(product: widget.product),
                ));
          },
          child: Container(
            width: 190,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                SizedBox(
                  height: 125,
                  child: GridTile(
                      header: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.centerRight,
                        child: Get.find<AuthController>().userData.uid.isEmpty
                            ? InkWell(
                                onTap: () async {
                                  await userCubit
                                      .favoriteStatus(widget.product);
                                },
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              )
                            : widget.product.id.isNotEmpty
                                ? StreamBuilder(
                                    stream: firestore
                                        .collection('products')
                                        .doc(widget.product.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        ProductModel product =
                                            ProductModel.fromJson(
                                                snapshot.data!.data() as Map);
                                        return InkWell(
                                          onTap: () async {
                                            await userCubit
                                                .favoriteStatus(product);
                                          },
                                          child: Icon(
                                            product.favorites!.contains(
                                                    firebaseAuth
                                                        .currentUser?.uid)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        );
                                      }

                                      return InkWell(
                                        onTap: () async {
                                          await userCubit
                                              .favoriteStatus(widget.product);
                                        },
                                        child: Icon(
                                          widget.product.favorites!.contains(
                                                  firebaseAuth.currentUser!.uid)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      );
                                    })
                                : const SizedBox(),
                      ),
                      child: widget.product.media!.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: NImage(
                                url: widget.product.media![0],
                                h: 100,
                                w: Get.width,
                              ))
                          : const SizedBox()),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          Get.locale!.languageCode == 'ar'
                              ? widget.product.titleAr
                              : widget.product.titleEn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Row(
                      children: [
                        Text(
                          '${'AED'.tr} ${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(
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
                                        (widget.product.discount / 100)))
                                .toStringAsFixed(2),
                          ),
                      ],
                    ),
                  ),
                ),
                widget.product.stock == 0
                    ? Container()
                    : InkWell(
                        onTap: () {
                          if (userCubit.cartList
                              .containsKey(widget.product.id)) {
                            if (userCubit.cartList[widget.product.id]!.count <
                                widget.product.stock) {
                              userCubit.addToCart(widget.product, 1);
                            }
                          } else {
                            userCubit.addToCart(widget.product, 1);
                          }
                          Fluttertoast.showToast(msg: 'Added ');
                        },
                        child: const Chip(label: Text('Add to cart')),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
