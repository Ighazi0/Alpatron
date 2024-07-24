import 'package:alnoor/get_initial.dart';
import 'package:alnoor/models/banner_model.dart';
import 'package:alnoor/views/screens/banner_details.dart';
import 'package:alnoor/views/widgets/app_bar.dart';
import 'package:alnoor/views/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBanners extends StatefulWidget {
  const AdminBanners({super.key});

  @override
  State<AdminBanners> createState() => _AdminBannersState();
}

class _AdminBannersState extends State<AdminBanners> {
  TextEditingController search = TextEditingController();
  Iterable<BannerModel> result = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Banners',
        action: {
          'title': 'add',
          'function': () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BannnerDetails(
                    banner: BannerModel(titleEn: 'New banner'),
                  ),
                ));
            setState(() {});
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore.collection('banners').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BannerModel> data = snapshot.data!.docs
                  .map((e) => BannerModel.fromJson(e.data()))
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
                                BannerModel banner = result.toList()[index];
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BannnerDetails(
                                            banner: banner,
                                          ),
                                        ));
                                    setState(() {});
                                  },
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 200,
                                          width: Get.width,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: CachedNetworkImage(
                                              imageUrl: banner.url,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Shimmers(
                                                      child: Container(
                                                height: 175,
                                                width: Get.width,
                                                color: Colors.orangeAccent,
                                              )),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            banner.titleEn,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        )
                                      ],
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
