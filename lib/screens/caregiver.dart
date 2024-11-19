import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autism_app/components/custom_textfield.dart';
import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/components/common_checkbox.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:autism_app/utils/size_config.dart';

class CaregiverDonation extends StatefulWidget {
  const CaregiverDonation({super.key});

  @override
  _CaregiverDonationState createState() => _CaregiverDonationState();
}

class _CaregiverDonationState extends State<CaregiverDonation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _stayAnonymous = false;

  void _toggleAnonymous() {
    setState(() {
      _stayAnonymous = !_stayAnonymous;
    });
  }

  Future<void> _submitDonation() async {
    String amount = _amountController.text.trim();
    String name = _nameController.text.trim();

    if (amount.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Reference to the "all" document
        DocumentReference docRef = firestore.collection('donations').doc('all');

        await firestore.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(docRef);

          double totalDonations = 0.0;
          if (snapshot.exists) {
            totalDonations = snapshot['total'] ?? 0.0;
          }

          totalDonations += double.parse(amount);

          final donationData = {
            'total': totalDonations,
            // 'donations': FieldValue.arrayUnion([
            //   {
            //     'name': _stayAnonymous ? 'Anonymous' : name,
            //     'amount': double.parse(amount),
            //     'timestamp': FieldValue.serverTimestamp(),
            //   }
            // ]),
            'donations': {
              'name': _stayAnonymous ? 'Anonymous' : name,
              'amount': double.parse(amount),
              'timestamp': FieldValue.serverTimestamp(),
            }
          };

          print("Donation data being written: $donationData");

          transaction.set(docRef, donationData, SetOptions(merge: true));
        });

        _nameController.clear();
        _amountController.clear();
        Get.back();
        Get.snackbar(
          "Donation Received",
          "Thank you for your donation!",
        );
      } catch (e) {
        print("Error saving donation: $e");
        Get.snackbar(
          "Error",
          "Failed to save donation: $e",
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please enter a donation amount.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Caregiver Donation",
          fontSize: 2.0,
          weight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(widthSpace(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Enter your name:",
              fontSize: 1.8,
              weight: FontWeight.w600,
            ),
            CustomTextField(
              controller: _nameController,
              hintText: "Name",
              prefixIcon: SvgPicture.asset('assets/icons/user.svg'),
            ),
            SizedBox(height: heightSpace(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Stay anonymous",
                  fontSize: 1.8,
                ),
                CommonCheckbox(
                  isChecked: _stayAnonymous,
                  title: '',
                  checkedColor: const Color(successColor),
                  onChecked: _toggleAnonymous,
                ),
              ],
            ),
            SizedBox(height: heightSpace(3)),
            const CustomText(
              text: "Enter donation amount:",
              fontSize: 1.8,
              weight: FontWeight.w600,
            ),
            CustomTextField(
              controller: _amountController,
              hintText: "Amount in \$",
              textInputType: TextInputType.number,
              suffixIcon: const Text(
                '\$',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: heightSpace(3)),
            CommonButton(
              title: "Done",
              onPressed: _submitDonation,
              bgColor: successColor,
            ),
          ],
        ),
      ),
    );
  }
}
