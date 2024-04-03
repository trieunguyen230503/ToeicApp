import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class inputEmailProfile extends StatefulWidget {
  const inputEmailProfile(
      {super.key, required this.hint, required this.inputcontroller});

  final hint;
  final inputcontroller;

  @override
  State<inputEmailProfile> createState() => _inputEmailProfileState();
}

class _inputEmailProfileState extends State<inputEmailProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, 0,
          MediaQuery.of(context).size.width * 0.06, 0),
      child: TextFormField(
        controller: widget.inputcontroller,
        enabled: false,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: widget.hint,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: darkblue),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}

class inputDecoration extends StatefulWidget {
  const inputDecoration(
      {super.key,
      required this.hint,
      required this.inputcontroller,
      required this.enable});

  final hint;
  final inputcontroller;
  final enable;

  @override
  State<inputDecoration> createState() => _inputDecorationState();
}

class _inputDecorationState extends State<inputDecoration> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, 0,
          MediaQuery.of(context).size.width * 0.06, 0),
      child: TextFormField(
        enabled: widget.enable,
        controller: widget.inputcontroller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: widget.hint,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: darkblue),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}

class inputDecorationPassword extends StatefulWidget {
  const inputDecorationPassword(
      {super.key,
      required this.passwordHint,
      required this.passwordController,
      required this.enable});

  final passwordHint;
  final passwordController;
  final enable;

  @override
  State<inputDecorationPassword> createState() =>
      _inputDecorationPasswordState();
}

class _inputDecorationPasswordState extends State<inputDecorationPassword> {
  bool _obscureText = true;
  bool _isInputFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, 0,
          MediaQuery.of(context).size.width * 0.06, 0),
      child: TextFormField(
        enabled: widget.enable,
        obscureText: _obscureText,
        controller: widget.passwordController,
        onTap: () {
          setState(() {
            _isInputFocused = true;
          });
        },
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: _isInputFocused ? darkblue : Colors.grey,
              ),
            ),
            hintText: widget.passwordHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: darkblue),
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}

class inputPhoneNumber extends StatefulWidget {
  const inputPhoneNumber(
      {super.key,
      required this.hint,
      required this.phoneController,
      required this.enable});

  final enable;
  final hint;
  final phoneController;

  @override
  State<inputPhoneNumber> createState() => _inputPhoneNumberState();
}

class _inputPhoneNumberState extends State<inputPhoneNumber> {
  bool _isInputFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, 0,
          MediaQuery.of(context).size.width * 0.06, 0),
      child: TextFormField(
        enabled: widget.enable,
        keyboardType: TextInputType.number,
        controller: widget.phoneController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9)
        ],
        onTap: () {
          setState(() {
            _isInputFocused = true;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Container(
            width: 50,
            height: 20,
            alignment: Alignment.center,
            child: Text(
              '+84',
              style: TextStyle(
                color: _isInputFocused ? darkblue : Colors.grey,
              ),
            ),
          ),

          // Có thể thay đổi màu sắc của tiền tố tùy ý
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: darkblue),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: widget.hint,
        ),
      ),
    );
  }
}

class inputDOB extends StatefulWidget {
  const inputDOB(
      {super.key,
      required this.hint,
      required this.dobController,
      required this.enable});

  final hint;
  final dobController;
  final enable;

  @override
  State<inputDOB> createState() => _inputDOBState();
}

class _inputDOBState extends State<inputDOB> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      errorFormatText: 'Ngày không hợp lệ',
      errorInvalidText: 'Ngày không hợp lệ',
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        widget.dobController.text =
            DateFormat("dd/MM/yyyy").format(selectedDate).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, 0,
          MediaQuery.of(context).size.width * 0.06, 0),
      child: TextFormField(
        enabled: widget.enable,
        keyboardType: TextInputType.datetime,
        controller: widget.dobController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: darkblue),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: widget.hint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            )),
      ),
    );
  }
}

class SettingContainer extends StatefulWidget {
  const SettingContainer({super.key, required this.icon, required this.hint});

  final icon;
  final hint;

  @override
  State<SettingContainer> createState() => _SettingContainerState();
}

class _SettingContainerState extends State<SettingContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          right: MediaQuery.sizeOf(context).height * 0.02,
          left: MediaQuery.sizeOf(context).height * 0.02),
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height * 0.09,
      decoration: const BoxDecoration(
          border: Border(
              //bottom: BorderSide(color: Colors.grey, width: 0.5),
              top: BorderSide(color: Colors.grey, width: 0.5))),
      child: ListTile(
        title: Text(widget.hint.toString()),
        leading: Icon(
          widget.icon,
          color: darkblue,
        ),
      ),
    );
  }
}
