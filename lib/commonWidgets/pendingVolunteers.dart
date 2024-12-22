import 'package:flutter/material.dart';

// Sample of a dynamic content class for Pending Volunteers

class PendingVolunteers extends StatelessWidget {
  const PendingVolunteers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(context, title: 'Pending Volunteers'),
        const SizedBox(height: 8),
        _buildVolunteersList(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.deepPurple[700],
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Placeholder for navigation logic
          },
          child: const Text(
            'See More..',
            style: TextStyle(color: Colors.deepPurple, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteersList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Volunteer ${index + 1}'),
          subtitle: const Text('Details about the volunteer'),
          onTap: () {
            // Placeholder for navigating to volunteer details
          },
        );
      },
    );
  }
}
