import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome
import 'home.dart'; // Make sure to import your HomePage

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String passwordStrength = "";

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAgreed = false; // New state variable for checkbox

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    // Simple password strength checking logic
    if (password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        passwordStrength = "strong";
      });
    } else if (password.length >= 6) {
      setState(() {
        passwordStrength = "medium";
      });
    } else {
      setState(() {
        passwordStrength = "weak";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set background, text, and button colors based on the theme
    Color backgroundColor = isDarkMode ? const Color(0xFF333333) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonTextColor = isDarkMode ? Colors.black : Colors.white;

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor, // Set the background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding before pagination to ensure content isn't at the top
              SizedBox(height: screenHeight * 0.12),

              // Pagination (Dot) Indicator at the Top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Dot wrapped with GestureDetector for navigation
                    GestureDetector(
                      onTap: () {
                        // Navigate to HomePage when the first dot is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: _buildDot(isActive: false, isDarkMode: isDarkMode),
                    ),
                    _buildConnectingLine(), // Line between dots
                    _buildDot(
                        isActive: true, isDarkMode: isDarkMode), // Active dot
                    _buildConnectingLine(), // Line between dots
                    _buildDot(
                        isActive: false,
                        isDarkMode: isDarkMode), // Inactive dot
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Registration Form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REGISTER',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth > 600 ? 30 : 26,
                        fontWeight: FontWeight.w500,
                        color: textColor, // Set text color based on theme
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // First Name Field
                    _buildTextField(
                        label: 'First Name', isDarkMode: isDarkMode),
                    // Middle Name Field
                    _buildTextField(
                        label: 'Middle Name', isDarkMode: isDarkMode),
                    // Last Name Field
                    _buildTextField(label: 'Last Name', isDarkMode: isDarkMode),
                    // Phone Number Field
                    _buildTextField(label: 'Phone No', isDarkMode: isDarkMode),
                    // College Name Dropdown
                    _buildDropdownField(
                        label: 'College Name', isDarkMode: isDarkMode),
                    // Roll Number Field
                    _buildTextField(label: 'Roll No', isDarkMode: isDarkMode),
                    // Department Field
                    _buildTextField(
                        label: 'Department', isDarkMode: isDarkMode),
                    // Year Dropdown
                    _buildDropdownField(label: 'YEAR', isDarkMode: isDarkMode),
                    // Email Field
                    _buildTextField(label: 'Email', isDarkMode: isDarkMode),
                    // Create Password Field with password strength checker
                    _buildPasswordField(
                      label: 'Create A Password',
                      isDarkMode: isDarkMode,
                      controller: passwordController,
                      showStrengthIndicator: true,
                      isPasswordVisible: _isPasswordVisible,
                      togglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    // Confirm Password Field
                    _buildPasswordField(
                      label: 'Confirm Password',
                      isDarkMode: isDarkMode,
                      controller: confirmPasswordController,
                      showStrengthIndicator: false,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      togglePasswordVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    // Proof of Identity Upload Button
                    _buildUploadButton(
                        label: 'Proof Of Identity (Upload ID Card)',
                        isDarkMode: isDarkMode),

                    // Terms and Conditions Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _isTermsAgreed, // Use state variable
                          onChanged: (bool? value) {
                            setState(() {
                              _isTermsAgreed = value ?? false; // Update state
                            });
                          },
                          activeColor: buttonColor,
                        ),
                        Expanded(
                          child: Text(
                            'I Agree To Term And Condition',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: textColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Logic to show terms and conditions
                          },
                          child: Text(
                            '(READ T&C)',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth > 600 ? 16 : 14,
                              color: buttonColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Centered Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isTermsAgreed) {
                            // Submit logic here
                          } else {
                            // Show error or notification if T&C not agreed
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.15,
                            vertical: 16,
                          ),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: buttonTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a single dot
  Widget _buildDot({required bool isActive, required bool isDarkMode}) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color:
            isActive ? (isDarkMode ? Colors.white : Colors.black) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  // Method to build the line connecting dots
  Widget _buildConnectingLine() {
    return Container(
      width: 80,
      height: 2,
      color: Colors.grey,
    );
  }

  // Method to build a text field with just one line (underlined input)
  Widget _buildTextField({required String label, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            height: 1.5,
          ),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  // Method to build a password field with an eye icon to toggle visibility
  Widget _buildPasswordField({
    required String label,
    required bool isDarkMode,
    required TextEditingController controller,
    required bool showStrengthIndicator,
    required bool isPasswordVisible,
    required VoidCallback togglePasswordVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  height: 1.5,
                ),
              ),
              if (showStrengthIndicator) ...[
                SizedBox(width: 10),
                _buildPasswordStrengthDot(passwordStrength, 0),
                _buildPasswordStrengthDot(passwordStrength, 1),
                _buildPasswordStrengthDot(passwordStrength, 2),
              ]
            ],
          ),
          TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            onChanged: _checkPasswordStrength,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                height: 1.5,
              ),
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: isDarkMode ? Colors.white : Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: isDarkMode ? Colors.white : Colors.black),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: togglePasswordVisibility,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build individual password strength dots
  Widget _buildPasswordStrengthDot(String passwordStrength, int index) {
    Color color;
    if (passwordStrength == "strong") {
      color = index < 3 ? Colors.green : Colors.grey;
    } else if (passwordStrength == "medium") {
      color = index < 2 ? Colors.orange : Colors.grey;
    } else {
      color = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // Method to build the upload button
  Widget _buildUploadButton({required String label, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.white : Colors.black,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

// Method to build a dropdown field with only the border
Widget _buildDropdownField({required String label, required bool isDarkMode}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: DropdownButtonFormField<String>(
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          height: 1.5,
        ),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      items: <String>['First Year', 'Second Year', 'Third Year', 'Fourth Year']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    ),
  );
}
