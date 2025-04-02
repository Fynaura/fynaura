import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fynaura/pages/user-session/UserSession.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fynaura/pages/goal-oriented-saving/model/Goal.dart';
import 'package:fynaura/pages/goal-oriented-saving/service/GoalService.dart';
import 'package:intl/intl.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  // Define app's color palette (matching the GoalPage)
  static const Color primaryColor = Color(0xFF254e7a);   // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);    // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);   // Light background
  static const Color whiteColor = Colors.white;          // White background

  final _formKey = GlobalKey<FormState>();
  TextEditingController _goalNameController = TextEditingController();
  TextEditingController _goalAmountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _selectedImage;
  bool _isLoading = false;

  // Instance of GoalService to call backend API
  final GoalService _goalService = GoalService();

  // No longer using suggested icons

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: source, 
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart 
        ? DateTime.now() 
        : (_startDate != null ? _startDate!.add(Duration(days: 30)) : DateTime.now().add(Duration(days: 30))),
      firstDate: isStart ? DateTime.now() : (_startDate ?? DateTime.now()),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // If end date is earlier than start date or not set, update it too
          if (_endDate == null || _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate!.add(Duration(days: 180)); // Default to 6 months
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Create New Goal',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    // Title section with icon
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle, color: whiteColor),
                          SizedBox(width: 8),
                          Text(
                            "Create Financial Goal",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    
                    // Goal Name Field
                    _buildSectionTitle('Goal Name'),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _goalNameController,
                      decoration: _buildInputDecoration('Enter your goal name', Icons.title),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a goal name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    
                    // Goal Amount Field
                    _buildSectionTitle('Target Amount'),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _goalAmountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: _buildInputDecoration('Enter amount in LKR', Icons.attach_money),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a target amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Amount must be greater than zero';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    
                    // Timeline Section
                    _buildSectionTitle('Timeline'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateSelection(
                            'Start Date',
                            _startDate,
                            () => _selectDate(context, true),
                            Icons.calendar_today,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildDateSelection(
                            'End Date',
                            _endDate,
                            () => _selectDate(context, false),
                            Icons.event,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    

                    
                    // Goal Image
                    _buildSectionTitle('Goal Image (Optional)'),
                    SizedBox(height: 10),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: lightBgColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: _selectedImage != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: kIsWeb
                                      ? Image.network(
                                          _selectedImage!.path,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white.withOpacity(0.7),
                                    radius: 15,
                                    child: IconButton(
                                      icon: Icon(Icons.close, size: 15),
                                      color: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          _selectedImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: primaryColor.withOpacity(0.7),
                                    size: 40,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Add an image for your goal',
                                    style: TextStyle(
                                      color: primaryColor.withOpacity(0.7),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        icon: Icon(Icons.photo, size: 16),
                                        label: Text('Gallery'),
                                        onPressed: () => _pickImage(ImageSource.gallery),
                                      ),
                                      SizedBox(width: 15),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        icon: Icon(Icons.camera_alt, size: 16),
                                        label: Text('Camera'),
                                        onPressed: () => _pickImage(ImageSource.camera),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(height: 30),
                    
                    // Create Goal Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: whiteColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                        ),
                        icon: _isLoading 
                            ? Container(
                                width: 20,
                                height: 20,
                                padding: EdgeInsets.all(2),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Icon(Icons.add_circle, size: 20),
                        label: Text(
                          _isLoading ? 'Creating Goal...' : 'Create Goal',
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_startDate == null || _endDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Please select start and end dates'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    final userSession = UserSession();
                                    final uid = userSession.userId ?? 'defaultUserId';
                                    
                                    // Create the Goal object
                                    Goal newGoal = Goal(
                                      name: _goalNameController.text,
                                      targetAmount: double.parse(_goalAmountController.text),
                                      startDate: _startDate!,
                                      endDate: _endDate!,
                                      image: _selectedImage?.path,
                                      userId: uid,
                                      // Initialize empty history
                                      history: [],
                                    );

                                    // Call the GoalService to create the goal
                                    Goal createdGoal = await _goalService.createGoal(newGoal);

                                    // Success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Goal successfully created!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    // Pass the created goal back to the previous screen
                                    Navigator.pop(context, createdGoal);
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to create goal: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper method to create a consistent input decoration
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: lightBgColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: accentColor,
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 16, 
        horizontal: 16,
      ),
    );
  }

  // Helper method to create date selection containers
  Widget _buildDateSelection(String title, DateTime? date, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: lightBgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: date != null ? accentColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor, size: 18),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              date != null ? _formatDate(date) : 'Select date',
              style: TextStyle(
                color: date != null ? Colors.black87 : Colors.grey,
                fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}