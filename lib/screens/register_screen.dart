import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import '../../widgets/confirm_button.dart';
import '../../widgets/text_field.dart';
import '../../providers/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false; // Toggle for password visibility
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false; // Loading indicator during registration

  Future<void> _handleRegister() async {
    // Retrieve input values
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    // Validate input fields
    if (username.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the register method from UserProvider
      await Provider.of<UserProvider>(context, listen: false)
          .register(username, password, name);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $error')),
      );
    } finally {
      // Stop loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        height: 60,
                        child: Image.asset(
                          'assets/images/back.png',
                          color: const Color(0xFFE68C52),
                          width: 42,
                        ),
                      ),
                    ),
                  ),
                  // Logo
                  SizedBox(
                    height: 60,
                    child: Image.asset('assets/images/smile.png'),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE68C52),
                    ),
                  ),
                  const Text(
                    'Please register to continue',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFA6A6A6),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Name Input Field
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Name',
                    prefixIconPath: 'assets/images/user.png',
                    showVisibilityIcon: false,
                  ),
                  const SizedBox(height: 20),
                  // Username Input Field
                  CustomTextField(
                    controller: _usernameController,
                    hintText: 'Username',
                    prefixIconPath: 'assets/images/user.png',
                    showVisibilityIcon: false,
                  ),
                  const SizedBox(height: 20),
                  // Password Input Field
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
                  const SizedBox(height: 50),
                  // Confirm Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ConfirmButton(
                              text: 'Confirm',
                              onPressed: _handleRegister,
                            ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  // Sign in link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(
                          color: Color(0xFFA6A6A6),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(
                              color: Color(0xFFE68C52),
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
