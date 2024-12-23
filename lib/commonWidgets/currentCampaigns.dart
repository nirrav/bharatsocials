import 'package:flutter/material.dart';
import 'package:bharatsocials/colors.dart';
// Sample of a dynamic content class for Current Campaigns

class CurrentCampaigns extends StatelessWidget {
  const CurrentCampaigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(context, title: 'Current Campaigns'),
        const SizedBox(height: 8),
        _buildCampaignsList(),
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
              color: AppColors.defualtTextColor(context),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Placeholder for navigation logic
          },
          child: Text(
            'See More..',
            style:
                TextStyle(color: AppColors.subTextColor(context), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignsList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Campaign ${index + 1}'),
          subtitle: const Text('Detail of the campaign'),
          onTap: () {
            // Placeholder for navigating to campaign detail
          },
        );
      },
    );
  }
}
