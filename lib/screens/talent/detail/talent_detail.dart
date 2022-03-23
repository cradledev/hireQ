import 'package:flutter/material.dart';
import 'package:hire_q/widgets/common_widget.dart';

import '../widgets/inverted_top_border_clipper.dart';

class TalentDetail extends StatelessWidget {
  const TalentDetail({
    Key key,
  }) : super(key: key);

  void _minimizeDetail(BuildContext context) {
    final newRoute = PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: const Text("data"),
        );
      },
    );
    Navigator.pushAndRemoveUntil(context, newRoute, ModalRoute.withName(''));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resizeNotifier = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!resizeNotifier.value) resizeNotifier.value = true;
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          ValueListenableBuilder(
            valueListenable: resizeNotifier,
            builder: (context, dynamic value, child) {
              return AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                bottom: value ? 0 : -size.height * .5,
                left: 0,
                right: 0,
                child: child,
              );
            },
            child: SizedBox(
              height: size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(height: size.height * .2),
                  Center(
                    child: HireQLogo(
                      fontSize: size.height * .065,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 55),
                        child: Container(
                          height: 340,
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 60),
                              SizedBox(
                                width: size.width * .65,
                                child: TextButton(
                                  onPressed: () {
                                    resizeNotifier.value = false;
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.pinkAccent,
                                  ),
                                  child: const Text(
                                    'Minimize',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DragDownIndication extends StatelessWidget {
  const _DragDownIndication({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Inicia sesión',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Desliza para ir hacia atras',
          style: TextStyle(
            height: 2,
            fontSize: 14,
            color: Colors.white.withOpacity(.9),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white.withOpacity(.8),
          size: 35,
        ),
      ],
    );
  }
}
