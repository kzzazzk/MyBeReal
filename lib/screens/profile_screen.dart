import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_be_real/utils/constants.dart';
import 'package:my_be_real/widgets/custom_animated_gradient.dart';
import 'package:my_be_real/widgets/custom_appbar.dart';
import 'package:my_be_real/widgets/custom_button_widget.dart';
import 'package:my_be_real/widgets/custom_textfield_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isImageUploaded = false;
  Color buttonColor = Colors.black;
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  String? profileImageUrl; // Initialize as null
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: Center(
        child: Stack(
          children: [
            const CustomAnimatedBackground(),
            ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 0),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.5),
                                  width: 10,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(125.0),
                                child: FutureBuilder<String?>(
                                  future: getProfilePictureURL(
                                      Constants.authUserEmail),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Display a loading indicator while waiting.
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data!, // Use the retrieved URL
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return getRandomIcon(); // A fallback if there's no data available.
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 200, left: 250),
                            child: FloatingActionButton(
                              backgroundColor: Colors.black,
                              shape: const CircleBorder(),
                              onPressed: () async {
                                final picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);

                                if (image != null) {
                                  uploadImageAndSetProfileUrl(image);
                                }
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomTextField(
                      controller: usernameController,
                      hintText: 'Nombre de usuario',
                      obscureText: false,
                      padding: screenWidth * 0.05,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomTextField(
                      controller: nameController,
                      hintText: 'Nombre',
                      obscureText: false,
                      padding: screenWidth * 0.05,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomTextField(
                      controller: lastnameController,
                      hintText: 'Apellidos',
                      obscureText: false,
                      padding: screenWidth * 0.05,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomButton('Guardar', () {
                      Navigator.pop(context);
                      Get.offNamed('/home');
                    }),
                  ),
                  CustomButton('Cerrar sesión', () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Get.offNamed('/login');
                  }),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Padding getRandomIcon() {
    List<Padding> iconList = [
      const Padding(
        padding: EdgeInsets.all(0),
        child: Icon(
          Icons.face,
          color: Colors.white,
          size: 225,
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(0),
        child: Icon(
          Icons.face_5,
          color: Colors.white,
          size: 225,
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(0),
        child: Icon(
          Icons.face_6,
          color: Colors.white,
          size: 225,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Icon(
          Icons.face_2,
          color: Colors.white,
          size: 180,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: Icon(
          Icons.face_3,
          color: Colors.white,
          size: 190,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 20, left: 10),
        child: Icon(
          Icons.face_4,
          color: Colors.white,
          size: 190,
        ),
      ),
    ];
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final randomIndex = random.nextInt(iconList.length);
    return iconList[randomIndex];
  }

  void changeButtonColor() {
    setState(() {
      buttonColor = Colors.red; // Change the color when the button is clicked.
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfilePicture(); // Load the profile picture when the screen initializes
  }

  Future<void> uploadImageAndSetProfileUrl(XFile image) async {
    try {
      String uniqueFileName = "${Constants.authUserEmail} 's profile pic";
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('other/$uniqueFileName');
      final task = await ref.putFile(File(image.path));
      if (task.state == TaskState.success) {
        final downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: Constants.authUserEmail)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              'profile_pic_url': downloadUrl,
            });
          });
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Foto de perfil subida con éxito.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        setState(() {
          profileImageUrl = downloadUrl; // Update the profile image URL
        });
      }
    } catch (e) {
      // Handle any potential errors here
      print("Error: $e");
    }
  }

  Future<void> loadProfilePicture() async {
    final url = await getProfilePictureURL(Constants.authUserEmail);

    setState(() {
      profileImageUrl = url;
      isLoading = false; // Set isLoading to false once the image is loaded
    });
  }

  Future<String?> getProfilePictureURL(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: Constants.authUserEmail)
              .get();

      if (documentSnapshot.docs.isNotEmpty) {
        Map<String, dynamic>? data = documentSnapshot.docs.first.data();

        if (data.containsKey('profile_pic_url')) {
          // Check if the 'profile_pic_url' field exists
          String? profilePicUrl = data['profile_pic_url'];
          return profilePicUrl;
        }
      }

      return null; // If the document doesn't exist or doesn't contain the URL
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
