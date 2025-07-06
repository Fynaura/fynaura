import 'package:flutter/material.dart';
import 'package:fynaura/pages/add-transactions/transaction_detail_page.dart';
import 'package:fynaura/pages/collab-budgeting/collab-main.dart';
import 'package:fynaura/pages/home/home.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:fynaura/pages/log-in/mainLogin.dart';
import '../Analize/analyze_page.dart';
import '../profile/profile.dart';
import 'package:fynaura/widgets/nav_bar.dart';
import 'package:fynaura/widgets/nav_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

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
  bool _isLoggedIn = false;

  // Add this method to handle logout
  void _logout(BuildContext context) async {
    // Show confirmation dialog
    bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Logout", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      // Clear user session
      final userSession = UserSession();
      await userSession.clearUserData();

      // Navigate to login screen with MaterialPageRoute
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Mainlogin()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Check if user is logged in
    _checkUserSession();
  }

  void _checkUserSession() async {
    final userSession = UserSession();
    bool isLoggedIn = await userSession.loadUserData();

    if (!isLoggedIn) {
      // If not logged in, redirect to login page
      setState(() {
        _isLoggedIn = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Mainlogin()),
      );
      return;
    }

    // If logged in, set up navigation items
    final displayName = userSession.displayName;
    final email = userSession.email;

    setState(() {
      _isLoggedIn = true;
      items = [
        NavModel(
          page: DashboardScreen(
            displayName: displayName, 
            email: email,
            // Pass the logout function to DashboardScreen
            logoutCallback: () => _logout(context),
          ),
          navKey: homeNavKey,
        ),
        NavModel(
          page: AnalyzePage(),
          navKey: analyticsNavKey,
        ),
        NavModel(
          page: CollabMain(),
          navKey: planNavKey,
        ),
        NavModel(
          page: ProfilePage(
            // Pass the logout function to ProfilePage if needed
            // logoutCallback: () => _logout(context),
          ),
          navKey: profileNavKey,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // If items is empty and user is supposed to be logged in, show loading
    if (!_isLoggedIn) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If items is empty, show a loading or empty state
    if (items.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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

        // Only show bottom navigation bar if user is logged in
        bottomNavigationBar: _isLoggedIn ? NavBar(
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
        ) : null,
      ),
    );
  }
}