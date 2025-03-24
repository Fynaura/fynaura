import 'package:flutter/material.dart';
import 'package:fynaura/pages/ocr/ImagePreviewScreen.dart';
import 'package:fynaura/pages/ocr/ImageSelectionOption.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'transaction_category_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:fynaura/services/transaction_service.dart';

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

  void _initNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Colombo'));

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

  Future<void> _scheduleReminder() async {
    bool? granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
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
      "Did you pay ${amountController.text} for $selectedCategory?",
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

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
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
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

  void addTransaction() async {
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

    final transactionService = TransactionService();
    final type = isExpense ? "expense" : "income";

    final userSession = UserSession();
    final uid = userSession.userId;

    try {
      await transactionService.createTransaction(
        type: type,
        category: selectedCategory,
        amount: double.parse(amountController.text),
        description: descriptionController.text,
        date: selectedDate,
        uid: uid,
      );

      if (reminder) {
        await _scheduleReminder();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Reminder Set Successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Color(0xFF254e7a),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Transaction Added Successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Color(0xFF254e7a),
          ),
        );
      }

      resetFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  void resetFields() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory = "Select Category";
    reminder = false;
    selectedDate = DateTime.now();
  }

  void pickImageAndNavigate(ImageSource source) async {
    final pickedImage = source == ImageSource.camera
        ? await ImageSelectionOption.pickImageFromCamera()
        : await ImageSelectionOption.pickImageFromGallery();

    if (pickedImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(image: pickedImage),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No image selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF254e7a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.white),
            onPressed: addTransaction,
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF254e7a),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              SizedBox(height: 10),
              buildModernAmountField(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildToggleButton("Income", !isExpense),
                  SizedBox(width: 15),
                  buildToggleButton("Expense", isExpense),
                ],
              ),
              SizedBox(height: 30),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
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
                      buildCameraGalleryButtons(),  // Gallery and Camera buttons inside the white card
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToggleButton(String text, bool selected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isExpense = text == "Expense";
          selectedCategory = "Select Category";
        });
      },
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF254e7a)),  // Changed color for "Income" and "Expense"
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFF85c1e5) : Color(0xFFEBF1FD),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget buildModernAmountField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        hintText: "00",
        hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.grey),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget buildModernDescriptionField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFEBF1FD),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: "Add Description",
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF254e7a)),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.edit, color: Color(0xFF254e7a)),
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildModernOptionTile(String title, IconData icon, String hint, BuildContext context, bool isCategory) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color:Color(0xFFEBF1FD),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF254e7a)),
        title: Text(
          hint,
          style: TextStyle(color: Color(0xFF254e7a)),
        ),
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
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
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

  Widget buildCameraGalleryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => pickImageAndNavigate(ImageSource.camera),
          icon: Icon(Icons.camera_alt, color: Colors.white),
          label: Text("Camera", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF254e7a),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => pickImageAndNavigate(ImageSource.gallery),
          icon: Icon(Icons.photo, color: Colors.white),
          label: Text("Gallery", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF254e7a),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }
}
