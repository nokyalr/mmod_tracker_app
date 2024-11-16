import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/register_screen.dart';
import '../../widgets/confirm_button.dart';
import '../../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false; // For password visibility toggle
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // For loading indicator during login

  Future<void> _handleLogin() async {
    // Retrieve input values
    final username = _usernameController.text.trim();
    final password =
        _passwordController.text.trim(); // Ensure password is a string

    // Validate input
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Perform login using UserProvider
      await Provider.of<UserProvider>(context, listen: false)
          .login(username, password);

      // Navigate to HomeScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      // Stop loading
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                // Logo at the top
                SizedBox(
                  height: 60,
                  child: Image.asset('assets/images/smile.png'),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE68C52),
                  ),
                ),
                const Text(
                  'Please login to continue',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFA6A6A6),
                  ),
                ),
                const SizedBox(height: 30),
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
                            onPressed: _handleLogin,
                          ),
                  ],
                ),
                const SizedBox(height: 100),
                // Sign Up Link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: const TextStyle(
                        color: Color(0xFFA6A6A6),
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: Color(0xFFE68C52),
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
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
      ),
    );
  }
}
