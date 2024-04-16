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
      required this.lstWiget,
      required this.itemPerRow});

  final title;
  final lstImg;
  final lstHeadline;
  final lstWiget;
  final itemPerRow;

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
    double h;
    double w;

    if (widget.itemPerRow == 2) {
      h = MediaQuery.sizeOf(context).height * 3;
      w = MediaQuery.sizeOf(context).width;
    } else {
      h = MediaQuery.sizeOf(context).height;
      w = MediaQuery.sizeOf(context).width;
    }

    return Container(
      height: h * 0.23 * (widget.lstImg.length / 4).ceil(),
      width: w,
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
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Container(
                //color: Colors.cyan,
                height: h * 0.175 * (widget.lstImg.length / 4).ceil(),
                width: w,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.lstHeadline.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: widget.itemPerRow == 2 ? 60 : 10,
                        mainAxisSpacing: 5,
                        childAspectRatio:
                            widget.itemPerRow == 2 ? 1 / 1.6 : 1 / 1.8),
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
                                    width: w / 4,
                                    height: h * 0.09,
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
                                    width: w / 4.6,
                                    height: h * 0.05,
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
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
