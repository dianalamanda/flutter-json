import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder(
            future: ReadJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text("${data.error}"));
              } else if (data.hasData) {
                var items = data.data as List<MerchantModel>;
                return ListView.builder(
                    itemCount: items == null ? 0 : items.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 5,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: Image(
                                      image: NetworkImage(
                                          items[index].image.toString()),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                items[index].name.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                  '${items[index].long.toString()} ${items[index].lat.toString()}'),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              )));
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class MerchantModel {
  int? id;
  String? name;
  String? address;
  double? long;
  double? lat;
  String? image;

  MerchantModel(
      {this.id, this.name, this.address, this.long, this.lat, this.image});

  MerchantModel.fromJson(Map<String, dynamic> json) {
    id = json['merchantId'];
    name = json['merchantName'];
    address = json['merchantAddress'];
    long = double.parse(json['long']);
    lat = double.parse(json['lat']);
    image = json['image'];
  }
}

Future<List<MerchantModel>> ReadJsonData() async {
  final jsondata = await rootBundle.loadString('data/merchant.json');
  final List<dynamic> list = json.decode(jsondata) as List<dynamic>;
  return list.map((e) => MerchantModel.fromJson(e)).toList();
}
