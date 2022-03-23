import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
// import provider
import 'package:hire_q/provider/index.dart';
import 'package:provider/provider.dart';

class SwipeConfiguration {
  //Vertical swipe configuration options
  double verticalSwipeMaxWidthThreshold = 100.0;
  double verticalSwipeMinDisplacement = 300.0;
  double verticalSwipeMinVelocity = 80.0;

  //Horizontal swipe configuration options
  double horizontalSwipeMaxHeightThreshold = 100.0;
  double horizontalSwipeMinDisplacement = 50.0;
  double horizontalSwipeMinVelocity = 100.0;

  SwipeConfiguration({
    double verticalSwipeMaxWidthThreshold,
    double verticalSwipeMinDisplacement,
    double verticalSwipeMinVelocity,
    double horizontalSwipeMaxHeightThreshold,
    double horizontalSwipeMinDisplacement,
    double horizontalSwipeMinVelocity,
  }) {
    if (verticalSwipeMaxWidthThreshold != null) {
      this.verticalSwipeMaxWidthThreshold = verticalSwipeMaxWidthThreshold;
    }

    if (verticalSwipeMinDisplacement != null) {
      this.verticalSwipeMinDisplacement = verticalSwipeMinDisplacement;
    }

    if (verticalSwipeMinVelocity != null) {
      this.verticalSwipeMinVelocity = verticalSwipeMinVelocity;
    }

    if (horizontalSwipeMaxHeightThreshold != null) {
      this.horizontalSwipeMaxHeightThreshold =
          horizontalSwipeMaxHeightThreshold;
    }

    if (horizontalSwipeMinDisplacement != null) {
      this.horizontalSwipeMinDisplacement = horizontalSwipeMinDisplacement;
    }

    if (horizontalSwipeMinVelocity != null) {
      this.horizontalSwipeMinVelocity = horizontalSwipeMinVelocity;
    }
  }
}

class SwipeDetector extends StatefulWidget {
  SwipeDetector(
      {Key key,
      this.child,
      this.onSwipeUp,
      this.onSwipeDown,
      this.onSwipeLeft,
      this.onSwipeRight,
      SwipeConfiguration swipeConfiguration})
      : swipeConfiguration = swipeConfiguration ?? SwipeConfiguration(),
        super(key: key);
  final Widget child;
  final Function() onSwipeUp;
  final Function() onSwipeDown;
  final Function() onSwipeLeft;
  final Function() onSwipeRight;
  final SwipeConfiguration swipeConfiguration;
  @override
  _SwipeDetector createState() => _SwipeDetector();
}

