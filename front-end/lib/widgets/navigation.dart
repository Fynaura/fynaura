// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CustomBottomNavigationBar extends StatefulWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;
//
//   CustomBottomNavigationBar({
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });
//
//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }
//
// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize AnimationController with a valid vsync
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
//
//   @override
//   void dispose() {
//     // Dispose of AnimationController to avoid memory leaks
//     if (_animationController.isAnimating) {
//       _animationController.stop();
//     }
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blue.shade700, Colors.blue.shade300],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: BottomNavigationBar(
//             items: [
//               BottomNavigationBarItem(
//                 icon: Icon(CupertinoIcons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(CupertinoIcons.search),
//                 label: 'Analyze',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(CupertinoIcons.calendar_today),
//                 label: 'Plan',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(CupertinoIcons.person),
//                 label: 'Profile',
//               ),
//             ],
//             currentIndex: widget.selectedIndex,
//             onTap: widget.onItemTapped,
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: Colors.white,
//             unselectedItemColor: Colors.white70,
//             backgroundColor: Colors.transparent,
//             showUnselectedLabels: false,
//             selectedFontSize: 14.0,
//             unselectedFontSize: 12.0,
//           ),
//         ),
//         Positioned(
//           bottom: 20,
//           left: MediaQuery.of(context).size.width / 2 - 30, // Center horizontally
//           child: GestureDetector(
//             onTap: () {
//               if (mounted) {
//                 _animationController
//                     .forward()
//                     .then((_) => _animationController.reverse());
//               }
//             },
//             child: AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: 1 + _animationController.value * 0.1,
//                   child: child,
//                 );
//               },
//               child: FloatingActionButton(
//                 onPressed: () {},
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   CupertinoIcons.add,
//                   color: Colors.blue,
//                 ),
//                 elevation: 8.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
