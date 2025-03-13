import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'transaction_category_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class TransactionDetailsPage extends StatefulWidget {
  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  bool isExpense = true;
  String selectedCategory = "Select Category";
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool reminder = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Initialize notifications with timezone support.
  void _initNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Colombo')); // Adjust to your locale

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onReminderTapped();
      },
    );
  }

  // Schedule a reminder notification for the selected date/time.
  Future<void> _scheduleReminder() async {
    bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (granted == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable notifications in settings.')),
      );
      return;
    }

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(selectedDate, tz.local);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Payment Reminder",
      "Did you pay ${amountController.text} LKR for $selectedCategory?",
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }


  // When a user taps the reminder notification, show a confirmation dialog.
  void _onReminderTapped() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Payment"),
          content: Text("Did you complete this payment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                // If confirmed, reset reminder state and add as a normal transaction.
                setState(() {
                  reminder = false;
                });
                addTransaction();
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Add a transaction or schedule a reminder.
  void addTransaction() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter an amount"),
      ));
      return;
    }
    if (selectedCategory == "Select Category") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select a category"),
      ));
      return;
    }

    if (reminder) {
      _scheduleReminder();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder Set Successfully'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Transaction Added Successfully'),
      ));
    }
    resetFields();
  }

  // Clear all input fields.
  void resetFields() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory = "Select Category";
    reminder = false;
    selectedDate = DateTime.now();
  }

  // Pick an image from camera or gallery.
  void pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    // Process the picked image here (e.g., upload or store it)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction', style: TextStyle(color: Color(0xFF9DB2CE))),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.blue),
            onPressed: addTransaction,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildToggleButton("Income", !isExpense),
                buildToggleButton("Expense", isExpense),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF85C1E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: buildModernAmountField(),
              ),
            ),
            SizedBox(height: 10),
            buildModernOptionTile("Category", Icons.toc, selectedCategory, context, true),
            buildModernDescriptionField(),
            if (isExpense)
              buildModernOptionTile(
                "Set Reminder",
                Icons.alarm,
                reminder ? DateFormat('MMMM d, y').format(selectedDate) : "Set Reminder",
                context,
                false,
              ),
            SizedBox(height: 20),
            buildCameraGalleryButtons(),
          ],
        ),
      ),
    );
  }

  // Toggle button for Income/Expense.
  Widget buildToggleButton(String text, bool selected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isExpense = text == "Expense";
          selectedCategory = "Select Category";
        });
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Color(0xFF85C1E5) : Colors.grey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Input field for amount.
  Widget buildModernAmountField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixText: "LKR ",
        hintText: "00",
        hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.grey),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  // Input field for description.
  Widget buildModernDescriptionField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: "Add Description...",
          hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.edit, color: Colors.grey.shade700),
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  // Option tile for Category selection or setting a reminder.
  Widget buildModernOptionTile(String title, IconData icon, String hint, BuildContext context, bool isCategory) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade700),
        title: Text(hint, style: TextStyle(color: Colors.black54)),
        onTap: () async {
          if (isCategory) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionCategoryPage(isExpense: isExpense)),
            );
            if (result != null) {
              setState(() => selectedCategory = result as String);
            }
          } else if (title == "Set Reminder") {
            // Select Date
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              // Select Time
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedDate),
              );

              if (pickedTime != null) {
                setState(() {
                  selectedDate = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  reminder = true;
                });
              } else {
                setState(() {
                  reminder = false;
                });
              }
            }
          }
        },
      ),
    );
  }


  // Buttons for picking an image from camera or gallery.
  Widget buildCameraGalleryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => pickImage(ImageSource.camera),
          icon: Icon(Icons.camera_alt, color: Colors.white),
          label: Text("Camera"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF85C1E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => pickImage(ImageSource.gallery),
          icon: Icon(Icons.photo, color: Colors.white),
          label: Text("Gallery"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF85C1E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}