class _SwipeDetector extends State<SwipeDetector>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  // appstate
  AppState _appState;
  Alignment _dragAlignment = Alignment.center;

  Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
    _appState = Provider.of<AppState>(context, listen: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Vertical drag details

    //Horizontal drag details
    DragStartDetails startHorizontalDragDetails;
    DragUpdateDetails updateHorizontalDragDetails;
    final size = MediaQuery.of(context).size * 0.8;
    return GestureDetector(
      child: Align(
        alignment: _dragAlignment,
        child: widget.child,
      ),
      // onPanDown: (details) {
      //   _controller.stop();
      // },
      // onPanUpdate: (details) {
      //   setState(() {
      //     _dragAlignment += Alignment(
      //       details.delta.dx / (size.width / 2),
      //       details.delta.dy / (size.height / 2),
      //     );
      //   });
      // },
      // onPanEnd: (details) {
      //   _runAnimation(details.velocity.pixelsPerSecond, size);
      // },
      onVerticalDragStart: (dragDetails) {
        // setState(() {
        //   startVerticalDragDetails = dragDetails;
        // });
      },
      onVerticalDragUpdate: (dragDetails) {
        // print(dragDetails.globalPosition.dy);
        // print(dragDetails.delta.direction);
        if (dragDetails.delta.direction > 1 &&
            dragDetails.globalPosition.dy > (size.height / 2)) {
          _appState.talentSwipeUp = false;
        }
        if (dragDetails.delta.direction < 1 &&
            dragDetails.globalPosition.dy < (size.height / 2)) {
          _appState.talentSwipeUp = true;
        }
        setState(() {
          // updateVerticalDragDetails = dragDetails;
          _dragAlignment += Alignment(
            0,
            dragDetails.delta.dy / (size.height / 15),
          );
        });
      },
      onVerticalDragDown: (dragDetails) {
        _controller.stop();
      },

      onVerticalDragEnd: (endDetails) {
        // double dx =
        //     _dragAlignment.x - startVerticalDragDetails.globalPosition.dx;
        // double dy = updateHorizontalDragDetails.globalPosition.dy -
        //     startVerticalDragDetails.globalPosition.dy;
        double dragDx = _dragAlignment.x;
        double dragDy = _dragAlignment.y;
        double velocity = endDetails.primaryVelocity;

        //Convert values to be positive
        if (dragDx < 0) dragDx = -dragDx;
        if (dragDy < 0) dragDy = -dragDy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        // if (dx > widget.swipeConfiguration.verticalSwipeMaxWidthThreshold) {
        //   _runAnimation(endDetails.velocity.pixelsPerSecond, size);
        //   return;
        // }
        // if (dy < widget.swipeConfiguration.verticalSwipeMinDisplacement) {
        //   _runAnimation(endDetails.velocity.pixelsPerSecond, size);
        //   return;
        // }
        double dx = dragDx * size.width / 2;
        double dy = dragDy * size.height / 15;
        // print("dy==================");
        // print(dy);
        // if (dx > widget.swipeConfiguration.verticalSwipeMaxWidthThreshold) {
        //   print(1);
        //   _runAnimation(endDetails.velocity.pixelsPerSecond, size);
        //   return;
        // }
        // if (dy < widget.swipeConfiguration.verticalSwipeMinDisplacement) {
        //   print(2);
        //   _runAnimation(endDetails.velocity.pixelsPerSecond, size);
        //   return;
        // }
        // if (positiveVelocity <
        //     widget.swipeConfiguration.verticalSwipeMinVelocity) {
        //   print(3);
        //   _runAnimation(endDetails.velocity.pixelsPerSecond, size);
        //   return;
        // }
        if (dx > widget.swipeConfiguration.verticalSwipeMaxWidthThreshold) {
          // print(1);
          _runAnimation(endDetails.velocity.pixelsPerSecond, size);
          return;
        }
        // print("dy ==========");
        // print(dy);
        if (dy < size.height * 0.8) {
          // print(2);
          _runAnimation(endDetails.velocity.pixelsPerSecond, size);
          return;
        }
        if (positiveVelocity <
            widget.swipeConfiguration.verticalSwipeMinVelocity) {
          // print(3);
          _runAnimation(endDetails.velocity.pixelsPerSecond, size);
          return;
        }

        if (velocity < 0) {
          //Swipe Up
          if (widget.onSwipeUp != null) {
            widget.onSwipeUp();
          }
        } else {
          //Swipe Down
          if (widget.onSwipeDown != null) {
            widget.onSwipeDown();
          }
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragDown: (dragDetails) {},
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        // _runAnimation(endDetails.velocity.pixelsPerSecond, size);
        double dx = updateHorizontalDragDetails.globalPosition.dx -
            startHorizontalDragDetails.globalPosition.dx;
        double dy = updateHorizontalDragDetails.globalPosition.dy -
            startHorizontalDragDetails.globalPosition.dy;
        double velocity = endDetails.primaryVelocity;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx < widget.swipeConfiguration.horizontalSwipeMinDisplacement) {
          return;
        }
        if (dy > widget.swipeConfiguration.horizontalSwipeMaxHeightThreshold) {
          return;
        }
        if (positiveVelocity <
            widget.swipeConfiguration.horizontalSwipeMinVelocity) {
          return;
        }

        if (velocity < 0) {
          //Swipe Up
          if (widget.onSwipeLeft != null) {
            widget.onSwipeLeft();
          }
        } else {
          //Swipe Down
          if (widget.onSwipeRight != null) {
            widget.onSwipeRight();
          }
        }
      },
    );
  }
}
