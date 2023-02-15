library flyout;

import 'package:flutter/material.dart';

typedef FlyoutBuilder = Function(
    BuildContext context, ScrollController scrollController);
typedef FlyoutBuilderSimple = Function();

const BorderRadius sheetRadius = BorderRadius.only(
    topLeft: Radius.circular(14), topRight: Radius.circular(14));
const ShapeBorder sheetShape =
    RoundedRectangleBorder(borderRadius: sheetRadius);

class SomeScreen extends StatelessWidget {
  const SomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Some Screen"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => flyout(context, () => const ImAFlyoutScreen()),
            child: const Text("Show Flyout"),
          ),
        ),
      );
}

class ImAFlyoutScreen extends StatelessWidget {
  const ImAFlyoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          // Scrolling will move the flyout and the scroller
          controller: flyoutController(context),
          children: [],
        ),
      );
}

ScrollController? flyoutController(BuildContext context) =>
    MFlyout.of(context)?.widget.scrollController;

Future<T?> flyout<T>(BuildContext context, FlyoutBuilderSimple flyoutBuilder,
        {double initialSize = 1,
        bool invisibleBackground = true,
        Color? barrierColor}) =>
    flyoutCustom(context, (context, scrollController) => flyoutBuilder(),
        initialSize: initialSize,
        invisibleBackground: invisibleBackground,
        barrierColor: barrierColor ?? Colors.transparent);

Future<T?> flyoutCustom<T>(BuildContext context, FlyoutBuilder flyoutBuilder,
    {double initialSize = 1,
    bool invisibleBackground = true,
    Color? barrierColor}) {
  Widget? child;
  Widget? flyer;

  return showModalBottomSheet(
      isScrollControlled: true,
      shape: sheetShape,
      isDismissible: true,
      enableDrag: true,
      barrierColor: barrierColor,
      context: context,
      elevation: 0,
      backgroundColor: invisibleBackground
          ? Colors.transparent
          : Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (xcontext) {
        child ??= Padding(
            padding: const EdgeInsets.only(top: 36),
            child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: initialSize,
                builder: (context, sc) {
                  flyer ??= MFlyout(
                      ClipRRect(
                        borderRadius: sheetRadius,
                        child: FlyoutSingleBuilder(flyoutBuilder, sc),
                      ),
                      sc);

                  return flyer ?? const Text("ERROR");
                }));
        return child ?? const Text("ERROR Child");
      }).then((value) => value == null ? null : value as T);
}

class FlyoutSingleBuilder extends StatefulWidget {
  final FlyoutBuilder builder;
  final ScrollController scrollController;

  const FlyoutSingleBuilder(this.builder, this.scrollController, {Key? key})
      : super(key: key);

  @override
  State<FlyoutSingleBuilder> createState() => _FlyoutSingleBuilderState();
}

class _FlyoutSingleBuilderState extends State<FlyoutSingleBuilder> {
  Widget? w;

  @override
  Widget build(BuildContext context) {
    w ??= widget.builder(context, widget.scrollController);
    return w ?? const Text("ERROR W");
  }
}

class MFlyout extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const MFlyout(this.child, this.scrollController, {Key? key})
      : super(key: key);

  @override
  MFlyoutState createState() => MFlyoutState();

  static MFlyoutState? of(BuildContext context) =>
      context.findAncestorStateOfType<State<MFlyout>>() as MFlyoutState?;
}

class MFlyoutState extends State<MFlyout> {
  bool visible = true;

  @override
  Widget build(BuildContext context) => visible ? widget.child : Container();

  void hide() {
    setState(() {
      visible = false;
    });
  }
}
