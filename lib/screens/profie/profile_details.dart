import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/utils/user_registration.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/utils/language_preference.dart';
import 'package:firstreport/utils/post_storage.dart';

import 'package:firstreport/services/auth_service.dart';
import 'package:firstreport/models/auth_model.dart';
import 'package:firstreport/screens/dashboard/postnews.dart';

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
  List<PostItem> _posts = [];
  UserData? _profileData;

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

  Translations? _translations;

  Future<void> _loadUserDetails() async {
    final languageCode = await LanguagePreference.getLanguageCode() ?? 'en';
    final translationResponse = await LanguageService.getTranslations(languageCode);
    final posts = await PostStorage.loadPosts();

    // Try API first
    final token = await UserRegistration.getToken();
    if (token != null && token.isNotEmpty) {
      final profileResponse = await AuthService.getProfile(token);
      if (profileResponse.success && profileResponse.user != null) {
        final profile = profileResponse.user!;
        if (mounted) {
          setState(() {
            _profileData = profile;
            userDetails = {
              'fullName': profile.name,
              'email': profile.email,
              'phone': profile.phone,
              'location': profile.location,
            };
            _translations = translationResponse.translations;
            _nameController.text = profile.name;
            _emailController.text = profile.email;
            _phoneController.text = profile.phone;
            _locationController.text = profile.location ?? 'India';
            _posts = posts;
            _isLoading = false;
          });
        }
        // Sync local
        await UserRegistration.saveRegistration(
          name: profile.name,
          email: profile.email,
          phone: profile.phone,
          token: token,
        );
        return;
      }
    }

    // Fallback
    final details = await UserRegistration.getUserDetails();
    if (mounted) {
      setState(() {
        userDetails = details;
        _translations = translationResponse.translations;
        _nameController.text = details['name'] ?? 'John Doe';
        _emailController.text = details['email'] ?? 'john.doe@example.com';
        _phoneController.text = details['phone'] ?? '+91 98765 43210';
        _locationController.text = 'Mumbai, India';
        _posts = posts;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await UserRegistration.getToken();
      if (token != null && token.isNotEmpty) {
        final response = await AuthService.updateProfile(
          token: token,
          fullName: name,
          phone: phone,
          location: location,
        );

        if (response.success) {
          // Update local storage with new info
          await UserRegistration.saveRegistration(
            name: name,
            email: email,
            phone: phone,
            token: token,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadUserDetails(); // Reload to sync state
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Fallback for non-logged in users (local only)
        await UserRegistration.saveRegistration(
          name: name,
          email: email,
          phone: phone,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated locally'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _editPost(PostItem post) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostNews(
          initialPost: post,
          onSubmitted: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );

    if (result == true) {
      final posts = await PostStorage.loadPosts();
      if (mounted) {
        setState(() {
          _posts = posts;
        });
      }
    }
  }

  Future<void> _deletePost(String id) async {
    await PostStorage.deletePost(id);
    final posts = await PostStorage.loadPosts();
    if (mounted) {
      setState(() {
        _posts = posts;
      });
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
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

    final profileDetailsLabel = _translations?.profileDetails ?? 'Profile Details';
    final memberSinceLabel = _translations?.memberSince ?? 'Member since';
    final fullNameLabel = _translations?.fullNameLabel ?? 'Full Name';
    final emailAddressLabel = _translations?.emailLabel ?? 'Email Address';
    final phoneNumberLabel = _translations?.phoneNumberLabel ?? 'Phone Number';
    final locationLabel = _translations?.india ?? 'Location';
    final postsLabel = _translations?.post ?? 'Posts';
    const readsLabel = 'Reads';
    final saveChangesLabel = _translations?.saveChanges ?? 'Save Changes';

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
            profileDetailsLabel,
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
          profileDetailsLabel,
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
              '$memberSinceLabel Oct 2024',
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
              label: fullNameLabel,
              controller: _nameController,
            ),
            _buildInfoCard(
              icon: Icons.email_outlined,
              label: emailAddressLabel,
              controller: _emailController,
            ),
            _buildInfoCard(
              icon: Icons.phone_outlined,
              label: phoneNumberLabel,
              controller: _phoneController,
            ),
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              label: locationLabel,
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
                          '${_profileData?.postsCount ?? 0}',
                          style: FontUtils.bold(
                            size: 32,
                            color: AppColors.gradientStart,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          postsLabel,
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
                          '${_profileData?.readsCount ?? 0}',
                          style: FontUtils.bold(
                            size: 32,
                            color: AppColors.gradientEnd,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          readsLabel,
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
            // My Posts section
            if (_posts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Posts',
                    style: FontUtils.bold(
                      size: 18,
                      color: textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FontUtils.bold(
                                  size: 14,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FontUtils.regular(
                                  size: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: AppColors.gradientStart,
                              ),
                              onPressed: () => _editPost(post),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _deletePost(post.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
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
                      saveChangesLabel,
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

