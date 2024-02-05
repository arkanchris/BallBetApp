import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MatchDetails {
  String image;
  String text;

  MatchDetails({required this.image, required this.text});
}

class Match {
  String teamA;
  String teamB;
  DateTime date;
  bool isFinished;
  int scoreTeamA;
  int scoreTeamB;
  MatchDetails details;

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
    "assets/partido1.jpg",
    'assets/partido2.jpg',
    'assets/partido4.jpg',
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
  // Eliminado el partido "Milan vs Liverpool"
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
        if (route == 'VIP') {
          _showVipVerificationDialog(context);
        } else if (route == 'Membership') {
          _navigateToMembershipScreen(context);
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

  void _showVipVerificationDialog(BuildContext context) {
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
                  'Verificación VIP',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Ingresa tu correo y contraseña VIP para acceder a pronósticos exclusivos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
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
                        // Realizar la verificación VIP con el servidor aquí.
                        // Simulamos verificación exitosa por ahora.
                        isVipAuthenticated = true;
                        Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                        _navigateToVIPPage(context); // Navegar a la página VIP
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog(context);
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
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

  void _showForgotPasswordDialog(BuildContext context) {
    String? email;

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
                  'Olvidé mi contraseña',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Ingresa tu correo electrónico asociado a la cuenta VIP para restablecer tu contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
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
                        // Aquí puedes implementar la lógica para enviar un correo de restablecimiento de contraseña.
                        // Simulamos un mensaje de éxito por ahora.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Se ha enviado un correo de restablecimiento de contraseña a $email'),
                          ),
                        );
                        Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        'Enviar',
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

  void _navigateToVIPPage(BuildContext context) {
    // Navegar a la página VIP solo si la autenticación VIP es exitosa.
    if (isVipAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VipForecastScreen(),
        ),
      );
    } else {
      // Mostrar un mensaje de error o realizar alguna acción si la autenticación falla.
      // Puedes agregar aquí un SnackBar o un AlertDialog para informar al usuario.
    }
  }

  void _navigateToMembershipScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MembershipScreen(),
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
                    'Pronosticos Gratuitos',
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
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Column(
                          children: [
                            Text(
                              '${match.teamA} vs ${match.teamB}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 5, 4, 77),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              // Agregando texto personalizado para ambos partidos
                              match.teamA == 'Manchester United' && match.teamB == 'Real Madrid'
                                  ? 'Mas de 2.5 goles'
                                  : match.teamA == 'Milan' && match.teamB == 'Liverpool'
                                      ? 'Ambos marcan 1ra mitad'
                                      : 'Texto por defecto para otros partidos',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 5, 4, 77),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            if (match.isFinished)
                              Text(
                                'Resultado: ${match.scoreTeamA} - ${match.scoreTeamB}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 5, 4, 77),
                                ),
                              )
                            else
                              Text(
                                'Hoy 14:30',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 5, 4, 77),
                                ),
                              ),
                            SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MatchDetailsScreen(match: match),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              child: Text(
                                'Detalles',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Spacer(),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  width: 150.0,
                  height: 70.0,
                  child: buildForecastButton(context, 'VIP', 'VIP'),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  width: 155.0,
                  height: 70.0,
                  child: buildForecastButton(context, 'Membresia', 'Membership'),
                ),
              ],
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
        children: List.generate(1, (index) {
          return GestureDetector(
            onTap: () {
              // Acción cuando se toca una casilla (si es necesario).
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 2.0, color: Color.fromARGB(255, 41, 1, 94)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    size: 50.0,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Equipo A vs Equipo B',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Fecha: DD/MM/AAAA',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VipForecastScreen extends StatelessWidget {
  final List<Match> vipMatches = [
    Match(
      teamA: 'Equipo C',
      teamB: 'Equipo D',
      date: DateTime.now(),
      details: MatchDetails(
        image: 'assets/match_image_1.jpg',
        text: 'Texto sobre el partido Equipo C vs Equipo D.',
      ),
    ),
    Match(
      teamA: 'Equipo E',
      teamB: 'Equipo F',
      date: DateTime.now(),
      details: MatchDetails(
        image: 'assets/match_image_2.jpg',
        text: 'Texto sobre el partido Equipo E vs Equipo F.',
      ),
    ),
    // Agrega más partidos VIP según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pronósticos VIP'),
      ),
      body: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Center(
            child: Text(
              'Pronósticos VIP:',
              style: TextStyle(
                color: Color.fromARGB(255, 5, 4, 77),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: vipMatches.map((match) {
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
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Fecha: ${match.date.toString()}',
                      style: TextStyle(
                        color: Color.fromARGB(199, 255, 255, 255),
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatchDetailsScreen(match: match),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'Detalles',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MembershipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membresía'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Conviértete en miembro VIP para acceder a pronósticos exclusivos!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar la pantalla de membresía
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text(
                'Volver',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
