import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

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

class Match {
  final String teamA;
  final String teamB;
  final DateTime date;
  bool isFinished;
  int scoreTeamA;
  int scoreTeamB;

  Match({
    required this.teamA,
    required this.teamB,
    required this.date,
    this.isFinished = false,
    this.scoreTeamA = 0,
    this.scoreTeamB = 0,
  });
}

class HomeScreen extends StatelessWidget {
  final List<Match> matches = [
    Match(teamA: 'Manchester United', teamB: 'Real Madrid', date: DateTime.now()),
    Match(teamA: 'Roma', teamB: 'Inter', date: DateTime.now()),
    Match(teamA: 'Deportivo Cali', teamB: 'Millonarios FC', date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
          FloatingActionButton(
            onPressed: () async {
              const url = 'https://wa.me/<tu_numero_de_telefono>';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'No se pudo abrir el enlace de WhatsApp.';
              }
            },
            child: Icon(Icons.chat),
            backgroundColor: Colors.green,
            mini: true,
          ),
        ],
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: matches.length + 1,  // +1 para el letrero "Partido importantes"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 50.0),  // Centrar el texto
                      title: Center(
                        child: Text(
                          'Partidos importantes:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final match = matches[index - 1];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/manu.png'),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text('${match.teamA} vs ${match.teamB}'),
                    subtitle: Text('Fecha: ${match.date.toString()}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchDetailsScreen(match: match),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FreeForecastScreen(),
                      ),
                    );
                  },
                  child: Text('Pronóstico Gratis'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VipForecastScreen(),
                      ),
                    );
                  },
                  child: Text('VIP'),
                ),
              ],
            ),
          ),
        ],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fecha: ${match.date.toString()}'),
          ],
        ),
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
              child: Center(
                child: Text('Casilla ${index + 1}'),
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
              child: Center(
                child: Text('Casilla VIP ${index + 1}'),
              ),
            ),
          );
        }),
      ),
    );
  }
}