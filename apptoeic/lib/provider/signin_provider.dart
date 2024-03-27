import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/User.dart';

class SignInProvider extends ChangeNotifier {
  //instance of firebaseauth, facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  //hasError, errorCode, provider, uid, email, iamgeURl

  bool _hasError = false;

  bool get hasError => _hasError;

  String? _errorCode;

  String? get errorCode => _errorCode;

  String? _provider;

  String? get provider => _provider;

  String? _uid;

  String? get uid => _uid;

  String? _email;

  String? get email => _email;

  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  String? _name;

  String? get name => _name;

  String? _phone = " ";

  String? get phone => _phone;

  String? _address;

  String? get address => _address;

  String? _password;

  String? get password => _password;

  String? _dob;

  String? get dob => _dob;

  int? _role;

  int? get role => _role;

  List<Users>? _userCustomer;

  List<Users>? get userCustomer => _userCustomer;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("sigined_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("sigined_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

//sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      //executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        //Lấy token từ firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        //singing to firebase user instance
        final User userDetail =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //save all values
        _name = userDetail.displayName;
        _email = userDetail.email;
        _imageUrl = userDetail.photoURL;
        _uid = userDetail.uid;
        _provider = "GOOGLE";
        _password = " ";
        _phone = " ";
        _address = " ";
        _dob = " ";
        _role = 1;
      } on FirebaseException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;
          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            notifyListeners();
        }
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

//Entry for cloudFireStore
  Future getUserDataFromFirestore(String? uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['image_url'],
              _provider = snapshot['provider'],
              _role = snapshot['role']
            });
  }

  //Update account trong admin
  Future getUserForUpdate(String? uid) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$uid').get();
    final data = await snapshot.value as Map<dynamic, dynamic>;

    _name = data['name'];
    _email = data['email'];
    _imageUrl = data['image_url'];
    _provider = data['provider'];
    _phone = data['phone'];
    _address = data['address'];
    _password = data['password'];
    _role = data['role'];
  }

  //Save dành cho user
  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    if (_provider == "PHONE") {
      //Vì PHONE không có UID trả về nên lấy key của document gán đỡ
      await r.set({
        "name": _name,
        "email": _email,
        "uid": r.id,
        "image_url": _imageUrl,
        "role": 1,
        "phone": _phone,
        "provider": _provider,
        "password": password,
        "address": "",
        "dob": _dob
      });
    } else {
      await r.set({
        "name": _name,
        "email": _email,
        "uid": _uid,
        "image_url": _imageUrl,
        "role": 1,
        "provider": _provider,
      });
    }
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_url', _imageUrl!);
    await s.setString('provider', _provider!);
    await s.setString("phone", _phone!);
    await s.setString('address', _address!);
    await s.setString('dob', _dob!);

    await s.setString('password', _password!);
    await s.setInt('role', _role!);

    print("role trong sharePre$_role");
    notifyListeners();
  }

//Get data in home screen
  Future getDataFromSharedPreference() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
    _email = s.getString('email');
    _imageUrl = s.getString('image_url');
    _uid = s.getString('uid');
    _provider = s.getString('provider');
    _phone = s.getString('phone');
    _address = s.getString('address') ?? "";
    _dob = s.getString('dob');
    _role = s.getInt('role');
    _password = s.getString('password');
    notifyListeners();
  }

//checkUser exists or not in cloudfirestore
  Future<bool> checkUserExists() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  //check email register
  Future<bool> checkEmailExists(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      print("Existing User");
      return true;
    } else {
      print("New user");
      return false;
    }
  }

  //Check phone login
  Future<bool> checkEmailLogin(String email, String password) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password",
            isEqualTo: sha512.convert(utf8.encode(password)).toString())
        .get();
    print(sha512.convert(utf8.encode(password)).toString());
    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        // Lấy dữ liệu từ DocumentSnapshot
        _uid = document['uid'];
        _name = document['name'];
        _email = document['email'];
        _imageUrl = document['image_url'];
        _provider = document['provider'];
        _phone = document ['phone'];
        _password = document['password'];
        _address = document['address'];
        _dob = document['dob'];
        _role = document['role'];
      }

      print("Existing User");

      return true;
    } else {
      print("New user");
      return false;
    }
  }

//singout
  Future userSignout() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    await clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.clear();
  }

  //Crete account
  void CreateNewAccount(email, name, password, mobile, dob) {
    _name = name;
    _email = email;
    _phone = mobile;
    //MÃ hóa mật khẩu
    _password = sha512.convert(utf8.encode(password.toString())).toString();
    _imageUrl = "https://cdn-icons-png.flaticon.com/512/1946/1946429.png";
    _provider = "PHONE";
    _uid = null;
    _address = "";
    _dob = dob;
    _role = 1;
    notifyListeners();
  }

  Future<void> updateForgetPass(String email, String newValue) async {
    var uid1 = "";
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        // Lấy dữ liệu từ DocumentSnapshot
        uid1 = document['uid'];
      }

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid1).set({
          'password':
              sha512.convert(utf8.encode(newValue.toString())).toString(),
        }, SetOptions(merge: true));
        print("Cập nhật thành công.");
      } catch (e) {
        print("Lỗi khi cập nhật: $e");
      }
    }
  }

  Future<void> updateProfile(String uid, String name, String phone,
      String address, PlatformFile? image, String dob) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var document in querySnapshot.docs) {
        _uid = document['uid'];
      }
    }

    final SharedPreferences s = await SharedPreferences.getInstance();
    Map<String, dynamic> updateData = {};

    if (image != null) {
      final path = 'avtUser/${image!.name}';
      final file = File(image!.path!);
      final storage = FirebaseStorage.instance.ref().child(path);
      storage.putFile(file);

      //Lấy đường link của hình ảnh
      UploadTask? uploadTask = storage.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      try {
        updateData = {
          'name': name,
          'phone': phone,
          'adress': address,
          'image_url': urlDownload,
          'dob': dob,
        };
      } catch (e) {
        print(e);
      }
      //UPDATE LẠI SHAREPRE CỦA AVATA NẾU CÓ
      await s.setString('image_url', urlDownload!);
    } else {
      updateData = {
        'name': name,
        'phone': phone,
        'adress': address,
        'dob': dob,
      };
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .set(updateData, SetOptions(merge: true));

    //Update lại sharpreces
    await s.setString('name', name!);
    await s.setString("phone", phone!);
    await s.setString('address', address!);
    await s.setString('dob', dob!);
    notifyListeners();
  }
}