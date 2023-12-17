import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/category_model.dart';
import 'package:alnoor/views/screens/category_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminCategories extends StatefulWidget {
  const AdminCategories({super.key, required this.category});
  final CategoryModel category;

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  TextEditingController search = TextEditingController();
  Iterable<CategoryModel> result = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: widget.category.titleEn, action: {
        'title': 'add',
        'function': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetails(
                  category: CategoryModel(titleEn: 'New Category'),
                  catId: widget.category.id,
                ),
              ));
          setState(() {});
        }
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: widget.category.id.isEmpty
              ? firestore.collection('categories').get()
              : firestore
                  .collection('categories')
                  .doc(widget.category.id)
                  .collection('categories')
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CategoryModel> data = snapshot.data!.docs
                  .map((e) => CategoryModel.fromJson(e.data()))
                  .toList();
              result = data.where((a) =>
                  a.titleEn.toLowerCase().contains(search.text.toLowerCase()) ||
                  a.titleAr.toLowerCase().contains(search.text.toLowerCase()));
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: result.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty_data.png',
                                  height: 150,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text('No data found')
                              ],
                            )
                          : ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                CategoryModel category = result.toList()[index];
                                return Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: ListTile(
                                    leading: widget.category.id.isEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl: category.url,
                                              width: 75,
                                              height: 75,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : null,
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryDetails(
                                              category: category,
                                              catId: widget.category.id,
                                            ),
                                          ));
                                      setState(() {});
                                    },
                                    title: Text(
                                      category.titleEn,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
