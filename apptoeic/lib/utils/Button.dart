import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

RoundedLoadingButton buttonRounded(context, buttonController, buttonColor,
    buttonIcon, buttonHintText, handle) {
  return RoundedLoadingButton(
    controller: buttonController,
    color: buttonColor,
    successColor: buttonColor,
    width: MediaQuery.of(context).size.width * 0.9,
    height: MediaQuery.of(context).size.height * 0.07,
    onPressed: (){
      handle();

    },
    child: Wrap(
      children: [
        Icon(
          buttonIcon,
          size: 20,
          color: Colors.white,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          buttonHintText,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        )
      ],
    ),
  );
}
