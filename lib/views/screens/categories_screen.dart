import 'package:alnoor/controllers/app_localization.dart';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/category_model.dart';
import 'package:alnoor/views/screens/category_screen.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(
        action: const {},
        title: 'categories'.tr(context),
      ),
      body: FutureBuilder(
        future: firestore.collection('categories').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CategoryModel> data = snapshot.data!.docs
                .map((doc) => CategoryModel.fromJson(doc.data()))
                .toList();
            if (data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_data.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('noData'.tr(context))
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.1),
                itemBuilder: (context, index) {
                  CategoryModel category = data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                              category: category,
                            ),
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 75,
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                child: CachedNetworkImage(
                                  imageUrl: category.url,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 20,
                              child: Text(
                                category.titleEn,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
