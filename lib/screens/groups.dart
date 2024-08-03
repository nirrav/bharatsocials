import 'package:flutter/material.dart';
import 'package:bharatsocials/broadcasts/pages/domain-chat-temp.dart';

const Color defaultDomainColor = Color.fromARGB(255, 152, 220, 247);

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Domain> domains = [
      Domain(
        id: 'env',
        name: 'Environment Sustainability',
        logo: 'https://via.placeholder.com/100', // placeholder logo URL
      ),
      Domain(
        id: 'wmnemp',
        name: 'Women Empowerment',
        logo: 'https://via.placeholder.com/100', // placeholder logo URL
      ),
      Domain(
        id: 'siksha',
        name: 'Sarva Siksha',
        logo: 'https://via.placeholder.com/100', // placeholder logo URL
      ),
      Domain(
        id: 'healthHyg',
        name: 'Health and Hygiene',
        logo: 'https://via.placeholder.com/100', // placeholder logo URL
      ),
      Domain(
        id: 'animalRescue',
        name: 'Animal Rescue',
        logo: 'https://via.placeholder.com/100', // placeholder logo URL
      ),
    ];

    return Container(
      padding: EdgeInsets.zero, // Remove default padding
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: domains
                  .map((domain) => DomainCard(
                        domain: domain,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DomainChat(
                                      domainId: 'domainId',
                                      isVolunteer: false,
                                    ) //if value is true then keyboard is disabled

                                ),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class DomainCard extends StatelessWidget {
  final Domain domain;
  final VoidCallback onTap;

  const DomainCard({super.key, required this.domain, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: domain.color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: const Color.fromARGB(68, 0, 0, 0), width: 1),
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(68, 0, 0, 0),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(domain.logo),
                radius: 30,
              ),
            ),
            Expanded(
              child: Text(
                domain.name,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Domain {
  final String id;
  final String name;
  final Color color;
  final String logo;

  Domain({
    required this.id,
    required this.name,
    this.color = defaultDomainColor, // Use the constant
    required this.logo,
  });
}
