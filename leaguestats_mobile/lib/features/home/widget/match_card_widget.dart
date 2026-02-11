import 'package:flutter/material.dart';

class MatchCardWidget extends StatelessWidget {
  const MatchCardWidget({
    super.key,
    required this.iconoLiga,
    required this.nombreEquipo1,
    required this.nombreEquipo2,
    required this.paisLiga,
    required this.urlBandera,
  });

  final String iconoLiga;
  final String nombreEquipo1;
  final String nombreEquipo2;
  final String paisLiga;
  final String urlBandera;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blueAccent,width: 2))),
        width: 200,
        height: 80,
        child: Row(
          children: [
            Container(
              width: 80,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(image: NetworkImage(iconoLiga)),
                border: Border.all(width: 1, color: Colors.transparent),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$nombreEquipo1 vs $nombreEquipo2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 30,
                    child: Row(
                      children: [
                        Image(
                          image: NetworkImage(urlBandera),
                          fit: BoxFit.contain,
                          width: 30,
                        ),
                        Text(
                          paisLiga,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 80, 80, 80),
                  border: Border.all(width: 1, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(onPressed: null, child: Text('Acceder',style: TextStyle(color: Colors.white),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
