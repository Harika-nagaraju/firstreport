import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/utils/appcolors.dart';
import 'package:newsapp/utils/fontutils.dart';
import 'package:newsapp/utils/user_registration.dart';
import 'package:newsapp/widgets/dashed_border.dart';

class PostNews extends StatefulWidget {
  const PostNews({super.key});

  @override
  State<PostNews> createState() => _PostNewsState();
}

class _PostNewsState extends State<PostNews> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  File? _selectedMedia;
  final ImagePicker _picker = ImagePicker();
  bool _isRegistered = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
    _titleController.addListener(_checkFormValidity);
    _descriptionController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _checkRegistrationStatus() async {
    final registered = await UserRegistration.isRegistered();
    if (mounted) {
      setState(() {
        _isRegistered = registered;
        _isLoading = false;
      });
    }
  }

  void _checkFormValidity() {
    setState(() {});
  }

  bool get _isNewsFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _selectedMedia != null;
  }

  bool get _isFormValid {
    // Only need news fields if registered
    return _isRegistered && _isNewsFormValid;
  }

  Future<void> _pickMedia() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _selectedMedia = File(image.path);
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _submitNews() async {
    if (!_isFormValid) {
      if (!_isNewsFormValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all news details and upload media'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      return;
    }

    // Get user details from registration
    final userDetails = await UserRegistration.getUserDetails();
    final name = userDetails['name'] ?? 'User';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('News submitted successfully by $name!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear news fields after submission
    _titleController.clear();
    _descriptionController.clear();
    _urlController.clear();
    setState(() {
      _selectedMedia = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Post News',
          style: FontUtils.bold(size: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : !_isRegistered
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.textLightGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Please register first',
                          style: FontUtils.bold(
                            size: 18,
                            color: AppColors.textDarkGrey,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // News Details Section
              Text(
                'News Details',
                style: FontUtils.bold(
                  size: 20,
                  color: AppColors.textDarkGrey,
                ),
              ),
              const SizedBox(height: 24),
              // Title Section
              Text(
                'Title',
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
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter news title...',
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
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 24),
              // Description Section
              Text(
                'Description',
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
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write your news story...',
                    hintStyle: FontUtils.regular(
                      size: 14,
                      color: AppColors.textLightGrey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: FontUtils.regular(
                    size: 14,
                    color: AppColors.textDarkGrey,
                  ),
                  maxLines: 6,
                ),
              ),
              const SizedBox(height: 24),
              // URL Section (Optional)
              Text(
                'URL (Optional)',
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
                child: TextField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Enter news URL (optional)...',
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
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 24),
              // Upload Media Section
              Text(
                'Upload Media',
                style: FontUtils.bold(
                  size: 16,
                  color: AppColors.textDarkGrey,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickMedia,
                child: DashedBorder(
                  color: AppColors.uploadAreaBorder,
                  strokeWidth: 2,
                  borderRadius: 12,
                  dashWidth: 8,
                  dashSpace: 4,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.uploadAreaBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedMedia != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedMedia!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedMedia = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: AppColors.uploadAreaBorder,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Upload Photo or Video',
                                style: FontUtils.bold(
                                  size: 16,
                                  color: AppColors.uploadAreaBorder,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap to select file',
                                style: FontUtils.regular(
                                  size: 12,
                                  color: AppColors.uploadAreaBorder.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Verification Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.verificationBanner,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.verificationText,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your post will be verified by AI before publishing',
                        style: FontUtils.regular(
                          size: 14,
                          color: AppColors.verificationText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Submit Button
              GestureDetector(
                onTap: _isFormValid ? _submitNews : null,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _isFormValid
                        ? AppColors.buttonGradient
                        : null,
                    color: _isFormValid
                        ? null
                        : AppColors.disabledButton,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Submit News',
                      style: FontUtils.bold(
                        size: 16,
                        color: _isFormValid
                            ? AppColors.white
                            : AppColors.textLightGrey,
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
    );
  }
}
