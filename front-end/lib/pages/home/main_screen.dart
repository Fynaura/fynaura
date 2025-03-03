import 'package:flutter/material.dart';
import 'package:fynaura/pages/add-transactions/transaction_detail_page.dart';
import 'package:fynaura/pages/home/home.dart';
import '../profile/profile.dart';
import 'TabPage.dart';
import 'package:fynaura/widgets/nav_bar.dart';
import 'package:fynaura/widgets/nav_model.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final analyticsNavKey = GlobalKey<NavigatorState>();
  final planNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
NavModel(
  page: DashboardScreen(),  // Use DashboardScreen as the Home tab
  navKey: homeNavKey,
),
      NavModel(
        page: const TabPage(title: 'Analytics'), // Update to use title
        navKey: analyticsNavKey,
      ),
      NavModel(
        page: const TabPage(title: 'Plans'), // Update to use title
        navKey: planNavKey, // Update to use key  
      ),
      NavModel(
        page: ProfilePage(), // Update to use title
        navKey: profileNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
            key: page.navKey,
            onGenerateInitialRoutes: (navigator, initialRoute) {
              return [
                MaterialPageRoute(builder: (context) => page.page)
              ];
            },
          ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 64,
          width: 64,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionDetailPage()),
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Color(0xFF85C1E5)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: Color(0xFF85C1E5),
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index].navKey.currentState?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}

