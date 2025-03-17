import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'GoalPage.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _goalNameController = TextEditingController();
  TextEditingController _goalAmountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? DateTime.now() : _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF254e7a),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFF254e7a)),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20), // Adjust the top margin for better spacing
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8), // Add a little space between icon and text
                        Text(
                          'Add New Goal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Goal Name Field
                    Text(
                      'Goal Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF254e7a).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _goalNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Enter a goal name',
                          labelStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFF85c1e5),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goal name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    // Goal Amount Field
                    Text(
                      'Goal Amount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF254e7a).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _goalAmountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Enter a goal amount',
                          labelStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFF85c1e5),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a goal amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 15,
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timeline',
                            style: TextStyle(
                              color: Color(0xFF254e7a),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context, true),
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF254e7a).withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.only(right: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Color(0xFF254e7a),
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Start Date',
                                              style: TextStyle(
                                                color: Color(0xFF85c1e5),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          _startDate != null
                                              ? '${_startDate!.day}.${_startDate!.month}.${_startDate!.year}'
                                              : 'Select Date',
                                          style: TextStyle(
                                            color: _startDate != null ? Colors.black : Color(0xFF85c1e5),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context, false),
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF254e7a).withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Color(0xFF254e7a),
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'End Date',
                                              style: TextStyle(
                                                color: Color(0xFF85c1e5),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text(
                                          _endDate != null
                                              ? '${_endDate!.day}.${_endDate!.month}.${_endDate!.year}'
                                              : 'Select Date',
                                          style: TextStyle(
                                            color: _endDate != null ? Colors.black : Color(0xFF85c1e5),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Visual Reference',
                            style: TextStyle(
                              color: Color(0xFF254e7a),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF254e7a).withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.photo_library,
                                    color: Color(0xFF254e7a),
                                    size: 28,
                                  ),
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF254e7a),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: _selectedImage != null
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: kIsWeb
                                          ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                                    )
                                        : Center(
                                      child: Text(
                                        'Add Image',
                                        style: TextStyle(
                                          color: Color(0xFF85c1e5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFF254e7a),
                                    size: 28,
                                  ),
                                  onPressed: () => _pickImage(ImageSource.camera),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF254e7a),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                                shadowColor: Color(0xFF254e7a).withOpacity(0.3),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_startDate == null || _endDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Please select start and end dates")),
                                    );
                                    return;
                                  }
                                  // Create the Goal object
                                  Goal newGoal = Goal(
                                    name: _goalNameController.text,
                                    targetAmount: double.parse(_goalAmountController.text),
                                    startDate: _startDate!,
                                    endDate: _endDate!,
                                    image: _selectedImage?.path,
                                  );


                                  // Pass the created goal back to the previous screen
                                  Navigator.pop(context, newGoal);
                                }
                              },
                              child: Text(
                                'Add Goal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
