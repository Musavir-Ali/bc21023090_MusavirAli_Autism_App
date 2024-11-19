import 'dart:io';
import 'package:autism_app/screens/profile.dart';
import 'package:autism_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _userName;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'User'; // Default to 'User' if no name is found
     // _profileImagePath = prefs.getString('profileImage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(widthSpace(viewPadding)),
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Hi, $_userName !', 
                          fontSize: 2,
                        ),
                        const CustomText(
                          text: 'Welcome Back',
                          fontSize: 2.9,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ProfileScreen());
                      },
                      child: UserAvatar(profileImagePath: _profileImagePath,
    userName: _userName,),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const CustomText(
                text: 'Personalized Recommendations',
                fontSize: 2.0,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Lifestyle Modifications'),
              _buildRecommendationCard(
                context,
                title: 'Healthy Eating',
                description:
                    'Incorporate more fruits, vegetables, and whole grains into your diet. '
                    'Avoid processed foods and focus on balanced meals.',
              ),
              _buildRecommendationCard(
                context,
                title: 'Sleep Hygiene',
                description:
                    'Establish a regular sleep routine. Aim for 7-9 hours of sleep per night. '
                    'Create a calming bedtime environment by reducing screen time and using relaxation techniques.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Exercise '),
              _buildRecommendationCard(
                context,
                title: 'Daily Exercise',
                description:
                    'Aim for at least 30 minutes of physical activity each day. '
                    'This can include walking, jogging, swimming, or yoga. Start small and gradually increase your activity level.',
              ),
              _buildRecommendationCard(
                context,
                title: 'Strength Training',
                description:
                    'Incorporate strength training exercises like push-ups, squats, and resistance training into your routine to build muscle and improve overall fitness.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Health & Well-being'),
              _buildRecommendationCard(
                context,
                title: 'Mindfulness & Meditation',
                description:
                    'Practice mindfulness and meditation to reduce stress and enhance focus. '
                    'Spend a few minutes each day meditating or practicing deep breathing exercises.',
              ),
              _buildRecommendationCard(
                context,
                title: 'Social Connections',
                description:
                    'Maintain strong social connections. Engage in conversations with friends and family, and join support groups or community activities to foster healthy relationships.',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Communication Skills'),
              _buildRecommendationCard(
                context,
                title: 'Effective Communication',
                description:
                    'Enhance your communication skills by practicing active listening, speaking clearly, and expressing yourself confidently. '
                    'Engage in role-play exercises or join communication workshops to improve your skills.',
              ),
              _buildRecommendationCard(
                context,
                title: 'Non-Verbal Communication',
                description:
                    'Pay attention to non-verbal cues such as body language, facial expressions, and tone of voice. '
                    'Improving non-verbal communication can help in building trust and understanding in conversations.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      text: title,
      fontSize: 1.8,
      weight: FontWeight.w600,
      color: const Color(successColor),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSize: 1.8,
              weight: FontWeight.bold,
              color: const Color(successColor),
            ),
            const SizedBox(height: 8),
            CustomText(
              text: description,
              fontSize: 1.6,
            ),
          ],
        ),
      ),
    );
  }
}
 
class UserAvatar extends StatelessWidget {
  final String? profileImagePath;
  final String? userName;

  const UserAvatar({super.key, this.profileImagePath, this.userName});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30, 
      backgroundColor: Colors.green, 
      child: userName != null && userName!.isNotEmpty
          ? Text(
              userName![0].toUpperCase(), 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0, 
                fontWeight: FontWeight.bold,
              ),
            )
          : const Icon(
              Icons.person,
              size: 24,
              color: Colors.white,
            ),
    );
  }
}
