import 'dart:convert';
import 'dart:math';

import 'package:api_demo/Model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  Future<Product> getPostApi() async {
    var response = await http.get(
        Uri.parse("https://webhook.site/8b7ead6a-09f7-42d4-9185-c5df2bd34e36"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body.toString());
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Product>(
                future: getPostApi(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.data![index].title
                                        .toString()),
                                    Text(snapshot.data!.data![index].price
                                        .toString()),
                                    CircleAvatar(
                                      foregroundImage: NetworkImage(snapshot
                                          .data!.data![index].images![index].url
                                          .toString()),
                                    )
                                  ]),
                            ),
                          );
                        });
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
