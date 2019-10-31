import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;
  String _animationName = 'idle';

  @override
  void initState() {
    _animationController = AnimationController(
      lowerBound: 0.8,
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() => setState(() {}));
    animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shadow = AnimatedContainer(
      width: 60,
      height: 30,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: _isActive() ? Colors.green : Colors.red,
            blurRadius: 30,
            offset: Offset(0, 10))
      ]),
      duration: Duration(milliseconds: 400),
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      color: _isActive() ? Colors.green[50] : Colors.red[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(child: shadow),
            ScaleTransition(
              scale: animation,
              child: SizedBox(
                width: 300,
                height: 75,
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTap: _onButtonTap,
                  child: FlareActor(
                    'assets/switch.flr',
                    animation: _animationName,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onButtonTap() {
    setState(() {
      if (_animationName == 'idle' || _animationName == 'deactivate') {
        _animationName = 'activate';
      } else {
        _animationName = 'deactivate';
      }
    });
  }

  _onTapDown(_) => _animationController.reverse(from: 1);
  _onTapUp(_) => _animationController.forward();

  bool _isActive() => _animationName == 'activate';
}
