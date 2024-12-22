import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Terms and Conditions for Bharat Socials',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            
            // Effective Date
            Text(
              'Effective Date: 21/12/2024',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 16),

            // Terms Content
            const Text(
              'By using Bharat Socials, you agree to comply with these terms. Please read carefully.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Sections
            _buildSectionTitle('1. Eligibility'),
            _buildSectionContent(
              'You must be at least 18 years old, or have parental consent if under 18. Users must be either a university administrator, college program officer, NGO representative, or NSS volunteer.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('2. Account Registration'),
            _buildSectionContent(
              'You agree to provide accurate information and maintain the confidentiality of your login credentials.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('3. Event Creation'),
            _buildSectionContent(
              'NGOs, university administrators, and college program officers can create and manage events. Events must be approved by admins based on institutional guidelines.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('4. Volunteer Participation'),
            _buildSectionContent(
              'Volunteers can register for events and attend them. Attendance is tracked automatically based on event duration.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('5. Attendance Tracking'),
            _buildSectionContent(
              'Attendance is tracked automatically, and both volunteers and event organizers are responsible for ensuring data accuracy.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('6. NGO Verification'),
            _buildSectionContent(
              'NGOs are verified based on credibility before hosting events on the platform.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('7. User Responsibilities'),
            _buildSectionContent(
              'Users must comply with laws, avoid disruptive behavior, and not misuse event management or attendance features.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('8. Privacy and Data Collection'),
            _buildSectionContent(
              'Personal data is collected according to our Privacy Policy. By using the app, you consent to this collection.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('9. Intellectual Property'),
            _buildSectionContent(
              'The intellectual property rights related to the App are owned by Bharat Socials.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('10. Disclaimers'),
            _buildSectionContent(
              'The app is provided "as is" and Bharat Socials is not liable for damages arising from its use.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('11. Account Termination'),
            _buildSectionContent(
              'Bharat Socials can suspend or terminate accounts for violations of these terms.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('12. Amendments'),
            _buildSectionContent(
              'Bharat Socials may update these Terms at any time, and continued use of the app signifies acceptance of the new Terms.',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('13. Governing Law'),
            _buildSectionContent(
              'These terms are governed by the laws of [Jurisdiction]. Disputes will be resolved through [arbitration/mediation].',
            ),
            _buildSectionDivider(),

            _buildSectionTitle('14. Contact Us'),
            _buildSectionContent(
              'For questions, contact us at: bharatsocials24@gmail.com',
            ),
            const SizedBox(height: 20),
            
            // Final notice
            const Text(
              'By using Bharat Socials, you acknowledge that you have read, understood, and agree to these Terms and Conditions.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  // Helper method to build section content
  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper method to build section divider
  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }
}
