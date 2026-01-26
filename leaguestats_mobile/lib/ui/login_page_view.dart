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
              child: SizedBox(
                width: 500,
                height: 400,
              
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(123, 158, 158, 158),
                          labelText: 'Correo Electrónico',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 50),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Introduzca su contraseña',
                          hintStyle: TextStyle(color: Colors.white),
                          
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Contraseña',
                          filled: true,
                          fillColor: const Color.fromARGB(123, 158, 158, 158),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      
                      ClipRRect(  
                        borderRadius: BorderRadiusGeometry.circular(6),
                        child: Container(
                          width: 400,
                          height: 70,
                          color: const Color.fromRGBO(139, 0, 255, 1),
                          child: TextButton(
                            onPressed: null,
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(
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
                ),
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
