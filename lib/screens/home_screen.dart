import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:my_be_real/bloc/user/user_bloc.dart';
import 'package:my_be_real/bloc/user/user_event.dart';
import 'package:my_be_real/bloc/user/user_state.dart';
import 'package:my_be_real/models/image_model.dart';
import 'package:my_be_real/models/user_model.dart';
import 'package:my_be_real/repositories/user_repository.dart';
import 'package:my_be_real/utils/constants.dart';
import 'package:my_be_real/widgets/custom_snackbar.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
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
            fontSize: 25,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
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
          BlocConsumer<UserBloc, UserState>(
              listener: (BuildContext context, UserState state) {
            if (state is UserError) {
              showCustomSnackbar(
                state.errorType,
                state.errorMessage ?? '',
                SnackPosition.TOP,
                Colors.redAccent,
                const Icon(Icons.error, color: Colors.white),
              );
            }
          }, builder: (BuildContext context, UserState state) {
            if (state is UserInitial || state is UserLoading) {
              userBloc.add(GetUserRequested(Constants.userEmail));
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserLoaded) {
              return _selectedIndex == 0
                  ? GridView.count(
                      crossAxisCount: 2,
                      children:
                          List.generate(state.user.listaFotos.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Image.network(
                            state.user.listaFotos[index].id,
                          )),
                        );
                      }),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      children:
                          List.generate(state.user2.listaFotos.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                              child: Image.network(
                            state.user2.listaFotos[index].id,
                          )),
                        );
                      }),
                    );
            } else {
              return const Center(
                child: Text('Error al cargar el usuario.'),
              );
            }
          }),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
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
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Enviados por mí',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Enviados por mi pareja',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
