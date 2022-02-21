import 'dart:convert';

import 'package:aesthetic_dialogs/aesthetic_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_gif_api/consts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Gif',
      theme: ThemeData.dark(),
      home: const HomeGif(),
    );
  }
}

class HomeGif extends StatefulWidget {
  const HomeGif({Key? key}) : super(key: key);

  @override
  _HomeGifState createState() => _HomeGifState();
}

class _HomeGifState extends State<HomeGif> {
  String? query;
  TextEditingController myController = TextEditingController();
  List gifs = List.filled(8, "Null");

  void getGif() async {
    try {
      var response = await http.get(Uri.parse(
          "https://g.tenor.com/v1/search?q=${query}&key=LIVDSRZULELA&limit=8"));

      setState(() {
        for (int i = 0; i < 8; i++) {
          gifs[i] = jsonDecode(response.body)['results'][i]['media'][0]
              ['mediumgif']['url'];
        }
        // print(gifs);
        // print(query);
      });
    } catch (e) {
      // print("hata oluştu $e");
      AestheticDialogs.showDialog(
          title: "Hata",
          message: "Bir Hata Oluştu Hata Kodu: $e",
          cancelable: true,
          darkMode: true,
          dialogAnimation: DialogAnimation.IN_OUT,
          dialogGravity: DialogGravity.CENTER,
          dialogStyle: DialogStyle.EMOJI,
          dialogType: DialogType.INFO,
          duration: 5000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Gif"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: myController,
            decoration: InputDecoration(
                labelText: "Aramak istediğiniz gifi girin",
                border: myinputborder()),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              myController.text == "nil"
                  ? query = "love"
                  : query = myController.text;
            });

            getGif();
          },
          child: const Text(
            "Gif Ara",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
        ),
        Flexible(
            child: query == null
                ? const SpinKitSpinningLines(color: Colors.white60)
                : ListView.separated(
                    itemCount: gifs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return buildImageGif(index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 10,
                      );
                    },
                  ))
      ]),
    );
  }

  Image buildImageGif(int n) {
    return Image.network(
      gifs[n],
      fit: BoxFit.cover,
    );
  }
}
