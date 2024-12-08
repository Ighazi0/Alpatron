import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/category_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryPickerBottomSheet extends StatefulWidget {
  const CategoryPickerBottomSheet(
      {super.key, this.id = '', required this.function});
  final String id;
  final Function function;

  @override
  State<CategoryPickerBottomSheet> createState() =>
      _CategoryPickerBottomSheetState();
}

class _CategoryPickerBottomSheetState extends State<CategoryPickerBottomSheet> {
  TextEditingController controller = TextEditingController();
  Iterable<CategoryModel> result = [];
  List<CategoryModel> categories =
      staticData.categories.map((e) => CategoryModel.fromJson(e)).toList();

  @override
  void initState() {
    result = categories.where((element) =>
        element.titleEn.toLowerCase().contains(controller.text.toLowerCase()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Main Categories',
              style: TextStyle(fontSize: 25),
            ),
          ),
          CupertinoSearchTextField(
            controller: controller,
            onChanged: (value) {
              setState(() {});
            },
          ),
          result.isEmpty
              ? Builder(builder: (context) {
                  return const Expanded(child: Icon(Icons.search_off));
                })
              : Flexible(
                  child: ListView.builder(
                  itemCount: result.length,
                  controller: staticWidgets.scrollController,
                  itemBuilder: (context, index) {
                    CategoryModel category = result.toList()[index];
                    return ListTile(
                      title: Text(category.titleEn),
                      onTap: () {
                        widget.function(category.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                ))
        ],
      ),
    );
  }
}
