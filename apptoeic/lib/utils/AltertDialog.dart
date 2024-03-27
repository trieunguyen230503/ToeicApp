import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';

void openAlertDialog(context, tiltle, content, keyword) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            tiltle,
            textAlign: TextAlign.center,
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.5),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: darkblue,
                          fixedSize: const Size(90, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        keyword,
                        style: const TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: const Size(90, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: darkblue,
                              width: 1,
                            )),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancle',
                        style: TextStyle(color: darkblue),
                      ))
                ],
              ),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      });
}
