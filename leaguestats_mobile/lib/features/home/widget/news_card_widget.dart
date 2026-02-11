import 'package:flutter/material.dart';

class NewsCardWidget extends StatelessWidget {
  const NewsCardWidget({
    super.key,
    required this.url,
    required this.titulo,
    required this.descripcion,
  });
  final String url;
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(opacity: 0.45, image: NetworkImage(url)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              titulo,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            Text(
              descripcion,
              style: TextStyle(
                color: const Color.fromARGB(255, 226, 226, 226),
                fontSize: 16,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 34, 34, 34),
                    ),
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
