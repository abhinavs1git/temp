// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:temp/bank_confirm.dart';
import 'select_bank.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  String selectedBank = '';
  final _formKey = GlobalKey<FormState>();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _reenterAccountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.green,
        title: const Text('Bank Details',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600)),
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.05,
            vertical: mediaQuery.size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: mediaQuery.size.height * 0.02),
                const Text(
                    '  Enter your bank account details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: mediaQuery.size.height * 0.04),
                Text(
                  '   Enter details carefully to avoid verification failure',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.grey[500]),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                const Text(
                  ' Select your bank',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectBank()),
                    );
                    if (result != null) {
                      setState(() {
                        selectedBank = result;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedBank.isEmpty ? 'Select Your Bank' : selectedBank,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.arrow_right_rounded),
                      ],
                    ),
                  ),
                ),
                if (selectedBank.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Bank selection is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                TextFormField(
                  controller: _accountHolderNameController,
                  decoration: InputDecoration(
                    labelText: "Account Holder's Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.04,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Account Holder's Name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(16)
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.04,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account Number is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                TextFormField(
                  controller: _reenterAccountNumberController,
                  decoration: InputDecoration(
                    labelText: 'Re-enter Account Number',
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(16)
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.04,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Re-entering Account Number is required';
                    }
                    if (value != _accountNumberController.text) {
                      return 'Account Numbers do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                TextFormField(
                  controller: _ifscCodeController,
                  decoration: InputDecoration(
                    labelText: 'IFSC Code',
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(16)
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.02,
                      horizontal: mediaQuery.size.width * 0.04,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'IFSC Code is required';
                    }
                    if (!RegExp(r'^[A-Za-z]{4}\d{7}$').hasMatch(value)) {
                      return 'Invalid IFSC Code format';
                    }
                    return null;
                  },
                ),
                SizedBox(height: mediaQuery.size.height * 0.13),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedBank.isEmpty) {
                        setState(() {});
                      } else {
                        if (_formKey.currentState!.validate()) {
                             Navigator.push(
                        context,
                         MaterialPageRoute(
                              builder: (context) => const BankConfirmScreen()),
                      );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.07),
                    ),
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
