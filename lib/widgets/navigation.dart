import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Analyze',
            ),
            // Plan and Profile items without the center
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Empty space for the + button
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: widget.selectedIndex,
          onTap: widget.onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2 - 30, // Center horizontally
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.blue,
            child: Icon(Icons.add, color: Colors.white),
            elevation: 4.0,
          ),
        ),
      ],
    );
  }
}
