import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';
// Importa aquí tu componente DynamicNetworkImage
// import 'package:leaguestats_mobile/features/home/widget/dynamic_network_image.dart';

class TeamCardWidget extends StatelessWidget {
  const TeamCardWidget({super.key, required this.url, required this.teamName});
  final String url;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      width: 120,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              // clipBehavior es vital para que el DynamicNetworkImage respete el borderRadius
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 49, 49),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ), // Espacio para que el logo no toque los bordes
                child: DynamicNetworkImage(
                  url: url,
                  fit: BoxFit
                      .contain, // Mantiene la proporción del logo sin cortarlo
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  teamName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
