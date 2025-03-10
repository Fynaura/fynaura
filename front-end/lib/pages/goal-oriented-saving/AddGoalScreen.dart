import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF254e7a),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Goal', style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Goal Name
              TextFormField(
                controller: _goalNameController,
                decoration: InputDecoration(
                  labelText: 'Goal Name',
                  labelStyle: TextStyle(color: Color(0xFF254e7a)),
                  hintText: 'Car, House, Vacation, etc.',
                  hintStyle: TextStyle(color: Color(0xFF85c1e5)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF254e7a)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF85c1e5)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Goal Amount
              TextFormField(
                controller: _goalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Goal Amount',
                  labelStyle: TextStyle(color: Color(0xFF254e7a)),
                  hintText: '10, 500, 1500, 2000',
                  hintStyle: TextStyle(color: Color(0xFF85c1e5)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF254e7a)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF85c1e5)),
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

              SizedBox(height: 20),

              // Date Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: TextStyle(color: Color(0xFF254e7a)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFF254e7a),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFF85c1e5)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _startDate != null
                                      ? '${_startDate!.day}.${_startDate!.month}.${_startDate!.year}'
                                      : 'Select Start Date',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Spacer(),
                                Icon(Icons.calendar_today, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFF254e7a),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFF85c1e5)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _endDate != null
                                      ? '${_endDate!.day}.${_endDate!.month}.${_endDate!.year}'
                                      : 'Select End Date',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Spacer(),
                                Icon(Icons.calendar_today, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Image Upload
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_library, color: Color(0xFF254e7a)),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF254e7a)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                          : Center(
                        child: Text(
                          'Add Image',
                          style: TextStyle(color: Color(0xFF85c1e5)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Color(0xFF254e7a)),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Add Goal Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF254e7a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the goal creation
                      print('Goal created:');
                      print('Name: ${_goalNameController.text}');
                      print('Amount: ${_goalAmountController.text}');
                      print('Start Date: $_startDate');
                      print('End Date: $_endDate');
                      print('Image: ${_selectedImage?.path}');

                      // Add your goal saving logic here
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Add Goal',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}