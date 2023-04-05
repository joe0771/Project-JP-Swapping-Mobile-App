import 'dart:developer';
import 'dart:io';
import 'package:battery_swap_station/src/constants/color.dart';
import 'package:battery_swap_station/src/widgets/dialogs/dialog_confirm_awesome.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:battery_swap_station/src/services/logout.dart';
import 'package:battery_swap_station/src/constants/asset.dart';
import 'package:battery_swap_station/src/models/profile_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:battery_swap_station/src/services/network_service.dart';
import 'package:battery_swap_station/src/pages/profile/widgets/info_card.dart';

const storage = FlutterSecureStorage();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<ProfilePage> {
  late Future<ProfileModel?> dataProfile;
  final double coverHeight = 200;
  final double profileHeight = 144;

  File? imageAvatar;
  File? imageBG;
  String? imageProfilePath;
  String? imageBGPath;

  PickedFile? imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> refreshFuture() async {
    setState(() {
      dataProfile = NetworkService().fetchProfile();
      getImageFilePath();
    });
  }

  Future pickImageAvatar(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        imageAvatar = imageTemporary;
      });

      String imagePath = image.path;
      await storage.write(key: 'image_profile', value: imagePath);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageBG(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        imageBG = imageTemporary;
      });

      String imageBGPath = image.path;
      await storage.write(key: 'image_BG', value: imageBGPath);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void getImageFilePath() async {
    String? imageProfile = await storage.read(key: 'image_profile');
    String? imageBG = await storage.read(key: 'image_BG');
    setState(() {
      imageProfilePath = imageProfile;
    });
  }

  @override
  void initState() {
    dataProfile = NetworkService().fetchProfile();
    getImageFilePath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: FutureBuilder<ProfileModel?>(
        future: dataProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ProfileModel? dataUser = snapshot.data;
            return RefreshIndicator(
              onRefresh: refreshFuture,
              child: buildBody(dataUser!),
            );
          }
          if (snapshot.hasError) {
            return _buildCardNotData();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView buildBody(ProfileModel dataProfile) {
    final top = coverHeight - profileHeight / 1.3;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Image.asset(
            //   Asset.BG_JINPAO,
            //   width: double.infinity,
            //   height: 250,
            //   fit: BoxFit.cover,
            // ),
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                color: CustomColors.primaryColor
                // gradient: LinearGradient(
                //     colors: [
                //       Color(0xFF3366FF),
                //       Color(0xFF00CCFF),
                //     ],
                //     begin: FractionalOffset(0.0, 0.0),
                //     end: FractionalOffset(1.0, 0.0),
                //     stops: [0.0, 1.0],
                //     tileMode: TileMode.clamp),
              ),
            ),
            Positioned(
              top: top,
              child: Stack(
                children: [
                  if (imageProfilePath != null) ...[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: FileImage(File(imageProfilePath!)),
                      ),
                    ),
                  ] else if (imageAvatar != null) ...[
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: FileImage(imageAvatar!),
                      ),
                    ),
                  ] else ...[
                     const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage(
                          Asset.BG_USER,
                        ),
                      ),
                    ),
                  ],
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 28.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    InfoCard(
                      title: dataProfile.fullName.toString(),
                      subtitle: 'Full name',
                      icon: Icons.drive_file_rename_outline_rounded,
                    ),
                    InfoCard(
                      title: dataProfile.email.toString(),
                      subtitle: 'Email',
                      icon: Icons.email,
                    ),
                    InfoCard(
                      title: dataProfile.mobilePhone.toString(),
                      subtitle: 'Phone',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Credit',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    InfoCard(
                      title: dataProfile.balance.toString(),
                      subtitle: 'Amount',
                      icon: Icons.payment,
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Setting',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    buildCardLogout(),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildCardNotData() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 35.0,
                  ),
                  title: Text(
                    'Fail loading data!',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "There was a problem Unable to load your data.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                buildCardLogout(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildCardLogout() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          dialogConfirmAwesome(
            context,
            'Logout?',
            'Are you sure you want to \n log out?',
            () => logOut(),
          );
        },
        child: const ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            refreshFuture();
          },
        ),
      ],
      backgroundColor: CustomColors.primaryColor,
    );
  }
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            'Choose profile photo',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.camera,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var status = await Permission.camera.status;
                  if (status.isGranted) {
                    pickImageAvatar(ImageSource.camera);
                  } else if (status.isDenied) {
                    pickImageAvatar(ImageSource.camera);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Camera Permission'),
                        content: const Text(
                            'This app needs camera access to take pictures for upload user profile photo.'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: const Text('Deny'),
                            onPressed: () => Get.back(),
                          ),
                          CupertinoDialogAction(
                            child: const Text('Settings'),
                            onPressed: () {
                              Get.back();
                              openAppSettings();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                label: const Text('Camera'),
              ),
              const SizedBox(width: 30.0),
              TextButton.icon(
                icon: const Icon(
                  Icons.image,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var status = await Permission.photos.status;
                  if (status.isGranted) {
                    pickImageAvatar(ImageSource.gallery);
                  } else if (status.isDenied) {
                    pickImageAvatar(ImageSource.gallery);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Photos Permission'),
                        content: const Text(
                            'This app needs photos access to choose user profile image.'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: const Text('Deny'),
                            onPressed: () => Get.back(),
                          ),
                          CupertinoDialogAction(
                            child: const Text('Settings'),
                            onPressed: () {
                              Get.back();
                              openAppSettings();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                label: const Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
