import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/cubit/user_cubit.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/widgets/product_tile.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                future: firestore.collection('products').where('favorites',
                    arrayContainsAny: [
                      firebaseAuth.currentUser?.uid ?? ''
                    ]).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ProductModel> data = snapshot.data!.docs
                        .map((doc) => ProductModel.fromJson(doc.data()))
                        .toList();
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_fav.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'noFavorites'.tr(context),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.7),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          ProductModel product = data[index];
                          return ProductTile(product: product);
                        });
                  }
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) => Shimmers(
                          child: ProductTile(
                              product:
                                  ProductModel(favorites: [], media: []))));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
