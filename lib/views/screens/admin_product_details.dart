import 'dart:io';
import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/category_model.dart';
import 'package:alnoor/models/product_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/category_picker_bottom_sheet.dart';
import 'package:alnoor/views/widgets/edit_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_pickers/image_pickers.dart';

class AdminProductDetails extends StatefulWidget {
  const AdminProductDetails({super.key, required this.product});
  final ProductModel product;

  @override
  State<AdminProductDetails> createState() => _AdminProductDetailsState();
}

class _AdminProductDetailsState extends State<AdminProductDetails> {
  bool loading = false;
  GlobalKey<FormState> key = GlobalKey();
  List<CategoryModel> categories =
      staticData.categories.map((e) => CategoryModel.fromJson(e)).toList();
  List url = [], selectedImages = [];
  String cat = '';
  TextEditingController tar = TextEditingController(),
      ten = TextEditingController(),
      dar = TextEditingController(),
      den = TextEditingController(),
      stock = TextEditingController(),
      discount = TextEditingController(text: '0'),
      price = TextEditingController();

  submit() async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    var id = DateTime.now();

    for (var e in selectedImages) {
      if (!e.toString().startsWith('http')) {
        var id2 = DateTime.now().millisecondsSinceEpoch.toString();
        final ref = await firebaseStorage.ref('products/$id2').putFile(File(e));

        url.add(await ref.ref.getDownloadURL());
      }
    }

    if (widget.product.id.isEmpty) {
      await firestore
          .collection('products')
          .doc(id.millisecondsSinceEpoch.toString())
          .set({
        'id': id,
        'timestamp': id,
        'titleAr': tar.text,
        'titleEn': ten.text,
        'descriptionAr': dar.text,
        'descriptionEn': den.text,
        'favorites': [],
        'category': cat,
        'seller': 0,
        'media': url,
        'extra': [],
        'rate': [],
        'price': double.parse(price.text),
        'discount': double.parse(discount.text),
        'stock': int.parse(stock.text)
      });
    } else {
      await firestore.collection('products').doc(widget.product.id).update({
        'titleAr': tar.text,
        'titleEn': ten.text,
        'descriptionAr': dar.text,
        'descriptionEn': den.text,
        'media': url,
        'category': cat,
        'price': double.parse(price.text),
        'discount': double.parse(discount.text),
        'stock': int.parse(stock.text),
      });
    }

    Get.back();
  }

  _openPicker() async {
    List<Media> listImagePaths = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
      showGif: false,
      showCamera: true,
      selectCount: 5 - selectedImages.length,
      uiConfig: UIConfig(uiThemeColor: appConstant.primaryColor),
    );

    for (var element in listImagePaths) {
      setState(() {
        selectedImages.add(element.path.toString());
      });
    }
  }

  @override
  void initState() {
    if (widget.product.id.isNotEmpty) {
      for (var e in widget.product.media!) {
        selectedImages.add(e);
        url.add(e);
      }

      tar.text = widget.product.titleAr;
      ten.text = widget.product.titleEn;
      dar.text = widget.product.descriptionAr;
      den.text = widget.product.descriptionEn;
      discount.text = widget.product.discount.toStringAsFixed(2);
      price.text = widget.product.price.toStringAsFixed(2);
      stock.text = widget.product.stock.toString();
      cat = widget.product.category;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
          title: widget.product.titleEn,
          loading: loading,
          action: {
            'title': widget.product.id.isEmpty ? 'add' : 'update',
            'function': submit
          }),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: key,
            child: ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: selectedImages.length == 5
                      ? selectedImages.length
                      : selectedImages.length + 1,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    String imageFile = index != selectedImages.length
                        ? selectedImages[index].toString()
                        : '';

                    return GestureDetector(
                      onTap: () {
                        _openPicker();
                      },
                      child: index == selectedImages.length
                          ? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: const Icon(Icons.add))
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: imageFile.startsWith('https')
                                      ? CachedNetworkImage(
                                          imageUrl: imageFile,
                                          height: 125,
                                          width: 125,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(imageFile),
                                          height: 125,
                                          width: 125,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                      if (imageFile.startsWith('https')) {
                                        url.removeAt(index);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: ten,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product title in English';
                      }
                      return null;
                    },
                    hint: 'Iphone',
                    title: 'titleEn'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: tar,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product title in Arabic';
                      }
                      return null;
                    },
                    hint: 'ايفون',
                    title: 'titleAr'),
                const Padding(
                  padding: EdgeInsets.only(left: 5, top: 20),
                  child: Text('Category'),
                ),
                GestureDetector(
                  onTap: () {
                    staticWidgets.showBottom(context,
                        CategoryPickerBottomSheet(function: (c) {
                      setState(() {
                        cat = c;
                      });
                    }), 0.5, 0.9);
                  },
                  child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(
                        categories.where((element) => element.id == cat).isEmpty
                            ? ''
                            : categories
                                .where((element) => element.id == cat)
                                .first
                                .titleEn),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: den,
                    validator: (p0) {
                      return null;
                    },
                    hint: 'storage 64',
                    title: 'descriptionEn'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: dar,
                    validator: (p0) {
                      return null;
                    },
                    hint: 'مساحة ٦٤',
                    title: 'descriptionAr'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: price,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product price';
                      }
                      return null;
                    },
                    hint: '100',
                    number: true,
                    title: 'price'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: discount,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product discount percent';
                      }
                      return null;
                    },
                    hint: '50',
                    number: true,
                    title: 'discountP'),
                const SizedBox(
                  height: 20,
                ),
                EditText(
                    function: () {},
                    controller: stock,
                    number: true,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter product stock';
                      }
                      return null;
                    },
                    hint: '5',
                    title: 'stock'),
                if (widget.product.id.isNotEmpty && !loading)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: IconButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await firestore
                                .collection('products')
                                .doc(widget.product.id)
                                .delete();
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
