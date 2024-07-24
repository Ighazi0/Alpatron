import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/category_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/product_tile.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.category.titleEn,
        action: const {},
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: FutureBuilder(
                  future: firestore
                      .collection('products')
                      .where('category', isEqualTo: widget.category.id)
                      .get(),
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
                              Image.asset('assets/images/empty_pro.png'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'noProducts'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
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
                                  childAspectRatio: 0.75),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            ProductModel product = data[index];
                            return ProductTile(product: product);
                          });
                    }
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.75),
                        itemCount: 6,
                        itemBuilder: (context, index) => Shimmers(
                            child: ProductTile(
                                product:
                                    ProductModel(favorites: [], media: []))));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
