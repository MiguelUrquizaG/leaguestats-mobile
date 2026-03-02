import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/news/ui/news_detail_page.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';
// Asegúrate de importar tu nuevo componente dinámico
// import 'package:leaguestats_mobile/features/home/widget/dynamic_network_image.dart';

class NewsCardWidget extends StatelessWidget {
  const NewsCardWidget({
    super.key,
    required this.id,
    required this.url,
    required this.titulo,
    required this.descripcion,
  });

  final int id;
  final String url;
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      // clipBehavior es fundamental para que la imagen de fondo respete los bordes redondeados
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black, // Color de fondo base
      ),
      child: Stack(
        children: [
          // 1. Capa de fondo: Imagen dinámica (soporta SVG y PNG/JPG)
          Positioned.fill(
            child: Opacity(opacity: 0.45, child: DynamicNetworkImage(url: url)),
          ),

          // 2. Capa de contenido: Textos y botones
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                Text(
                  descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 226, 226, 226),
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(255, 34, 34, 34),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailPage(newsId: id),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
