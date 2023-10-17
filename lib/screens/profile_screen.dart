import 'dart:io';
import 'dart:math';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_be_real/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color buttonColor = Colors.black;
  final usernameController = TextEditingController();
  @override
  String? profileImageUrl; // Initialize as null
  bool isLoading = true;

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
          size: 205,
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
      profileImageUrl = url ?? '';
      isLoading = false; // Set isLoading to false once the image is loaded
    });
  }

  Future<String?> getProfilePictureURL(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('profile_pictures')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('url')) {
          print(data['url']);
          return data['url'];
        }
      }

      return null; // If the document doesn't exist or doesn't contain the URL
    } catch (e) {
      // Handle any potential errors
      print("Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'One2One.',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 300),
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
                                color: const Color(0xFF000000).withOpacity(0.5),
                                width: 10,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(125.0),
                              child: profileImageUrl == ' '
                                  ? Image.network(
                                      profileImageUrl!,
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    )
                                  : getRandomIcon(),
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
                SizedBox(
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Get.offNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Cerrar sesión',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
