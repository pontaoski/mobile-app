import 'package:cobble/localization/localization.dart';
import 'package:cobble/ui/common/components/cobble_button.dart';
import 'package:cobble/ui/common/icons/watch_icon.dart';
import 'package:cobble/ui/home/home_page.dart';
import 'package:cobble/ui/router/cobble_navigator.dart';
import 'package:cobble/ui/router/cobble_scaffold.dart';
import 'package:cobble/ui/router/cobble_screen.dart';
import 'package:cobble/ui/setup/pair_page.dart';
import 'package:cobble/ui/theme/with_cobble_theme.dart';
import 'package:flutter/material.dart';

import '../common/icons/fonts/rebble_icons.dart';

class CircleContainer extends StatelessWidget {
  CircleContainer(
      {this.child, this.diameter, this.color, this.margin, this.padding});

  final Widget? child;
  final double? diameter;
  final Color? color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color == null ? Theme.of(context).dividerColor : color,
          shape: BoxShape.circle),
      child: child,
      width: diameter,
      height: diameter,
      margin: margin == null ? EdgeInsets.zero : margin,
      padding: padding == null ? EdgeInsets.zero : padding,
    );
  }
}

class CarouselIcon extends StatelessWidget {
  CarouselIcon({this.icon});

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return CircleContainer(
      diameter: 128.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(child: icon),
    );
  }
}

class FirstRunPage extends StatefulWidget implements CobbleScreen {
  @override
  State<StatefulWidget> createState() => new _FirstRunPageState();
}

class _FirstRunPageState extends State<FirstRunPage> {
  static List<Widget> _iconScrollerSet = [
    CarouselIcon(
        icon: PebbleWatchIcon.classic(PebbleWatchColor.Red, size: 96.0)),
    CarouselIcon(icon: PebbleWatchIcon.time(PebbleWatchColor.Red, size: 96.0)),
    CarouselIcon(
        icon: PebbleWatchIcon.timeRound(PebbleWatchColor.White,
            bodyStrokeColor: Colors.black, size: 96.0)),
    CarouselIcon(
        icon: PebbleWatchIcon.pebbleTwo(PebbleWatchColor.White,
            buttonsColor: PebbleWatchColor.Aqua,
            bezelColor: PebbleWatchColor.Aqua,
            size: 96.0)),
  ];
  List<Widget> _iconScroller = _iconScrollerSet;

  ScrollController _scrollController = new ScrollController();
  bool _doneScrollChange = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (!_doneScrollChange) {
        _doneScrollChange = true;
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent * 4096,
            duration: Duration(seconds: 5 * 4096),
            curve: Curves.linear);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CobbleScaffold.page(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: (MediaQuery.of(context).size.height / 5),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                CircleContainer(
                  child: Image(
                    image: AssetImage("images/app_large.png"),
                  ),
                  diameter: 120,
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(20),
                ),
                SizedBox(height: 16.0), // spacer
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    tr.firstRun.title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: 24.0), // spacer
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController
                    ..addListener(() {
                      if (_scrollController.position.pixels >
                          _scrollController.position.maxScrollExtent * 0.9) {
                        setState(() {
                          _iconScroller += _iconScrollerSet;
                        });
                      }
                      _doneScrollChange = false;
                    }),
                  child: Row(children: _iconScroller),
                ),
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CobbleButton(
                    outlined: false,
                    color: context.textTheme.bodyText2?.color,
                    label: tr.common.skip,
                    onPressed: () => context.pushAndRemoveAllBelow(
                      HomePage(),
                    ),
                  ),
                  FloatingActionButton.extended(
                    icon: Text(tr.firstRun.fab),
                    label: Icon(RebbleIcons.caret_right),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () => context.push(
                      PairPage.fromLanding(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
