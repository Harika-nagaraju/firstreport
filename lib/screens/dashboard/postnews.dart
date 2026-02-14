import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/utils/user_registration.dart';
import 'package:firstreport/utils/post_storage.dart';
import 'package:firstreport/widgets/dashed_border.dart';
import 'package:firstreport/services/news_service.dart';
import 'package:firstreport/services/upload_service.dart';
import 'package:firstreport/services/language_service.dart';
import 'package:firstreport/screens/dashboard/pending_screen.dart';
import 'package:firstreport/models/language_api_model.dart';
import 'package:firstreport/utils/language_preference.dart';
import 'package:firstreport/screens/auth/login.dart';

class PostNews extends StatefulWidget {
  final VoidCallback? onSubmitted;
  final PostItem? initialPost;

  const PostNews({super.key, this.onSubmitted, this.initialPost});

  @override
  State<PostNews> createState() => _PostNewsState();
}

class _PostNewsState extends State<PostNews> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  XFile? _selectedMedia;
  Uint8List? _selectedMediaBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isRegistered = false;
  bool _isLoading = true;
  String? _editingPostId;
  Translations? _translations;
  String? _selectedCategory;
  bool _isAiCorrecting = false;
  bool _isSubmitting = false;
  String _languageCode = 'en';

  final List<String> _categoryKeys = [
    'india',
    'international',
    'current_affairs',
    'health',
    'tech',
  ];

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
    _loadTranslations();
    _titleController.addListener(_checkFormValidity);
    _descriptionController.addListener(_checkFormValidity);

    // If editing an existing post, pre-fill fields
    final initial = widget.initialPost;
    if (initial != null) {
      _editingPostId = initial.id;
      _titleController.text = initial.title;
      _descriptionController.text = initial.description;
      _urlController.text = initial.url ?? '';
      _selectedCategory = initial.category;
    }
  }

  Future<void> _loadTranslations() async {
    final languageCode = await LanguagePreference.getLanguageCode() ?? 'en';
    final response = await LanguageService.getTranslations(languageCode);
    if (mounted) {
      setState(() {
        _languageCode = languageCode;
        _translations = response.translations;
      });
    }
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
        _selectedCategory != null &&
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
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedMedia = image;
          _selectedMediaBytes = bytes;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _correctDescription() async {
    if (_descriptionController.text.trim().isEmpty) return;

    setState(() => _isAiCorrecting = true);
    
    // Simulate AI delay
    await Future.delayed(const Duration(seconds: 1));
    
    String text = _descriptionController.text.trim();
    if (text.isNotEmpty) {
      // Very basic AI "correction" simulation: Capitalize and add period if missing
      text = text[0].toUpperCase() + text.substring(1);
      if (!text.endsWith('.') && !text.endsWith('!') && !text.endsWith('?')) {
        text += '.';
      }
    }
    
    setState(() {
      _descriptionController.text = text;
      _isAiCorrecting = false;
    });
  }

  Future<void> _submitNews() async {
    if (!_isFormValid) {
      if (!_isNewsFormValid) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all news details and upload media'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      return;
    }

    setState(() => _isSubmitting = true);

    String? finalImagePath;
    if (_selectedMedia != null) {
      finalImagePath = _selectedMedia!.path;
    } else if (widget.initialPost?.imagePath != null && widget.initialPost!.imagePath!.isNotEmpty) {
      finalImagePath = widget.initialPost!.imagePath!;
    }

    if (finalImagePath == null) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    String correctedTitle = _titleController.text.trim();
    if (correctedTitle.isNotEmpty) {
      correctedTitle = correctedTitle[0].toUpperCase() + correctedTitle.substring(1);
    }
    
    final result = await NewsService.postNews(
      title: correctedTitle,
      content: _descriptionController.text.trim(),
      category: _selectedCategory!,
      language: _languageCode,
      imagePath: finalImagePath,
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear news fields after submission
        _titleController.clear();
        _descriptionController.clear();
        _urlController.clear();
        setState(() {
          _selectedMedia = null;
          _selectedMediaBytes = null;
          _selectedCategory = null;
        });

        // Notify parent (Dashboard) so it can navigate to Home tab
        if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        }
      } else {
        // Handle pending restriction from backend
        if (result['hasPending'] == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PendingScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;
    final inputBackground =
        isDark ? AppColors.darkInputBackground : AppColors.inputBackground;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.borderUnselected;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          _translations?.post ?? 'Post News',
          style: FontUtils.bold(size: 18, color: primaryText),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : !_isRegistered
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle_outlined,
                            size: 80,
                            color: secondaryText.withOpacity(0.5),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _translations?.dontHaveAccount ?? 'Login to Post News',
                            textAlign: TextAlign.center,
                            style: FontUtils.bold(
                              size: 20,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You need an account to submit news reports and use AI features.',
                            textAlign: TextAlign.center,
                            style: FontUtils.regular(
                              size: 14,
                              color: secondaryText,
                            ),
                          ),
                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                              if (result == true) {
                                _checkRegistrationStatus();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gradientStart.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _translations?.login ?? 'Login / Register',
                                  style: FontUtils.bold(size: 16, color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Category Section
                        Text(
                          'Category',
                          style: FontUtils.bold(
                            size: 16,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              hint: Text(
                                'Select Category',
                                style: FontUtils.regular(
                                  size: 14,
                                  color: secondaryText,
                                ),
                              ),
                              dropdownColor: cardColor,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down, color: primaryText),
                              items: _categoryKeys.map((String key) {
                                String label = key;
                                if (_translations != null) {
                                  // Map keys to translated strings
                                  if (key == 'india') label = _translations!.india;
                                  else if (key == 'international') label = _translations!.international;
                                  else if (key == 'current_affairs') label = _translations!.currentAffairs;
                                  else if (key == 'health') label = _translations!.health;
                                  else if (key == 'tech') label = _translations!.tech;
                                }
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(
                                    label,
                                    style: FontUtils.regular(
                                      size: 14,
                                      color: primaryText,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                                _checkFormValidity();
                              },
                            ),
                          ),
                        ),
              const SizedBox(height: 24),
              // Title Section
                        Text(
                          'Title',
                          style: FontUtils.bold(
                            size: 16,
                            color: primaryText,
                          ),
                        ),
              const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter news title...',
                            hintStyle: FontUtils.regular(
                              size: 14,
                              color: secondaryText,
                            ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                          style: FontUtils.regular(
                            size: 14,
                            color: primaryText,
                          ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 24),
                        // Description Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Description',
                              style: FontUtils.bold(
                                size: 16,
                                color: primaryText,
                              ),
                            ),
                            if (_isRegistered)
                              GestureDetector(
                                onTap: _isAiCorrecting ? null : _correctDescription,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      if (_isAiCorrecting)
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else
                                        const Icon(Icons.auto_awesome, size: 14, color: AppColors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        'AI Fix',
                                        style: FontUtils.bold(size: 11, color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
              const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write your news story...',
                            hintStyle: FontUtils.regular(
                              size: 14,
                              color: secondaryText,
                            ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                          style: FontUtils.regular(
                            size: 14,
                            color: primaryText,
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
                            color: primaryText,
                          ),
                        ),
              const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
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
                              color: secondaryText,
                            ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                          style: FontUtils.regular(
                            size: 14,
                            color: primaryText,
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
                  color: primaryText,
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
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.uploadAreaBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedMedia != null && _selectedMediaBytes != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  _selectedMediaBytes!,
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
                                      _selectedMediaBytes = null;
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
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.verificationBanner,
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
                        'Tap "AI Fix" to enhance your story description with AI.',
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
              // Submit Button
              GestureDetector(
                onTap: _isFormValid && !_isSubmitting ? _submitNews : null,
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
                    child: _isSubmitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            _translations?.post ?? 'Submit News',
                            style: FontUtils.bold(
                              size: 16,
                              color: _isFormValid
                                  ? AppColors.white
                                  : secondaryText,
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
