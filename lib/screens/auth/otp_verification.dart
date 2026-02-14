import 'package:flutter/material.dart';
import 'package:firstreport/utils/appcolors.dart';
import 'package:firstreport/utils/fontutils.dart';
import 'package:firstreport/screens/auth/reset_password.dart';
import 'package:firstreport/services/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length < 4) {
      return 'OTP must be at least 4 digits';
    }
    return null;
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthService.verifyOtp(
        email: widget.email,
        otp: _otpController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message.isNotEmpty
                  ? response.message
                  : 'OTP verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to reset password screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: widget.email),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _isLoading) return;

    setState(() {
      _isResending = true;
    });

    try {
      final response = await AuthService.forgotPassword(
        email: widget.email,
      );

      if (mounted) {
        setState(() {
          _isResending = false;
        });

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'A new OTP has been sent. Your new OTP is: ${response.otp}',
                style: FontUtils.regular(size: 14, color: AppColors.white),
              ),
              duration: const Duration(seconds: 10),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                response.message,
                style: FontUtils.regular(size: 14, color: AppColors.white),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to resend OTP. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.screenBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.white;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDarkGrey;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textLightGrey;
    final inputBg = isDark ? AppColors.darkInputBackground : AppColors.inputBackground;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.borderUnselected;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: textPrimary,
            size: 24,
          ),
        ),
        title: Text(
          'Verify OTP',
          style: FontUtils.bold(size: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Check your email',
                    style: FontUtils.bold(
                      size: 24,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We have sent a one-time password (OTP) to ${widget.email}. Please enter it below to continue.',
                    style: FontUtils.regular(
                      size: 14,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Enter OTP',
                    style: FontUtils.bold(
                      size: 16,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: FontUtils.regular(size: 14, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter the OTP',
                        hintStyle: FontUtils.regular(size: 14, color: textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      validator: _validateOtp,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _isLoading ? null : _verifyOtp,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                ),
                              )
                            : Text(
                                'Verify & Continue',
                                style: FontUtils.bold(size: 16, color: AppColors.white),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _isResending ? null : _resendOtp,
                      child: _isResending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.gradientStart),
                              ),
                            )
                          : Text(
                              'Resend OTP',
                              style: FontUtils.bold(size: 14, color: AppColors.gradientStart),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
