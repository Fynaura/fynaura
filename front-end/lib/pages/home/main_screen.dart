import 'package:flutter/material.dart';
import 'package:fynaura/pages/add-transactions/transaction_detail_page.dart';

import 'package:fynaura/pages/collab-budgeting/collab-main.dart';
import 'package:fynaura/pages/home/home.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import '../Analize/analyze_page.dart';
import '../profile/profile.dart';
import 'package:fynaura/widgets/nav_bar.dart';
import 'package:fynaura/widgets/nav_model.dart';

class MainScreen extends StatefulWidget {


  // Constructor to receive user details
  const MainScreen({
    super.key,

  });

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
    // Access the userId from the singleton
    final userSession = UserSession();

    final displayName = userSession.displayName;
    final email = userSession.email;

    items = [
      NavModel(
        page: DashboardScreen(displayName: displayName, email: email), // Pass the details to DashboardScreen
        navKey: homeNavKey,
      ),
      NavModel(
        page: AnalyzePage(), // Update to use title
        navKey: analyticsNavKey,
      ),
      NavModel(
        page: CollabMain(), // Update to use title
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

        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
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
