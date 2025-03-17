// import 'package:flutter/material.dart';
// import 'package:fynaura/pages/home/home.dart';
//
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   String _userName = 'Xuan';  // Default name, update with actual user data
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _userName = user.displayName ?? 'Guest';  // Use Firebase user data for the name
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome $_userName !', style: TextStyle(fontSize: 20.0)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       // Remaining code here...
//     );
//   }
// }
