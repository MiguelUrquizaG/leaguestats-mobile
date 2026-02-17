import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/home/widget/champ_card_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/match_card_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/news_card_widget.dart';
import 'package:leaguestats_mobile/features/news/news.dart';
import 'package:leaguestats_mobile/features/home/widget/profile_icon_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/team_card_widget.dart';

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
          child: ListView(
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NewsSearchPageView(),
                        ),
                      );
                    },
                    child: const Text(
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

              Row(
                children: [
                  Text(
                    'Equipos',
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
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TeamCardWidget(
                      url:
                          "https://images.squarespace-cdn.com/content/v1/62d09f54a49d6f1c78455cce/16a13d58-e5ad-4a2d-b39f-ee9b97ade76f/T1+red.png?format=1500w",
                      teamName: "T1",
                    ),
                    TeamCardWidget(
                      url:
                          "https://am-a.akamaihd.net/image?resize=400:&f=http%3A%2F%2Fstatic.lolesports.com%2Fteams%2F1734012609283_MKOI_FullColor_Blue.png",
                      teamName: "MKOI",
                    ),
                    TeamCardWidget(
                      url:
                          "https://g2esports.com/cdn/shop/files/G2-Esports-2020-Logo_87bf0678-e67f-4834-8b09-e56137ffaa80.png?v=1641913940",
                      teamName: "G2",
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Partidas destacadas',
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
                  padding: EdgeInsets.only(bottom: 10),
                  children: [
                    MatchCardWidget(
                      iconoLiga:
                          'https://liquipedia.net/commons/images/8/8f/LCK_2021_full_lightmode.png',
                      nombreEquipo1: 'T1',
                      nombreEquipo2: 'Gen.G',
                      paisLiga: 'Corea',
                      urlBandera:
                          'https://sipalkido.com.ar/wp-content/uploads/2025/08/depositphotos_1919144-stock-photo-flag-of-south-korea.jpg',
                    ),
                    MatchCardWidget(
                      iconoLiga:
                          'https://liquipedia.net/commons/images/8/8f/LCK_2021_full_lightmode.png',
                      nombreEquipo1: 'T1',
                      nombreEquipo2: 'Gen.G',
                      paisLiga: 'Corea',
                      urlBandera:
                          'https://sipalkido.com.ar/wp-content/uploads/2025/08/depositphotos_1919144-stock-photo-flag-of-south-korea.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NewsSearchPageView(),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Apuestas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Estadisticas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
