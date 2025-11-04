import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/user_registration.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Save registration details
      await UserRegistration.saveRegistration(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate back to Post News screen
        Navigator.of(context).pop(true);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textDarkGrey,
            size: 24,
          ),
        ),
        title: Text(
          'Registration',
          style: FontUtils.bold(size: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Header Text
                Text(
                  'Personal Details',
                  style: FontUtils.bold(
                    size: 24,
                    color: AppColors.textDarkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide your details to post news',
                  style: FontUtils.regular(
                    size: 14,
                    color: AppColors.textLightGrey,
                  ),
                ),
                const SizedBox(height: 32),
                // Name Field
                Text(
                  'Full Name',
                  style: FontUtils.bold(
                    size: 16,
                    color: AppColors.textDarkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.borderUnselected,
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: FontUtils.regular(
                        size: 14,
                        color: AppColors.textLightGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: FontUtils.regular(
                      size: 14,
                      color: AppColors.textDarkGrey,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Email Field
                Text(
                  'Email',
                  style: FontUtils.bold(
                    size: 16,
                    color: AppColors.textDarkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.borderUnselected,
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: FontUtils.regular(
                        size: 14,
                        color: AppColors.textLightGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: FontUtils.regular(
                      size: 14,
                      color: AppColors.textDarkGrey,
                    ),
                    validator: _validateEmail,
                  ),
                ),
                const SizedBox(height: 24),
                // Phone Field
                Text(
                  'Phone Number',
                  style: FontUtils.bold(
                    size: 16,
                    color: AppColors.textDarkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.borderUnselected,
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      hintStyle: FontUtils.regular(
                        size: 14,
                        color: AppColors.textLightGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: FontUtils.regular(
                      size: 14,
                      color: AppColors.textDarkGrey,
                    ),
                    validator: _validatePhone,
                  ),
                ),
                const SizedBox(height: 32),
                // Register Button
                GestureDetector(
                  onTap: _isLoading ? null : _register,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _isLoading ? null : AppColors.buttonGradient,
                      color: _isLoading ? AppColors.disabledButton : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Register',
                              style: FontUtils.bold(
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

