import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hire_q/helpers/constants.dart';
import 'package:hire_q/screens/auth/login_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget title;
  final Function() leadingAction;
  final Function() actionEvent;
  final Widget leadingIcon;
  final Color backgroundColor;
  final Color leadingIconColor;
  final Widget actionIcon;
  final bool actionFlag;
  final bool leadingFlag;
  const CustomAppBar(
      {Key key,
      this.title,
      this.leadingAction,
      this.leadingIcon,
      this.backgroundColor,
      this.actionIcon,
      this.actionEvent,
      this.actionFlag = false,
      this.leadingFlag = false,
      this.leadingIconColor})
      : preferredSize = const Size.fromHeight(60),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      toolbarHeight: 60,
      title: Container(
        padding: EdgeInsets.zero,
        child: title,
      ),
      leading: leadingFlag
          ? Transform.translate(
              // offset: const Offset(0, -20),
              offset: const Offset(0, 0),
              child: IconButton(
                icon: leadingIcon ??
                    Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: leadingIconColor ?? Colors.black,
                    ),
                onPressed: leadingAction,
              ),
            )
          : const SizedBox(
              width: 0,
            ),
      actions: actionFlag
          ? [
              IconButton(
                icon: actionIcon,
                tooltip: 'Notification',
                onPressed: actionEvent,
              ),
            ]
          : [
              const SizedBox(
                width: 0,
              )
            ],
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          // ),
          // gradient: LinearGradient(
          //     colors: [Colors.red, Colors.pink],
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}

class ElevatedButtonCustom extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double height;

  const ElevatedButtonCustom({Key key, this.onTap, this.text, this.height = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            width: 2.0,
            color: Colors.grey.withOpacity(0.8),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButtonCustom extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double height;

  const OutlineButtonCustom({Key key, this.onTap, this.text, this.height = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            width: 2.0,
            color: primaryColor,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class ImageTextButton extends StatelessWidget {
  final Function() onPressed;
  final String image;
  final double imageHeight;
  final double radius;
  final String text;

  const ImageTextButton({
    Key key,
    this.onPressed,
    this.image,
    this.imageHeight = 50,
    this.radius = 15,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: imageHeight,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          // border: Border.all(
          //   width: 2.0,
          //   color: primaryColor,
          // ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: imageHeight,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: accentColor,
              ),
              child: Image.asset(
                image,
                height: imageHeight * 0.8,
                color: secondaryColor,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                height: imageHeight,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  color: primaryColor,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppbarSearchFormField extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLines;

  const AppbarSearchFormField(
      {Key key,
      this.hintText,
      this.prefixIcon,
      this.obsecureText,
      this.suffixIcon,
      this.textInputType,
      this.textInputAction,
      this.controller,
      this.focusNode,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0),
      padding: EdgeInsets.symmetric(vertical: 5),
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          maxLines: maxLines,
          controller: controller,
          autofocus: false,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          obscureText: obsecureText,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            border: InputBorder.none,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
