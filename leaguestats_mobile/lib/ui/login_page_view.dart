import 'package:flutter/material.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Icon(Icons.arrow_back, color: Colors.white)],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned(
              child: Image(
                image: NetworkImage(
                  'https://www.mobachampion.com/imgs/blog/best-lee-sin-skins/Lee_Sin_NightbringerSkin.jpg',
                ),
              ),
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.bottomCenter,
                    end: AlignmentGeometry.topCenter,
                    colors: [
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
            // Gradiente encima
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0),
                      const Color.fromARGB(255, 0, 0, 0),
                      const Color.fromARGB(255, 0, 0, 0),
                      const Color.fromARGB(255, 0, 0, 0), // Color inicial
                      // ignore: deprecated_member_use
                      // Se desvanece hacia la imagen
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 500,
                height: 400,
                color: Colors.red,
                child: Column(),
              ),
            ),
          ],
        ),
      ),

      // body: Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: NetworkImage(
      //         'https://www.mobachampion.com/imgs/blog/best-lee-sin-skins/Lee_Sin_NightbringerSkin.jpg',
      //       ),
      //     ),
      //     gradient: LinearGradient(
      //       begin: AlignmentGeometry.bottomCenter,
      //       end: AlignmentGeometry.topCenter,
      //       colors: <Color>[
      //         Colors.black,
      //         const Color.fromARGB(255, 61, 61, 61),
      //       ],
      //       tileMode: TileMode.mirror,
      //     ),
      //   ),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [Icon(Icons.logo_dev)],
      //   ),
      // ),
    );
  }
}
