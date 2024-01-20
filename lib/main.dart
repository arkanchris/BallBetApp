import 'dart:async';
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
  final MatchDetails details;

  Match({
    required this.teamA,
    required this.teamB,
    required this.date,
    this.isFinished = false,
    this.scoreTeamA = 0,
    this.scoreTeamB = 0,
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> sliderImages = [
    "assets/europal.jpg",
    'assets/copa.jpg',
    'assets/champions.jpg',
  ];

  final List<Match> matches = [
    Match(
      teamA: 'Manchester United',
      teamB: 'Real Madrid',
      date: DateTime.now(),
      details: MatchDetails(
        image: 'assets/partidou.png',
        text: 'Con las imágenes de los dos golazos del Real Madrid me despido y pongo punto y final a este directo. Recordar que el próximo compromiso de los blancos será el Clásico del sábado 29 de julio a las 23.00 horas en el AT&T Stadium de Dallas. ¡Un saludo!.',
      ),
    ),
    Match(
      teamA: 'Milan',
      teamB: 'Liverpool',
      date: DateTime.now(),
      details: MatchDetails(
        image: 'assets/milan_vs_inter.jpg',
        text: 'Texto sobre el partido Milan vs Inter.',
      ),
    ),
    Match(
      teamA: 'Deportivo Cali',
      teamB: 'Deportivo Pereira',
      date: DateTime.now(),
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

  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool isVipAuthenticated = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 4), (timer) {
      _currentPage = (_currentPage + 1) % sliderImages.length;
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  ElevatedButton buildForecastButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () {
        if (route == 'VIP' && !isVipAuthenticated) {
          _showVipAuthenticationDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => route == 'Free' ? FreeForecastScreen() : VipForecastScreen(),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: route == 'Free' ? Color.fromARGB(255, 94, 88, 88) : Color.fromARGB(255, 129, 120, 120),
            width: 3.0,
          ),
        ),
        elevation: 5.0,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        textStyle: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          color: route == 'Free' ? Colors.blue : Color.fromARGB(255, 15, 15, 15),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showVipAuthenticationDialog(BuildContext context) {
  String? email;
  String? password;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Autenticación VIP',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Realizar la autenticación con el servidor aquí.
                      // Simulamos autenticación exitosa por ahora.
                      setState(() {
                        isVipAuthenticated = true;
                      });

                      Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
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
            image: AssetImage('assets/estadiof.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200.0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: sliderImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(08.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(08.0),
                      border: Border.all(color: Color.fromARGB(255, 47, 99, 245), width: 2.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        sliderImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
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
                    style: TextStyle(
                      color: Color.fromARGB(255, 5, 4, 77),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                children: matches.map((match) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Color.fromARGB(255, 2, 2, 2), width: 2.0),
                      ),
                      child: Center(
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 0, 0, 0),
                          title: Text(
                            '${match.teamA} vs ${match.teamB}',
                            style: _getTextStyle(match),
                          ),
                          subtitle: Text(
                            'Fecha: ${match.date.toString()}',
                            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
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
                    height: 70.0,
                    child: buildForecastButton(context, 'Pronóstico Gratis', 'Free'),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 150.0,
                    height: 70.0,
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

  TextStyle _getTextStyle(Match match) {
    if (match.teamA == 'Manchester United' && match.teamB == 'Real Madrid') {
      return TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 19.0,
        fontWeight: FontWeight.bold,
      );
    } else if (match.teamA == 'Milan' && match.teamB == 'Liverpool') {
      return TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 19.0,
        fontWeight: FontWeight.bold,
      );
    } else if (match.teamA == 'Deportivo Cali' && match.teamB == 'Deportivo Pereira') {
      return TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 19.0,
        fontWeight: FontWeight.bold,
      );
    } else {
      return TextStyle(
        color: Color.fromARGB(199, 255, 255, 255),
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      );
    }
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
          SizedBox(height: 10),
          Text(match.details.text),
          SizedBox(height: 10),
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
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 10.0, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Casilla ${index + 1}'),
                  ),
                ),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(width: 3.0, color: Colors.red),
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
  final List<String> vipOptions = [
    'Opción 1',
    'Opción 2',
  ];

  final List<String> vipImages = [
    'assets/membresiad.jpg',
    'assets/membresiad2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VIP'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wembleyvip.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            VipImageWithButton(
              image: vipImages[0],
              buttonColor: Color.fromARGB(255, 7, 236, 57),
              buttonTextSize: 25.0,
            ),
            VipImageWithButton(
              image: vipImages[1],
              buttonColor: Color.fromARGB(255, 7, 236, 57),
              buttonTextSize: 25.0,
            ),
          ],
        ),
      ),
    );
  }
}

class VipImageWithButton extends StatelessWidget {
  final String image;
  final Color? buttonColor;
  final double? buttonTextSize;

  VipImageWithButton({
    required this.image,
    this.buttonColor,
    this.buttonTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform(
            transform: Matrix4.translationValues(-60.0, 0.0, 0.0) *
                Matrix4.diagonal3Values(1.5, 1.5, 1.0),
            child: Image.asset(
              image,
              width: 250,
              height: 200,
            ),
          ),
          SizedBox(height: 65),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                // Implementa aquí la lógica para la compra del plan
                // Puedes usar el método launch de url_launcher para redirigir a una página de compra.
                // Ejemplo:
                // const url = 'https://www.ejemplo.com/comprar-plan';
                // launch(url);
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor ?? Color.fromARGB(255, 135, 226, 16),
                onPrimary: const Color.fromARGB(255, 0, 0, 0),
                padding: EdgeInsets.all(20.0),
              ),
              child: Text(
                'Comprar Membresia',
                style: TextStyle(
                  fontSize: buttonTextSize ?? 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
