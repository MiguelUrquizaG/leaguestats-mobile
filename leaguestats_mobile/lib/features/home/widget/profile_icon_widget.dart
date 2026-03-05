import 'package:flutter/material.dart';

class ProfileIconWidget extends StatelessWidget {
  final bool isPremium;
  
  const ProfileIconWidget({super.key, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(37.5),
            border: Border.all(
              width: 3,
              color: isPremium ? const Color(0xFF1d72fe) : Colors.deepPurple,
            ),
            boxShadow: [
              BoxShadow(
                color: (isPremium ? const Color(0xFF1d72fe) : Colors.deepPurple)
                    .withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage(
                'https://static.wikia.nocookie.net/leagueoflegends/images/2/27/Battle_Academia_Formal_Jayce_profileicon.png/revision/latest?cb=20190501202933',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (isPremium)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1d72fe),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1d72fe).withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}
