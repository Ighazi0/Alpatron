import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/models/cart_model.dart';
import 'package:alnoor/views/screens/user_screen.dart';
import 'package:alnoor/views/widgets/counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetRemoveCart extends StatefulWidget {
  const BottomSheetRemoveCart({super.key, this.index = 0});
  final int index;

  @override
  State<BottomSheetRemoveCart> createState() => _BottomSheetRemoveCartState();
}

class _BottomSheetRemoveCartState extends State<BottomSheetRemoveCart> {
  CartModel cart = CartModel();

  @override
  void initState() {
    cart = userCubit.cartList.values.toList()[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ListView(
          controller: staticWidgets.scrollController,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Remove from cart?',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: cart.productData!.media![0],
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  cart.productData!.titleEn,
                  overflow: TextOverflow.ellipsis,
                ),
                visualDensity: const VisualDensity(vertical: 4),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AED ${cart.productData!.price}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    Counter(
                      remove: () {
                        userCubit.addToCart(cart.productData!, -1);
                        cart = userCubit.cartList.values.toList()[widget.index];
                      },
                      add: () {
                        userCubit.addToCart(cart.productData!, 1);
                        cart = userCubit.cartList.values.toList()[widget.index];
                      },
                      other: () {
                        Navigator.pop(context);
                        userCubit.removeFromCart(cart.productData!.id);
                      },
                      count: cart.count,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  minWidth: 100,
                  height: 40,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  color: Colors.grey.shade400,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  minWidth: 100,
                  height: 40,
                  onPressed: () async {
                    userCubit.removeFromCart(cart.productData!.id);
                    Navigator.pop(context);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  color: primaryColor,
                  child: const Text(
                    'Remove',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
