import 'package:flutter/material.dart';

class DockingBar extends StatefulWidget {
  const DockingBar({super.key});

  @override
  State<DockingBar> createState() => _DockingBarState();
}

class _DockingBarState extends State<DockingBar> {
  int activeIndex = 0;

  List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.menu,
    Icons.notifications,
    Icons.person
  ];

  Tween<double> tween = Tween<double>(begin: 1.0, end: 1.2);
  bool animationCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        clipBehavior: Clip.none,
        width: MediaQuery.sizeOf(context).width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TweenAnimationBuilder(
          key: ValueKey(activeIndex),
          tween: tween,
          duration: Duration(milliseconds: animationCompleted ? 2000 : 200),
          curve: animationCompleted ? Curves.elasticOut : Curves.easeOut,
          onEnd: () {
            setState(() {
              animationCompleted = true;
              tween = Tween(begin: 1.5, end: 1.0);
            });
          },
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(icons.length, (i) {
                return Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..scale(i == activeIndex ? value : 1.0)
                    ..translate(
                        0.0, i == activeIndex ? 80.0 * (1 - value) : 0.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        animationCompleted = false;
                        tween = Tween(begin: 1.0, end: 1.2);
                        activeIndex = i;
                      });
                    },
                    onHover: (pointer) {
                      setState(() {
                        animationCompleted = false;
                        tween = Tween(begin: 1.0, end: 1.2);
                        activeIndex = i;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icons[i],
                        size: 24, // Icon size
                        color: Colors.black, // Icon color
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
