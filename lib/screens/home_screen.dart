import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
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
          const Center(
            child: SizedBox(
              height: 60,
              width: 150,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add, size: 30),
          fabSize: ExpandableFabSize.regular,
          backgroundColor: Colors.black,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(
            Icons.close,
            size: 25,
          ),
          fabSize: ExpandableFabSize.regular,
          backgroundColor: Colors.black,
        ),
        distance: 70,
        type: ExpandableFabType.up,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 5,
        ),
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: null,
            child: const Icon(Icons.add_photo_alternate_outlined),
            onPressed: () {
              const SnackBar snackBar = SnackBar(
                content: Text("SnackBar"),
              );
              scaffoldKey.currentState?.showSnackBar(snackBar);
            },
          ),
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: null,
            child: const Icon(Icons.add_a_photo_outlined),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => const NextPage())));
            },
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('next'),
      ),
      body: const Center(
        child: Text('next'),
      ),
    );
  }
}
