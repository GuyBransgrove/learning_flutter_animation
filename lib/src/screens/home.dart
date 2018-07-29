import '../widgets/cat.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn
      )
    );
    boxController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    boxAnimation = Tween(begin: pi* 0.6, end: pi * 0.65).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut
      )
    );

    boxAnimation.addStatusListener((AnimationStatus status){
      switch(status){
        case AnimationStatus.completed:
          boxController.reverse();
          break;
        case AnimationStatus.dismissed:
          boxController.forward();
          break;
        default: break;
      }
    });
    boxController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation')
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
          children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap()
            ],
            overflow: Overflow.visible,
          )
        ),
        onTap: onTap
      ),
    );
  }

  void onTap() {
    switch(catController.status){
      case AnimationStatus.completed:
      case AnimationStatus.forward:
        catController.reverse();
        boxController.forward();
        break;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        catController.forward();
        boxController.stop();
        break;
    }
    
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (BuildContext context, Widget child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0
        );
      },
      child: Cat()
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown
        ),
        builder: (BuildContext context, Widget child){
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: boxAnimation.value
          );
        }
      )
    );
  }

  Widget buildRightFlap() {    
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown
        ),
        builder: (BuildContext context, Widget child){
          return Transform.rotate(
            child: Container(
              height: 10.0,
              width: 125.0,
              color: Colors.brown
            ),
            alignment: Alignment.topRight,
            angle: -boxAnimation.value
          );
        }
      )
    );
  }
}