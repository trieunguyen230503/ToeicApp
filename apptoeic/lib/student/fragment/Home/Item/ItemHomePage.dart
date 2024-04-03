import 'package:apptoeic/provider/signin_provider.dart';
import 'package:apptoeic/student/fragment/Home/Practice/Test/CategoryPractice.dart';
import 'package:apptoeic/student/fragment/Setting/SetttingWOLogin.dart';
import 'package:apptoeic/student/fragment/Test/TestPage.dart';
import 'package:apptoeic/utils/constColor.dart';
import 'package:apptoeic/utils/next_screen.dart';
import 'package:apptoeic/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemHomePage extends StatefulWidget {
  const ItemHomePage(
      {super.key,
      required this.title,
      required this.lstImg,
      required this.lstHeadline,
      required this.lstWiget});

  final title;
  final lstImg;
  final lstHeadline;
  final lstWiget;

  @override
  State<ItemHomePage> createState() => _ItemHomePageState();
}

class _ItemHomePageState extends State<ItemHomePage> {
  bool isLogin = false;

  void checkLogin() async {
    final sp = context.read<SignInProvider>();
    await sp.checkSignInUser();
    isLogin = sp.isSignedIn;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height *
          0.23 *
          (widget.lstImg.length / 4).ceil(),
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.02,
        0,
        MediaQuery.of(context).size.width * 0.02,
        0,
      ),
      //color: Colors.red,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.005,
                bottom: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Text(
                widget.title.toString(),
                style: const TextStyle(
                    color: darkblue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
                //color: Colors.cyan,
                height: MediaQuery.sizeOf(context).height *
                    0.175 *
                    (widget.lstImg.length / 4).ceil(),
                width: MediaQuery.sizeOf(context).width,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.lstHeadline.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1 / 1.8),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                isLogin
                                    ? nextScreen(
                                        context, widget.lstWiget[index])
                                    : openSnackbar(context,
                                        'Please login first', Colors.red);
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Positioned(
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width / 4,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.09,
                                    decoration: BoxDecoration(
                                        color: optionItemColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  child: Image.asset(
                                    width:
                                        MediaQuery.sizeOf(context).width / 4.6,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.05,
                                    widget.lstImg[index].toString(),
                                  ),
                                )
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.lstHeadline[index],
                                style: const TextStyle(
                                    color: darkblue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ),
                          ]);
                    })),
          ]),
    );
  }
}
