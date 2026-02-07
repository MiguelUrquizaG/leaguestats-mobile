import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/widget/champ_card_widget.dart';
import 'package:leaguestats_mobile/widget/news_card_widget.dart';
import 'package:leaguestats_mobile/widget/profile_icon_widget.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  ProfileIconWidget(),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NombreUsuario',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Row(
                        children: [
                          Text('País', style: TextStyle(color: Colors.white)),
                          SizedBox(width: 20),
                          Image(
                            image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Flag_of_South_Korea.svg/1280px-Flag_of_South_Korea.svg.png',
                            ),
                            width: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Noticias destacas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 500,
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(5),
                  children: [
                    NewsCardWidget(
                      url:
                          'https://i.ytimg.com/vi/INJIThRXsFc/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLACIdaULzS9vslgyuXE3t3L0wPHlw',
                      titulo: 'Koi gana',
                      descripcion: 'Increible victoria del conjunto español',
                    ),
                    NewsCardWidget(
                      url:
                          'https://i.ytimg.com/vi/BdlL0jr4cvY/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAD5iscoPKbGDL4TVp79_JfYGsR6g',
                      titulo: 'G2 pierde',
                      descripcion: 'Dominio Coreano',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Campeones',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView(
                  padding: const EdgeInsets.only(right: 10),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChampCardWidget(
                      url:
                          'https://www.lolvvv.com/_next/image?url=https%3A%2F%2Fddragon.leagueoflegends.com%2Fcdn%2Fimg%2Fchampion%2Fsplash%2FEzreal_33.jpg&w=1200&q=75',
                          nombre: 'Ezreal',
                          apodo: 'Aventurero de Piltover',
                    ),
                    ChampCardWidget(
                      url:
                          'https://www.lolvvv.com/_next/image?url=https%3A%2F%2Fddragon.leagueoflegends.com%2Fcdn%2Fimg%2Fchampion%2Fsplash%2FEzreal_33.jpg&w=1200&q=75',
                          nombre: 'Ezreal',
                          apodo: 'Aventurero de Piltover',
                    ),
                    ChampCardWidget(
                      url:
                          'https://www.lolvvv.com/_next/image?url=https%3A%2F%2Fddragon.leagueoflegends.com%2Fcdn%2Fimg%2Fchampion%2Fsplash%2FEzreal_33.jpg&w=1200&q=75',
                          nombre: 'Ezreal',
                          apodo: 'Aventurero de Piltover',
                    ),
                    ChampCardWidget(
                      url:
                          'https://www.lolvvv.com/_next/image?url=https%3A%2F%2Fddragon.leagueoflegends.com%2Fcdn%2Fimg%2Fchampion%2Fsplash%2FEzreal_33.jpg&w=1200&q=75',
                          nombre: 'Ezreal',
                          apodo: 'Aventurero de Piltover',
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
