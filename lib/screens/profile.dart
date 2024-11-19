import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../../utils/size_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _role;
  String? _name;
  String? _age;
  //String? _profileImagePath;
  String? _gender;
  String? _height;
  String? _weight;
  String? _history;
  String? _lifestyle;
  String? _amount; // New field for amount

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      auth.User? user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not logged in');
        return;
      }

      String userId = user.uid;

      // Fetch the user’s role
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _role = userSnapshot['role']; // Get the role field
        });
        _loadProfileData(userId);
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  Future<void> _loadProfileData(String userId) async {
    try {
      String collection = (_role == 'Admin' || _role == 'Professional')
          ? 'basic_profiles'
          : 'profiles';

      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(userId)
          .get();

      if (profileSnapshot.exists) {
        setState(() {
          _name = profileSnapshot['name'];
          _age = profileSnapshot['age'];
          //_profileImagePath = profileSnapshot['profileImage'];

          if (collection == 'profiles') {
            _gender = profileSnapshot['gender'];
            _height = profileSnapshot['height'];
            _weight = profileSnapshot['weight'];
            _history = profileSnapshot['history'];
            _lifestyle = profileSnapshot['lifestyle'];
          }
        });

        if (collection == 'profiles' && _name != null) {
          await _fetchAmount();
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _fetchAmount() async {
    try {
      QuerySnapshot amountSnapshot = await FirebaseFirestore.instance
          .collection('amounts')
          .where('name', isEqualTo: _name)
          .get();

      if (amountSnapshot.docs.isNotEmpty) {
        // Sum up all amounts where name matches
        double totalAmount = 0;
        for (var doc in amountSnapshot.docs) {
          totalAmount += (doc['amount'] as num).toDouble();
        }

        setState(() {
          _amount = totalAmount.toStringAsFixed(2);
        });
      } else {
        setState(() {
          _amount = '0'; 
        });
      }
    } catch (e) {
      print('Error fetching amount: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.green, // Set green background color
                      child: Text(
                        _name != null && _name!.isNotEmpty
                            ? _name![0].toUpperCase() // First letter of the name
                            : '?', // Default placeholder if name is not set
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt_outlined, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileCard('Name', _name),
              _buildProfileCard('Age', _age),
              if (_role != 'Admin' && _role != 'Professional') ...[
                _buildProfileCard('Gender', _gender),
                _buildProfileCard('Height', '$_height cm'),
                _buildProfileCard('Weight', '$_weight kg'),
                _buildProfileCard('Medical History', _history),
                _buildProfileCard('Lifestyle', _lifestyle),
                _buildProfileCard('Amount', _amount), // New field
              ],
              SizedBox(height: heightSpace(4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.teal[800],
              ),
            ),
            Expanded(
              child: Text(
                value ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
