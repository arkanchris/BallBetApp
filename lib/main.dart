import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MatchDetails {
  final String image;
  final String text;

  MatchDetails({required this.image, required this.text});
}

class Match {
  final String teamA;
  final String teamB;
  final DateTime date;
  bool isFinished;
  int scoreTeamA;
  int scoreTeamB;
  final String logoTeamA;
  final String logoTeamB;
  final MatchDetails details;

  Match({
    required this.teamA,
    required this.teamB,
    required this.date,
    this.isFinished = false,
    this.scoreTeamA = 0,
    this.scoreTeamB = 0,
    required this.logoTeamA,
    required this.logoTeamB,
    required this.details,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BallBetApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> sliderImages = [
    'assets/slider_betplay.jpg',
    'assets/slider_copa.jpg',
    'assets/slider_champions.jpg',
  ];

  final List<Match> matches = [
    Match(
      teamA: 'Manchester United',
      teamB: 'Real Madrid',
      date: DateTime.now(),
      logoTeamA: 'assets/ing.png',
      logoTeamB: 'assets/esp.png',
      details: MatchDetails(
        image: 'assets/partidou.png',
        text: 'Con las imágenes de los dos golazos del Real Madrid me despido y pongo punto y final a este directo. Recordar que el próximo compromiso de los blancos será el Clásico del sábado 29 de julio a las 23.00 horas en el AT&T Stadium de Dallas. ¡Un saludo!.',
      ),
    ),
    Match(
      teamA: 'milan',
      teamB: 'Liverpool',
      date: DateTime.now(),
      logoTeamA: 'assets/milan.png',
      logoTeamB: 'assets/liverpool.png',
      details: MatchDetails(
        image: 'assets/milan_vs_inter.jpg',
        text: 'Texto sobre el partido Milan vs Inter.',
      ),
    ),
    Match(
      teamA: 'Deportivo Cali',
      teamB: 'Deportivo Pereira',
      date: DateTime.now(),
      logoTeamA: 'assets/cali.png',
      logoTeamB: 'assets/pereira.png',
      details: MatchDetails(
        image: 'assets/estadio.jpg',
        text: 'Texto sobre el partido Deportivo Cali vs Deportivo Pereira.',
      ),
    ),
  ];

  final TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  ElevatedButton buildForecastButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route == 'Free' ? FreeForecastScreen() : VipForecastScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'BallBetApp',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () async {
                const url = 'https://telegram.org/<tu_numero_de_telefono>';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'No se pudo abrir el enlace de WhatsApp.';
                }
              },
              child: Image.asset('assets/telegram.png', width: 36, height: 36),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/estadiof.jpg'), // Reemplaza con la ruta correcta de tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200.0,
              child: PageView.builder(
                itemCount: sliderImages.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    sliderImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Card(
              elevation: 4.0,
              margin: EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Center(
                  child: Text(
                    'Partidos importantes:',
                    style: titleStyle,
                  ),
                ),
                children: matches.map((match) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Color.fromARGB(255, 7, 124, 241), width: 2.0),
                      ),
                      child: ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(match.logoTeamA),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(match.logoTeamB),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          '${match.teamA} vs ${match.teamB}',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          'Fecha: ${match.date.toString()}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MatchDetailsScreen(match: match),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 150.0,
                    height: 150.0,
                    child: buildForecastButton(context, 'Pronóstico Gratis', 'Free'),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 150.0,
                    height: 150.0,
                    child: buildForecastButton(context, 'VIP', 'VIP'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  MatchDetailsScreen({required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${match.teamA} vs ${match.teamB}'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            match.details.image,
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(match.details.text),
          SizedBox(height: 20),
          Text('Fecha: ${match.date.toString()}'),
        ],
      ),
    );
  }
}

class FreeForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pronóstico Gratis'),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              // Acción cuando se toca una casilla (si es necesario).
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Casilla ${index + 1}'),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VipForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VIP'),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {
              // Acción cuando se toca una casilla (si es necesario).
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Casilla VIP ${index + 1}'),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
