import 'dart:io';
import 'package:apptoeic/utils/Button.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/constContainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../provider/signin_provider.dart';

class ProfileCustome extends StatefulWidget {
  const ProfileCustome({super.key});

  @override
  State<ProfileCustome> createState() => _ProfileCustomeState();
}

class _ProfileCustomeState extends State<ProfileCustome> {
  PlatformFile? pickedFile;

  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();
  String? uid;
  final RoundedLoadingButtonController updateController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  void getData() async {
    await getInformationFirst();
  }

  Future getInformationFirst() async {
    final sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreference();
    uid = sp.uid;
    email.text = sp.email!;
    if (sp.name! != " ") {
      name.text = sp.name!;
    }
    if (sp.phone! != " ") {
      phone.text = sp.phone!;
    }
    if (sp.address! != " ") {
      print("object" + sp.address!);

      address.text = sp.address!;
    }
    if (sp.dob! != " ") {
      dob.text = sp.dob!;
    }
  }

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

    Future handleUpdateProfile() async {
      await sp.updateProfile(
          uid!, name.text, phone.text, address.text, pickedFile, dob.text);
      Navigator.pop(context);
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            // Đổi icon về
            onPressed: () {
              Navigator.pop(context);
              // Xử lý khi người dùng nhấn vào icon trở về
            },
          ),
          backgroundColor: darkblue,
          centerTitle: true,
          title: const Text(
            'UPDATE YOUR PROFILE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.08,
                  ),
                  Stack(
                    children: [
                      pickedFile != null
                          ? ClipOval(
                              child: Container(
                              width: 120.0,
                              height: 120.0,
                              color: Colors.blue,
                              child: Image.file(
                                File(pickedFile!.path!),
                                // Thay đổi đường dẫn hình ảnh của bạn ở đây
                                fit: BoxFit.cover,
                              ),
                            ))
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage(sp.imageUrl.toString()),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () async {
                            await selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  inputEmailProfile(
                    hint: 'Enter your email',
                    inputcontroller: email,
                    orientation: 1,
                  ),
                  inputDecoration(
                    hint: 'Enter your name',
                    inputcontroller: name,
                    enable: true,
                    orientation: 1,
                  ),
                  inputPhoneNumber(
                    hint: 'Enter your phone',
                    phoneController: phone,
                    enable: true,
                    orientation: 1,
                  ),
                  inputDecoration(
                    hint: 'Enter your address',
                    inputcontroller: address,
                    enable: true,
                    orientation: 1,
                  ),
                  inputDOB(
                    hint: 'Enter your dob',
                    dobController: dob,
                    enable: true,
                    orientation: 1,
                  ),
                  buttonRounded(
                      context,
                      updateController,
                      darkblue,
                      FontAwesomeIcons.registered,
                      'Update your profile',
                      handleUpdateProfile,
                      1),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.08,
                  ),
                  Stack(
                    children: [
                      pickedFile != null
                          ? ClipOval(
                              child: Container(
                              width: 120.0,
                              height: 120.0,
                              color: Colors.blue,
                              child: Image.file(
                                File(pickedFile!.path!),
                                // Thay đổi đường dẫn hình ảnh của bạn ở đây
                                fit: BoxFit.cover,
                              ),
                            ))
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage(sp.imageUrl.toString()),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () async {
                            await selectImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  inputEmailProfile(
                    hint: 'Enter your email',
                    inputcontroller: email,
                    orientation: 2,
                  ),
                  inputDecoration(
                    hint: 'Enter your name',
                    inputcontroller: name,
                    enable: true,
                    orientation: 2,
                  ),
                  inputPhoneNumber(
                    hint: 'Enter your phone',
                    phoneController: phone,
                    enable: true,
                    orientation: 2,
                  ),
                  inputDecoration(
                    hint: 'Enter your address',
                    inputcontroller: address,
                    enable: true,
                    orientation: 2,
                  ),
                  inputDOB(
                    hint: 'Enter your dob',
                    dobController: dob,
                    enable: true,
                    orientation: 2,
                  ),
                  buttonRounded(
                      context,
                      updateController,
                      darkblue,
                      FontAwesomeIcons.registered,
                      'Update your profile',
                      handleUpdateProfile,
                      2),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          }
        }));
  }
}
