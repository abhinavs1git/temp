import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:temp/personal_confirm.dart';

class PersonalDetailsScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();

  PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Personal Details",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Full Name"),
                _buildTextField(TextInputType.name, (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Username must contain alphabets only.';
                  }
                  return null;
                }),
                _buildLabel("Date of Birth"),
                _buildDatePickerField(context),
                _buildLabel("Gender"),
                _buildDropdownField(["Male", "Female", "Other"]),
                _buildLabel("Phone Number"),
                _buildTextField(TextInputType.phone, (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }),
                _buildLabel("Aadhar Card Number"),
                _buildTextField(TextInputType.number, (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }),
                _buildLabel("FRN Number"),
                _buildTextField(TextInputType.number, (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }),
                _buildLabel("Panchayat Name"),
                _buildDropdownField(["Panchayat 1", "Panchayat 2", "Panchayat 3"]),
                _buildLabel("Email"),
                _buildTextField(TextInputType.emailAddress, (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }),
                _buildLabel("Farm Size"),
                _buildTextField(TextInputType.number, (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }),
                _buildLabel("Year Of Experience"),
                _buildTextField(TextInputType.number, (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity,
                          MediaQuery.of(context).size.height * 0.07),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConfirmScreen()),
                        );
                      }
                    },
                    child: const Text(
                      "Continue to Personal Details",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(TextInputType keyboardType, FormFieldValidator<String> validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _dobController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            _dobController.text = formattedDate;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (newValue) {},
        validator: (value) {
          if (value == null) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
