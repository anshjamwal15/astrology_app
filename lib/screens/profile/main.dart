import 'package:astrology_app/components/index.dart';
import 'package:astrology_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final countryController = TextEditingController();
  final bioController = TextEditingController();

  late final List<Map<String, dynamic>> profileData = [
    {
      'name': 'name',
      'key': const Key('profile_nameInput_textField'),
      'controller': nameController,
      'label': 'Name',
    },
    {
      'name': 'email',
      'key': const Key('profile_emailInput_textField'),
      'controller': emailController,
      'label': 'Email',
    },
    {
      'name': 'mobile',
      'key': const Key('profile_mobileInput_textField'),
      'controller': mobileController,
      'label': 'Mobile',
    },
    {
      'name': 'country',
      'key': const Key('profile_countryInput_textField'),
      'controller': countryController,
      'label': 'Country',
    },
    {
      'name': 'bio',
      'key': const Key('profile_bioInput_textField'),
      'controller': bioController,
      'label': 'Bio',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: AppConstants.bgColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black45,
          fontSize: size.height * 0.03,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TODO : Complete the user save image logic
              const ProfileAvatar(),
              SizedBox(height: size.height * 0.05),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: profileData.length,
                  itemBuilder: (context, index) {
                    final field = profileData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppConstants.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: CustomTextField(
                          key: field['key'],
                          controller: field['controller'],
                          keyboardType: field['name'] == 'mobile'
                              ? TextInputType.phone
                              : TextInputType.text,
                          hintText: field['label'],
                          obscureText: false,
                          disabled: field['name'] == 'email',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
