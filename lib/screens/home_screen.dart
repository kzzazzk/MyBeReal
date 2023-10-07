import 'dart:io';
import 'dart:ui' as ui;

import 'package:animate_gradient/animate_gradient.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_be_real/utils/constants.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageViewController = PageController();
  int _selectedIndex = 0;
  bool hideLabels1 = true;
  bool hideLabels2 = false;
  Color selectedColor = Colors.white;
  double padding1 = 0;
  double padding2 = 20;
  bool isLoading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      hideLabels1 = index == 0;
      hideLabels2 = index == 1;
      padding1 = index == 0 ? 0 : 20;
      padding2 = index == 1 ? 0 : 20;
      _pageViewController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  Widget buildUserFotoGrid(int index) {
    return StreamBuilder(
      stream: index == 0
          ? FirebaseFirestore.instance
              .collection('fotos')
              .where('user_id', isEqualTo: Constants.authUserEmail)
              .orderBy('timestamp', descending: false)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('fotos')
              .where('user_id', isEqualTo: Constants.otherUserEmail)
              .orderBy('timestamp', descending: false)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.transparent,
            ),
          );
        }

        final fotos = snapshot.data?.docs;

        // Create a Map to organize photos by month
        Map<String, List<QueryDocumentSnapshot>> photosByMonth = {};

        // Iterate through the photos and group them by month
        for (var foto in fotos!) {
          DateTime timestamp = foto['timestamp'].toDate();
          String monthKey = '${timestamp.year}-${timestamp.month}';

          if (!photosByMonth.containsKey(monthKey)) {
            photosByMonth[monthKey] = [];
          }

          photosByMonth[monthKey]!.add(foto);
        }

        // Create a sorted list of month keys
        List<String> sortedMonthKeys = photosByMonth.keys.toList();
        sortedMonthKeys.sort(
          (a, b) => b.compareTo(a),
        );

        return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ListView.builder(
              itemCount: sortedMonthKeys.length,
              itemBuilder: (context, index) {
                String monthKey = sortedMonthKeys[index];
                List<QueryDocumentSnapshot<Object?>>? monthPhotos =
                    photosByMonth[monthKey];

                DateTime displayDate = DateTime.parse('$monthKey-01');

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlurryContainer(
                    blur: 2,
                    elevation: 0,
                    color: Colors.black45,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            DateFormat('MMMM yyyy').format(displayDate),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                4, // Adjust the number of columns as needed
                          ),
                          itemCount: monthPhotos?.length,
                          itemBuilder: (context, index) {
                            // Build your photo grid items here
                            // You can access individual photos with monthPhotos[index]

                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: GestureDetector(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        monthPhotos?[index].get('url'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'MyBeReal.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 17, bottom: 5),
            child: Container(
              width: 45, // Adjust the width to make the circle smaller
              height: 45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black, // Set the background color here
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ), // You can use any icon you prefer
                onPressed: () {
                  FirebaseAuth.instance.signOut();

                  Get.offNamed('/login');
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Your background gradient
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
          // PageView and CurvedNavigationBar
          Stack(
            children: [
              // PageView for tab content
              PageView(
                controller: _pageViewController,
                onPageChanged: _onItemTapped,
                children: [
                  buildUserFotoGrid(0),
                  buildUserFotoGrid(1),
                ],
              ),
              // CurvedNavigationBar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CurvedNavigationBar(
                  color: Colors.black,
                  backgroundColor: const Color(0x00000000),
                  buttonBackgroundColor: Colors.black,
                  items: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: padding1),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: selectedColor,
                          ),
                        ),
                        Visibility(
                          visible: !hideLabels1,
                          child: Text(
                            'Enviados por mí',
                            style: TextStyle(
                              color: selectedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: padding2),
                          child: Icon(
                            Icons.people,
                            size: 30,
                            color: selectedColor,
                          ),
                        ),
                        Visibility(
                          visible: !hideLabels2,
                          child: Text(
                            'Enviados por mi pareja',
                            style: TextStyle(
                              color: selectedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  index: _selectedIndex,
                  onTap: _onItemTapped,
                  animationDuration: const Duration(milliseconds: 200),
                  animationCurve: Curves.easeInOut,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: ExpandableFab(
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            fabSize: ExpandableFabSize.regular,
            backgroundColor: Colors.black,
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            shape: const CircleBorder(),
            child: const Icon(
              Icons.close,
              size: 25,
              color: Colors.white,
            ),
            fabSize: ExpandableFabSize.regular,
            backgroundColor: Colors.black,
          ),
          distance: 70,
          type: ExpandableFabType.up,
          overlayStyle: ExpandableFabOverlayStyle(
            blur: 2,
          ),
          children: [
            FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.black,
                heroTag: null,
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  final data = await image?.readAsBytes();
                  final codec = await ui.instantiateImageCodec(data!);
                  final info = await codec.getNextFrame();

                  // Get the image width and height
                  final imageWidth = info.image.width.toDouble();
                  final imageHeight = info.image.height.toDouble();

                  if (mounted && image != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          surfaceTintColor: Colors.transparent,
                          backgroundColor: Colors.black87,
                          title: const Text(
                            'Confirmar envío',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Make the column size as small as possible
                            children: [
                              const Text(
                                '¿Estás seguro de que quieres subir esta foto?',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: imageWidth,
                                height: imageHeight,
                                child: FittedBox(
                                  fit: BoxFit
                                      .contain, // Adjust the fit as needed
                                  child: Image.file(
                                    File(image.path),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                String uniqueFileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                var now = DateTime.now();
                                var formatter = DateFormat('MMMM');
                                var monthName = formatter.format(now);
                                final storage = FirebaseStorage.instance;
                                final ref = storage
                                    .ref()
                                    .child('$monthName/$uniqueFileName');
                                final task =
                                    await ref.putFile(File(image.path));

                                if (task.state == TaskState.success) {
                                  final downloadUrl =
                                      await ref.getDownloadURL();

                                  // Guardar la URL de la imagen en Firestore
                                  FirebaseFirestore.instance
                                      .collection('fotos')
                                      .add({
                                    'url': downloadUrl,
                                    'timestamp': FieldValue.serverTimestamp(),
                                    'user_id': Constants.authUserEmail,
                                  });

                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Imagen subida con éxito.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Aceptar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  // upload the image to Firebase Storage
                }),
            FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.black,
                heroTag: null,
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  final data = await image?.readAsBytes();
                  final codec = await ui.instantiateImageCodec(data!);
                  final info = await codec.getNextFrame();
                  final imageWidth = info.image.width.toDouble();
                  final imageHeight = info.image.height.toDouble();
                  if (mounted && image != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmar'),
                          content: Column(
                            children: [
                              const Text(
                                  '¿Estás seguro de que quieres subir esta foto?'),
                              Image.file(
                                File(image.path),
                                height: imageHeight,
                                width: imageWidth,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String uniqueFileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                var now = DateTime.now();
                                var formatter = DateFormat('MMMM');
                                var monthName = formatter.format(now);
                                final storage = FirebaseStorage.instance;
                                final ref = storage
                                    .ref()
                                    .child('$monthName/$uniqueFileName');
                                final task =
                                    await ref.putFile(File(image.path));

                                if (task.state == TaskState.success) {
                                  final downloadUrl =
                                      await ref.getDownloadURL();

                                  // Guardar la URL de la imagen en Firestore
                                  FirebaseFirestore.instance
                                      .collection('fotos')
                                      .add({
                                    'url': downloadUrl,
                                    'timestamp': FieldValue.serverTimestamp(),
                                    'user_id': Constants.authUserEmail,
                                  });

                                  if (mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Imagen subida con éxito.'),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  // upload the image to Firebase Storage
                }),
          ],
        ),
      ),
    );
  }
}
