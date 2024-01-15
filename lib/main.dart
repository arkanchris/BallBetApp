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

  // Estilo de texto común para "Partidos importantes"
  final TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

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
          Positioned(
  top: 0,
  right: 0,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: FloatingActionButton(
      onPressed: () async {
        const url = 'https://wa.me/<tu_numero_de_telefono>';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'No se pudo abrir el enlace de WhatsApp.';
        }
      },
      child: Image.asset('assets/wtp.png', width: 24, height: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  ),
),

        ],
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [
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
                      border: Border.all(color: Colors.blue, width: 2.0),
                    ),
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
                      title: Text(
                        '${match.teamA} vs ${match.teamB}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Fecha: ${match.date.toString()}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FreeForecastScreen(),
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
                        'Pronóstico Gratis',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  width: 150.0,
                  height: 150.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VipForecastScreen(),
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
                        'VIP',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
