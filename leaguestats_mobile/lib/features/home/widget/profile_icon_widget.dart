import 'package:flutter/material.dart';

class ProfileIconWidget extends StatelessWidget {
  const ProfileIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: BoxBorder.all(width: 3,color: Colors.deepPurple),
        image: DecorationImage(
          image: NetworkImage(
            'https://static.wikia.nocookie.net/leagueoflegends/images/2/27/Battle_Academia_Formal_Jayce_profileicon.png/revision/latest?cb=20190501202933',
          ),
        ),
      ),
    );
  }
}
