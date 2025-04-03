import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'CustomButton.dart';
import 'customInput.dart';

class CustomPopup extends StatefulWidget {
  final Function(String, String, String) onBudgetCreated;

  CustomPopup({required this.onBudgetCreated});

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  // Consistent color palette
  static const Color primaryColor = Color(0xFF254e7a);     // Primary blue
  static const Color accentColor = Color(0xFF85c1e5);      // Light blue accent
  static const Color lightBgColor = Color(0xFFEBF1FD);     // Light background
  static const Color whiteColor = Colors.white;            // White background

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedDate = "Select a Date";

  // Validation errors
  String? _nameError;
  String? _amountError;
  String? _dateError;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: accentColor,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Validate that the selected date is not in the past
      if (pickedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
        setState(() {
          _dateError = "Cannot select a date in the past";
          _selectedDate = "Select a Date";
        });
      } else {
        setState(() {
          _selectedDate = DateFormat("dd MMM yyyy").format(pickedDate);
          _dateError = null;
        });
      }
    }
  }

  // Validation functions remain the same as in the previous implementation

  bool _validateName() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = "Budget name cannot be empty";
      });
      return false;
    } else if (_nameController.text.length < 3) {
      setState(() {
        _nameError = "Budget name must be at least 3 characters";
      });
      return false;
    } else {
      setState(() {
        _nameError = null;
      });
      return true;
    }
  }

  bool _validateAmount() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = "Budget amount cannot be empty";
      });
      return false;
    }

    try {
      double amount = double.parse(_amountController.text);
      if (amount <= 0) {
        setState(() {
          _amountError = "Amount must be greater than 0";
        });
        return false;
      } else if (amount > 1000000) {
        setState(() {
          _amountError = "Amount cannot exceed 1,000,000";
        });
        return false;
      } else {
        setState(() {
          _amountError = null;
        });
        return true;
      }
    } catch (e) {
      setState(() {
        _amountError = "Please enter a valid number";
      });
      return false;
    }
  }

  bool _validateDate() {
    if (_selectedDate == "Select a Date") {
      setState(() {
        _dateError = "Please select a date";
      });
      return false;
    } else {
      setState(() {
        _dateError = null;
      });
      return true;
    }
  }

  bool _validateAll() {
    bool nameValid = _validateName();
    bool amountValid = _validateAmount();
    bool dateValid = _validateDate();

    return nameValid && amountValid && dateValid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create a New Budget",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 18, 
                          color: whiteColor
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: whiteColor),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  "Enter the following details!",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Budget Name",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomInputField(
                  hintText: "Christmas",
                  controller: _nameController,
                ),
                if (_nameError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _nameError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),

                Text(
                  "Estimated Total Budget",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomInputField(
                  hintText: "1000",
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                ),
                if (_amountError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _amountError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 20),

                Text(
                  "Select Date",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: lightBgColor,
                      border: Border.all(
                        color: _dateError != null 
                          ? Colors.red 
                          : primaryColor.withOpacity(0.2)
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate,
                          style: TextStyle(
                            color: _selectedDate == "Select a Date" 
                              ? primaryColor.withOpacity(0.5)
                              : primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: primaryColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_dateError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _dateError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 30),

                CustomButton(
                  text: "Create Budget",
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  onPressed: () {
                    if (_validateAll()) {
                      widget.onBudgetCreated(
                        _nameController.text,
                        _amountController.text,
                        _selectedDate,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}