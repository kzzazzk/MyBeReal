import 'dart:typed_data';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class FullSizeImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullSizeImageScreen({super.key, required this.imageUrl});

  saveNetworkImage() async {
    var response = await Dio().get(
        "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //// change your color here
          ),
          centerTitle: true,
          toolbarHeight: 75,
          elevation: 1,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Imagen',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'San Francisco',
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        body: Center(
          child: Stack(
            children: [
              AnimateGradient(
                primaryColors: const [
                  Color(0xFF96d4ca),
                  Color(0xFF7c65a9),
                ],
                secondaryColors: const [
                  Color(0xFF7c65a9),
                  Color(0XFFf5ccd4),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain, // Adjust the fit as needed
                    ),
                  ),
                  const SizedBox(height: 20), // Add some spacing
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        //saveNetworkImage()
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Guardar',
                          style: TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
