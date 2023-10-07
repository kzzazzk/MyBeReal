import 'package:animate_gradient/animate_gradient.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
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
              .orderBy('timestamp', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('fotos')
              .where('user_id', isEqualTo: Constants.otherUserEmail)
              .orderBy('timestamp', descending: true)
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

        return GridView.count(
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 4,
          children: List.generate(
            fotos!.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: BlurryContainer(
                    blur: 2,
                    width: 200,
                    height: 200,
                    elevation: 0,
                    color: Colors.black12,
                    padding: const EdgeInsets.all(8),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        fotos[index].get('url'),
                        fit: BoxFit.cover,
                      ),
                    ),
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'MyBeReal.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
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
              onPressed: () {},
            ),
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
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);

                if (pickedFile != null) {
                } else {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
