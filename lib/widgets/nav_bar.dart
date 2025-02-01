import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/collab-budgeting/collab-main.dart';

class NavBar extends StatelessWidget{
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,

  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: Platform.isAndroid ? 16:0,
      ),
      child: BottomAppBar(
        elevation: 0.0,
        child: Container(
          height: 60,
          color: Color(0xFF85C1E5),
          child: Row(
            children: [
              navItem(
                CupertinoIcons.home,
                pageIndex == 0,
                onTap: () => onTap(0),
                label: 'Home',

              ),
              navItem(
                CupertinoIcons.search,
                pageIndex == 1,
                onTap: () => onTap(1),
                label: 'Search',

              ),
              navItem(
                CupertinoIcons.calendar_today,
                pageIndex == 2,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CollabMain()),
                  );
                },
                label: 'Plan',

              ),
              navItem(
                CupertinoIcons.person,
                pageIndex ==3,
                onTap: () => onTap(3),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap, required String label}) {
    return Expanded(
        child: InkWell(
          onTap:onTap,
          child: Icon(
            icon,
            color: selected ? Colors.white : Colors.white.withOpacity(0.4),
          ),
        ),
    );
  }
}