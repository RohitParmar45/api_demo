import 'dart:convert';
import 'dart:math';

import 'package:api_demo/Model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key});

  List<Model> postList = [];
  Future<List<Model>> getPostApi() async {
    var response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body.toString());

      for (Map<String, dynamic> i in data) {
        postList.add(Model.fromJson(i));
      }
      return postList;
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
              child: FutureBuilder(
                future: getPostApi(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  } else {
                    return ListView.builder(
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(postList[index].userId.toString()),
                                    Text(postList[index].title.toString())
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
