import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  double totalDonations = 0.0;
  List<Map<String, dynamic>> users = [];
  String? selectedUserId;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTotalDonations();
    fetchUsers();
  }

  // Future<void> fetchTotalDonations() async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('donations').get();
  //     double sum = snapshot.docs.fold(0.0, (total, doc) => total + (doc['amount'] != null ? (doc['amount'] as num).toDouble() : 0.0));
  //     setState(() {
  //       totalDonations = sum;

  //       print("Total donations: $totalDonations");
  //     });
  //   } catch (e) {
  //     print("Error fetching donations: $e");
  //   }
  // }

  Future<void> _fetchTotalDonations() async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('donations').doc('all');

      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        setState(() {
          totalDonations = snapshot['total'] ?? 0.0;
        });
      } else {
        setState(() {
          totalDonations = 0.0;
        });
      }
    } catch (e) {
      print("Error fetching total donations: $e");
      setState(() {
        totalDonations = 0.0;
      });
    }
  }

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profiles').get();
      List<Map<String, dynamic>> userList = snapshot.docs.map((doc) {
        return {'id': doc.id, 'name': doc['name'] ?? 'Unknown'};
      }).toList();

      setState(() {
        users = userList;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Donations Text
            Text(
              "The total donations are \$${totalDonations.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select a user:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            DropdownButton<String>(
              value: selectedUserId,
              isExpanded: true,
              hint: const Text("Select a user"),
              items: users.map((user) {
                return DropdownMenuItem<String>(
                  value: user['id'],
                  child: Text(user['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUserId = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter the amount to donate:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter amount in \$",
              ),
            ),
            const SizedBox(height: 20),
            CommonButton(
              title: 'Donate',
              bgColor: Color(successColor).value,
              onPressed: () async {
                if (selectedUserId != null && _amountController.text.isNotEmpty) {
                  double? amount = double.tryParse(_amountController.text);
                  if (amount != null && amount > 0) {
                    try {
                      FirebaseFirestore firestore = FirebaseFirestore.instance;

                      DocumentSnapshot userSnapshot = await firestore.collection('profiles').doc(selectedUserId).get();

                      if (userSnapshot.exists) {
                        String name = userSnapshot['name'];

                        DocumentReference donationsRef = firestore.collection('donations').doc('all');
                        DocumentSnapshot donationsSnapshot = await donationsRef.get();

                        if (donationsSnapshot.exists) {
                          double totalDonations = donationsSnapshot['total'] ?? 0.0;

                          if (amount > totalDonations) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Insufficient funds. Only \$${totalDonations.toStringAsFixed(2)} available.")),
                            );
                            return;
                          }

                          await firestore.runTransaction((transaction) async {
                            DocumentSnapshot donationsSnapshot = await transaction.get(donationsRef);

                            double currentTotal = donationsSnapshot['total'] ?? 0.0;
                            currentTotal -= amount;

                            transaction.set(
                              donationsRef,
                              {
                                'total': currentTotal,
                                'donations': {
                                  'name': name,
                                  'amount': amount,
                                  'timestamp': FieldValue.serverTimestamp(),
                                },
                              },
                              SetOptions(merge: true),
                            );

                            DocumentReference amountsRef = firestore.collection('amounts').doc();
                            transaction.set(amountsRef, {
                              'name': name,
                              'amount': amount,
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                          });

                          setState(() {
                            totalDonations -= amount;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Successfully donated \$${amount.toStringAsFixed(2)} to user $name."),
                            ),
                          );

                          _fetchTotalDonations();

                          // Clear fields
                          _amountController.clear();
                          setState(() {
                            selectedUserId = null;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No available funds to donate.")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Selected user not found.")),
                        );
                      }
                    } catch (e) {
                      print("Error during donation: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to process the donation.")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid amount entered.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a user and enter an amount.")),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
