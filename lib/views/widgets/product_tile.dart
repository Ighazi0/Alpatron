import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:alnoor/views/screens/splash_screen.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:alnoor/views/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
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
                        child: auth.userData.uid.isEmpty
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
                                w: dWidth,
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
                          locale.locale == 'ar'
                              ? widget.product.titleAr
                              : widget.product.titleEn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      widget.product.stock == 0
                          ? Container()
                          : InkWell(
                              onTap: () {
                                if (userCubit.cartList
                                    .containsKey(widget.product.id)) {
                                  if (userCubit
                                          .cartList[widget.product.id]!.count <
                                      widget.product.stock) {
                                    userCubit.addToCart(widget.product, 1);
                                  }
                                } else {
                                  userCubit.addToCart(widget.product, 1);
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                width: 30,
                                height: 30,
                                child: Icon(
                                  LineAwesome.cart_arrow_down_solid,
                                  color: primaryColor,
                                  size: 20,
                                ),
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
                          '${'AED'.tr(context)} ${widget.product.price.toStringAsFixed(2)}',
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
