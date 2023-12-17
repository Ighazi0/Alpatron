import 'dart:convert';
import 'dart:io';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/screens/admin_product_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  TextEditingController search = TextEditingController();
  Iterable<ProductModel> result = {};
  bool loading = false;

  Future<void> importExcel() async {
    File? pickedFile;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      setState(() {
        loading = true;
      });
      pickedFile = File(result.files.single.path.toString());
      final input = pickedFile.openRead();
      List<List<dynamic>>? csvData = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      if (csvData.first.length == 8) {
        for (int i = 1; i < csvData.length; i++) {
          var data = csvData[i].join(', ');
          var id = DateTime.now();
          final link = await staticFunctions.generateLink(
              id.millisecondsSinceEpoch.toString(), 'product');
          try {
            await firestore
                .collection('products')
                .doc(id.millisecondsSinceEpoch.toString())
                .set({
              'id': id.millisecondsSinceEpoch.toString(),
              'timestamp': id.toIso8601String(),
              'link': link,
              'titleEn': data.split(',')[0].trim(),
              'titleAr': data.split(',')[1].trim(),
              'price': double.parse(data.split(',')[2].trim()),
              'descriptionAr': data.split(',')[3].trim(),
              'descriptionEn': data.split(',')[4].trim(),
              'stock': int.parse(data.split(',')[5].trim()),
              'media': [data.split(',')[6].trim()],
              'discount': double.parse(data.split(',')[7].trim()),
              'favorites': [],
              'category': '',
              'mainCategory': '',
              'seller': 0,
              'extra': [],
              'rate': [],
            });
            setState(() {});
          } catch (e) {
            setState(() {});
          }
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          importExcel();
        },
        mini: true,
        child: const Icon(Icons.edit_document),
      ),
      appBar: AppBarCustom(title: 'Products', loading: loading, action: {
        'title': 'add',
        'function': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminProductDetails(
                  product: ProductModel(titleEn: 'New product'),
                ),
              ));
          setState(() {});
        },
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore.collection('products').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> data = snapshot.data!.docs
                  .map((e) => ProductModel.fromJson(e.data()))
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
                    result.isEmpty
                        ? Expanded(
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
                                const Text('No data found')
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: Colors.grey,
                              ),
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                ProductModel product = result.toList()[index];
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: product.media![0],
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdminProductDetails(
                                            product: product,
                                          ),
                                        ));
                                    setState(() {});
                                  },
                                  title: Text(
                                    product.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    'AED ${product.price}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
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
