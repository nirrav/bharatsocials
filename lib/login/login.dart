import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bharatsocials/api/login_method.dart';
// import 'package:bharatsocials/colors.dart';
// import 'package:bharatsocials/login/home.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:bharatsocials/commonWidgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDarkMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.isDarkMode,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, {required String type}) {
    if (value == null || value.isEmpty) {
      return '$type is required';
    }
    if (type == 'email' && (!value.contains('@') || !value.contains('.com'))) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Do not check login status automatically; user must log in manually
  }

  // Function to show snackbars
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Handle login
  void _onLogin() {
    LoginHelper(
      context: context,
      emailController: emailController,
      passwordController: passwordController,
      isLoading: _isLoading,
      setLoading: (bool isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
      showSnackBar: _showSnackBar,
    ).onLogin();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              label: 'Email',
              controller: emailController,
              isDarkMode: isDarkMode,
              validator: (value) => _validateField(value, type: 'email'),
              inputFormatters: [],
            ),
            TextFieldWidget(
              label: 'Password',
              controller: passwordController,
              isDarkMode: isDarkMode,
              validator: (value) => _validateField(value, type: 'password'),
              inputFormatters: [],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _onLogin();
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }
}
