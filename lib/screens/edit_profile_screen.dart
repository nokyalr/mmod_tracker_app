import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/confirm_button.dart';
import '../../widgets/text_field.dart';
import '../../widgets/app_bar.dart';
import '../../providers/user_provider.dart';
import 'user_screen.dart';
import 'avatar_selector_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .updateProfile(name, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserScreen()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectAvatar() async {
    final selectedAvatar = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AvatarSelectorScreen()),
    );

    if (selectedAvatar != null && mounted) {
      Provider.of<UserProvider>(context, listen: false)
          .updateAvatar(selectedAvatar);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user['name'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        useImage: true,
        imagePath: 'assets/images/back.png',
        imageHeight: 28,
        titleText: 'Edit Profile',
        userScreen: const UserScreen(),
        useBorder: true,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFE68C52),
        imageColor: const Color(0xFFE68C52),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Avatar Selection
                      GestureDetector(
                        onTap: _selectAvatar,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            user?['profile_picture'] ??
                                'assets/images/default_profile.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: _selectAvatar,
                        child: const Text(
                          'Change Avatar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE68C52),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Name',
                        prefixIconPath: 'assets/images/user.png',
                        showVisibilityIcon: false,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIconPath: 'assets/images/padlock.png',
                        obscureText: true,
                        isPasswordVisible: _isPasswordVisible,
                        onSuffixIconPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        prefixIconPath: 'assets/images/padlock.png',
                        obscureText: true,
                        showVisibilityIcon: false,
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _isLoading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFFE68C52),
                                )
                              : ConfirmButton(
                                  text: 'Confirm',
                                  onPressed: _updateProfile,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
