import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/review_model.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminReviews extends StatefulWidget {
  const AdminReviews({super.key});

  @override
  State<AdminReviews> createState() => _AdminReviewsState();
}

class _AdminReviewsState extends State<AdminReviews> {
  int filterx = 0;
  var rating = 0;
  TextEditingController controller = TextEditingController();

  filter(x) {
    setState(() {
      filterx = x;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'reviews',
        action: {
          'title': 'filter',
          'function': () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Options'),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          filter(0);
                        },
                        child: Text(
                          'All',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter(5);
                        },
                        child: Text(
                          '5 stars',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter(4);
                        },
                        child: Text(
                          '4 stars',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter(3);
                        },
                        child: Text(
                          '3 stars',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter(2);
                        },
                        child: Text(
                          '2 stars',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filter(1);
                        },
                        child: Text(
                          '1 stars',
                          style: TextStyle(color: appConstant.primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      body: RefreshIndicator(
          color: appConstant.primaryColor,
          onRefresh: () async {
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: firestore
                  .collection('reviews')
                  .orderBy('timestamp', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ReviewModel> data = snapshot.data!.docs
                      .map((e) => ReviewModel.fromJson(e.data()))
                      .toList();
                  if (data.isNotEmpty) {
                    rating = (data
                                .map((value) => value.rate)
                                .reduce((a, b) => a + b) /
                            data.length)
                        .round();
                  }

                  Iterable<ReviewModel> result = filterx == 0
                      ? data
                      : data.where((element) => (element.rate >= filterx &&
                          element.rate < (filterx + 1)));

                  return Column(
                    children: [
                      SizedBox(
                        height: 115,
                        width: Get.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StarRating(
                              rate: rating,
                              size: 30,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '(${data.length} Reviews)',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: result.isEmpty
                            ? Center(
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
                            : ListView.builder(
                                itemCount: result.length,
                                itemBuilder: (context, index) {
                                  ReviewModel review = data[index];

                                  return Card(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Text(
                                              review.name,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              review.message,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            StarRating(
                                              rate: review.rate.toInt(),
                                            )
                                          ],
                                        ),
                                      ));
                                },
                              ),
                      ),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
    );
  }
}
