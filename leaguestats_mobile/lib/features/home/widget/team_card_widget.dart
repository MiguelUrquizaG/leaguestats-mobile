import 'package:flutter/material.dart';

class TeamCardWidget extends StatelessWidget {
  const TeamCardWidget({super.key, required this.url, required this.teamName});
  final String url;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: 120,
      height: 120,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 49, 49, 49),
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.contain,
              ),
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Text(
            teamName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
