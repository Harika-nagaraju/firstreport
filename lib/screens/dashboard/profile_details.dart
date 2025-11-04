import 'package:flutter/material.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/user_registration.dart';
import 'package:newsapp/main.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  Map<String, String?> userDetails = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final details = await UserRegistration.getUserDetails();
    setState(() {
      userDetails = details;
      _nameController.text = details['name'] ?? 'John Doe';
      _emailController.text = details['email'] ?? 'john.doe@example.com';
      _phoneController.text = details['phone'] ?? '+91 98765 43210';
      _locationController.text = 'Mumbai, India';
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await UserRegistration.saveRegistration(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final bgColor = isDark ? AppColors.darkInputBackground : AppColors.inputBackground;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;
    final iconColor = isDark ? AppColors.gradientStart : AppColors.gradientStart;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: FontUtils.bold(
                  size: 14,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              style: FontUtils.regular(
                size: 14,
                color: textPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: textPrimary,
                size: 20,
              ),
            ),
          ),
          title: Text(
            'Profile Details',
            style: FontUtils.bold(size: 18, color: textPrimary),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final firstName = _nameController.text.split(' ').first;
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'J';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.backgroundLightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: textPrimary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Profile Details',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Avatar
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: FontUtils.bold(
                        size: 48,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile picture upload coming soon'),
                        ),
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppColors.gradientStart,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Member since Oct 2024',
              style: FontUtils.regular(
                size: 12,
                color: textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 32),
            // Information Cards
            _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Full Name',
              controller: _nameController,
            ),
            _buildInfoCard(
              icon: Icons.email_outlined,
              label: 'Email Address',
              controller: _emailController,
            ),
            _buildInfoCard(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              controller: _phoneController,
            ),
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              label: 'Location',
              controller: _locationController,
            ),
            const SizedBox(height: 24),
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '12',
                          style: FontUtils.bold(
                            size: 32,
                            color: AppColors.gradientStart,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Posts',
                          style: FontUtils.regular(
                            size: 14,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '48',
                          style: FontUtils.bold(
                            size: 32,
                            color: AppColors.gradientEnd,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Reads',
                          style: FontUtils.regular(
                            size: 14,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Save Changes Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveChanges,
                  borderRadius: BorderRadius.circular(28),
                  child: Center(
                    child: Text(
                      'Save Changes',
                      style: FontUtils.bold(
                        size: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

