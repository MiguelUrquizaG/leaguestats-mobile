import 'package:flutter/material.dart';

class ChampCardWidget extends StatelessWidget {
  const ChampCardWidget({super.key,required this.url,required this.nombre,required this.apodo});

  final String url;
  final String nombre;
  final String apodo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(
                  url,
                ),
                fit: BoxFit.cover,
                alignment: Alignment(0.5, 0),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text(nombre, style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
          Text(apodo, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
