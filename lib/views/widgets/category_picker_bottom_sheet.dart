import 'package:alnoor/controllers/my_app.dart';
import 'package:alnoor/models/category_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryPickerBottomSheet extends StatefulWidget {
  const CategoryPickerBottomSheet(
      {super.key, required this.list, this.id = '', required this.function});
  final String id;
  final Function function;
  final List<CategoryModel> list;

  @override
  State<CategoryPickerBottomSheet> createState() =>
      _CategoryPickerBottomSheetState();
}

class _CategoryPickerBottomSheetState extends State<CategoryPickerBottomSheet> {
  TextEditingController controller = TextEditingController();
  Iterable<CategoryModel> result = [];

  @override
  void initState() {
    result = widget.list.where((element) =>
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
              ? const Icon(Icons.search_off)
              : Flexible(
                  child: ListView.builder(
                  itemCount: result.length,
                  controller: staticWidgets.scrollController,
                  itemBuilder: (context, index) {
                    CategoryModel category = result.toList()[index];
                    return ListTile(
                      title: Text(category.titleEn),
                      onTap: () {
                        widget.function('${category.titleEn}%${category.id}');
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
