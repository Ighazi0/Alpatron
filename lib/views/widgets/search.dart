import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CupertinoSearchTextField(
            controller: controller,
            onChanged: (value) {
              setState(() {});
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: firestore.collection('products').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> data = snapshot.data!.docs
                      .map((e) => ProductModel.fromJson(e.data()))
                      .toList();
                  Iterable result = data.where((element) =>
                      element.titleEn
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()) ||
                      element.titleAr
                          .toLowerCase()
                          .contains(controller.text.toLowerCase()));
                  return result.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_pro.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('noProducts'.tr)
                          ],
                        )
                      : RefreshIndicator(
                          color: appConstant.primaryColor,
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              height: 0,
                            ),
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              ProductModel product = result.toList()[index];
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetails(product: product),
                                        ));
                                  },
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: product.media![0],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    product.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        'AED ${product.price}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration: product.discount == 0
                                                ? null
                                                : TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      if (product.discount != 0)
                                        Text(
                                          (product.price -
                                                  (product.price *
                                                      (product.discount / 100)))
                                              .toStringAsFixed(2),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                    ],
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
          )
        ],
      ),
    );
  }
}
