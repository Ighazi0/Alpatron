import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/category_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/sub_category_screen.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/product_tile.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';

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
            FutureBuilder(
              future: firestore
                  .collection('categories')
                  .doc(widget.category.id)
                  .collection('categories')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CategoryModel> data = snapshot.data!.docs
                      .map((doc) => CategoryModel.fromJson(doc.data()))
                      .toList();
                  if (data.isEmpty) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: 40,
                    width: dWidth,
                    child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          CategoryModel category = data[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategoryScreen(
                                        category: category,
                                      ),
                                    ));
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Chip(
                                    label: Text(category.titleEn),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  )));
                        }),
                  );
                }
                return SizedBox(
                  height: 40,
                  width: dWidth,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Shimmers(
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Chip(
                              label: Container(
                                margin: const EdgeInsets.only(top: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 20,
                                width: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ))),
                  ),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: FutureBuilder(
                  future: firestore
                      .collection('products')
                      .where('mainCategory', isEqualTo: widget.category.id)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ProductModel> data = snapshot.data!.docs
                          .map((doc) => ProductModel.fromJson(doc.data()))
                          .toList();
                      if (data.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/empty_pro.png'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'noProducts'.tr(context),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
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
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.7),
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
