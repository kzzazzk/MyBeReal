import 'dart:io';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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

        return SafeArea(
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
                  color: Colors.black26,
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
                              child: InkWell(
                                onTap: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          content: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.network(
                                                  monthPhotos?[index]
                                                      .get('url'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Atrás',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                            //dialog action para download image
                                            CupertinoDialogAction(
                                              onPressed: () async {
                                                // logica para descargar
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Imagen descargada con éxito.',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text('Descargar',
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: SizedBox(
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
          NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      floating: true,
                      centerTitle: true,
                      toolbarHeight: 75,
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
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            width:
                                45, // Adjust the width to make the circle smaller
                            height: 45,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.red, // Set the background color here
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
                    )
                  ],
              body: Stack(
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
                ],
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Enviados por mí',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people,
              color: Colors.white,
            ),
            label: 'Enviados por mi pareja',
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
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

                  if (mounted && image != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          content: Column(children: [
                            const Text(
                              '¿Estás seguro de que quieres enviar esta foto?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image.file(
                              File(image.path),
                            ),
                          ]),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            CupertinoDialogAction(
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

                  if (mounted && image != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          content: Column(children: [
                            const Text(
                              '¿Estás seguro de que quieres enviar esta foto?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image.file(
                              File(image.path),
                            ),
                          ]),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            CupertinoDialogAction(
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
          ],
        ),
      ),
    );
  }
}
