import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fynaura/pages/add-transactions/transaction_detail_page.dart';

class NavBar extends StatelessWidget {
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
        left: 0,
        right: 0,
        bottom: 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // Set the top left corner radius
          topRight: Radius.circular(20), // Set the top right corner radius
        ),
        child: BottomAppBar(
          elevation: 0.0,
          color: Colors.white, // Set the BottomAppBar to blue
          child: Container(
            height: 60,
            child: Row(
              children: [
                navItem(
                  CupertinoIcons.home,
                  pageIndex == 0,
                  onTap: () => onTap(0),
                  label: 'Home',
                ),
                navItem(
                  Icons.analytics,
                  pageIndex == 1,
                  onTap: () => onTap(1),
                  label: 'Analytics',
                ),
                // Spacer to position the FloatingActionButton in the center
                FloatingActionButton(
                  onPressed: () {
                    // Navigate to the TransactionDetailsPage when pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailsPage(),
                      ),
                    );
                  },
                  backgroundColor: Color(0xFF254e7a),
                  elevation: 7.5,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 3, color: Color(0xFF254e7a)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                // Spacer to balance the layout
                navItem(
                  CupertinoIcons.calendar_today,
                  pageIndex == 2,
                  onTap: () => onTap(2),
                  label: 'Plan',
                ),
                navItem(
                  CupertinoIcons.person,
                  pageIndex == 3,
                  onTap: () => onTap(3),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap, required String label}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Color(0xFF254e7a) : Color(0xFF254e7a).withOpacity(0.4),
        ),
      ),
    );
  }
}
