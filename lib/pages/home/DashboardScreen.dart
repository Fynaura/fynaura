// import 'package:flutter/material.dart';
// import 'package:fynaura/widgets/navigation.dart';
//
// import '../../widgets/nav_bar.dart';
// import '../../widgets/nav_model.dart';  // Import the custom navigation bar
//
// class MainScreen extends StatefulWidget {
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   final homeNavKey = GlobalKey<NavigatorState>();
//   final searchNavKey = GlobalKey<NavigatorState>();
//   final notificationsNavKey = GlobalKey<NavigatorState>();
//   final profileNavKey = GlobalKey<NavigatorState>();
//   int selectedTab = 0;
//   List<NavModel> items = [];
//   //int _selectedIndex = 0;  // Track the selected index
//
//   void initState() {
//     super.initState();
//     items = [
//       NavModel(
//         page: const TabPage(tab:1),
//         navKey: homeNavKey,
//
//       ),
//       NavModel(
//         page: const TabPage(tab:1),
//         navKey: searchNavKey,
//
//       ),
//       NavModel(
//         page: const TabPage(tab:1),
//         navKey: notificationsNavKey,
//
//       ),
//       NavModel(
//         page: const TabPage(tab:1),
//         navKey: profileNavKey,
//
//       ),
//     ];
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
//           items[selectedTab].navKey.currentState?.pop();
//           return Future.value(false);
//         } else {
//           return Future.value(true);
//         }
//       },
//       child: Scaffold(
//         body: IndexedStack(
//           index: selectedTab,
//           children: items
//               .map((page) => Navigator(
//             key: page.navKey,
//             onGenerateInitialRoutes: (navigator, initialRoute) {
//               return [
//                 MaterialPageRoute(builder: (context) => page.page)
//               ];
//             },
//           ))
//               .toList(),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: Container(
//           margin: const EdgeInsets.only(top: 10),
//           height: 64,
//           width: 64,
//           child: FloatingActionButton(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             onPressed: () => debugPrint("Add Button pressed"),
//             shape: RoundedRectangleBorder(
//               side: const BorderSide(width: 3, color: Colors.green),
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child: const Icon(
//               Icons.add,
//               color: Colors.green,
//             ),
//           ),
//         ),
//         bottomNavigationBar: NavBar(
//           pageIndex: selectedTab,
//           onTap: (index) {
//             if (index == selectedTab) {
//               items[index]
//                   .navKey
//                   .currentState
//                   ?.popUntil((route) => route.isFirst);
//             } else {
//               setState(() {
//                 selectedTab = index;
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   // void _onItemTapped(int index) {
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   // }
//   //
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text('Welcome Xuan !',
//   //         style: TextStyle(
//   //           fontSize: 20.0,
//   //         ),),
//   //       centerTitle: true,
//   //       actions: [
//   //         IconButton(
//   //           icon: Icon(Icons.notifications),
//   //           onPressed: () {},
//   //         ),
//   //       ],
//   //     ),
//   //     body: Padding(
//   //       padding: const EdgeInsets.all(25.0),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           // Income and Expense
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: [
//   //               IncomeExpenseCard(title: 'Income', amount: 'LKR 49,500', color: Colors.blue),
//   //               IncomeExpenseCard(title: 'Expense', amount: 'LKR 37,020', color: Colors.red),
//   //             ],
//   //           ),
//   //           SizedBox(height: 20),
//   //
//   //           // Budget Plan
//   //           Text('Budget Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//   //           SizedBox(height: 10),
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: [
//   //               BudgetCard(title: 'Monthly Budget', amount: 'LKR 10,000', total: 'LKR 50,000', progress: 0.7),
//   //               BudgetCard(title: 'Conversation', amount: 'LKR 10,000', total: 'LKR 50,000', progress: 0.7),
//   //             ],
//   //           ),
//   //           SizedBox(height: 20),
//   //
//   //           // Goals
//   //           Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//   //           SizedBox(height: 10),
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: [
//   //               GoalCard(title: 'Bicycle', progress: 0.7),
//   //               GoalCard(title: 'Earphone', progress: 0.7),
//   //             ],
//   //           ),
//   //           Spacer(),
//   //
//   //           // Custom Bottom Navigation Bar
//   //           CustomBottomNavigationBar(
//   //             selectedIndex: _selectedIndex,
//   //             onItemTapped: _onItemTapped,
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// }
//
// // class IncomeExpenseCard extends StatelessWidget {
// //   final String title;
// //   final String amount;
// //   final Color color;
// //
// //   const IncomeExpenseCard({Key? key, required this.title, required this.amount, required this.color}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       width: 150,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //           SizedBox(height: 10),
// //           Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // class BudgetCard extends StatelessWidget {
// //   final String title;
// //   final String amount;
// //   final String total;
// //   final double progress;
// //
// //   const BudgetCard({Key? key, required this.title, required this.amount, required this.total, required this.progress}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.green.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       width: 150,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //           SizedBox(height: 10),
// //           Text('$amount of $total', style: TextStyle(fontSize: 14)),
// //           SizedBox(height: 10),
// //           LinearProgressIndicator(value: progress),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // class GoalCard extends StatelessWidget {
// //   final String title;
// //   final double progress;
// //
// //   const GoalCard({Key? key, required this.title, required this.progress}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.blue.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       width: 150,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //           SizedBox(height: 10),
// //           LinearProgressIndicator(value: progress),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class Page extends StatelessWidget {
//   final int tab;
//
//   const Page ({super.key, required this.tab});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page Tab $tab')),
//       body: Center(child: Text('Tab $tab')),
//     );
//   }
// }
//
// class TabPage extends StatelessWidget{
//   final int tab;
//
//   const TabPage({Key? key, required this.tab}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(title: Text('Tab $tab')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Tab $tab'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => Page(tab: tab),
//                     )
//                   );
//                 },
//               child: const Text('Go to page'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
// }