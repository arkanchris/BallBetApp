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
    Match(
      teamA: 'Barcelona',
      teamB: 'Bayern Munich',
      date: DateTime.now().add(Duration(days: 1)), // Cambiar la fecha según sea necesario
      details: MatchDetails(
        image: 'assets/partido3.jpg', // Cambiar la imagen según sea necesario
        text: 'Descripción del partido Barcelona vs Bayern Munich.',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recuperar contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ingresa tu correo electrónico y te enviaremos instrucciones para recuperar tu contraseña.'),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar instrucciones de recuperación de contraseña aquí
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                _showPasswordRecoverySentDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordRecoverySentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instrucciones enviadas'),
          content: Text('Hemos enviado instrucciones para recuperar tu contraseña a tu correo electrónico.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToVIPPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VipPage(),
      ),
    );
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
      child: Column(
        children: [
          ListTile(
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
                  match.teamA == 'Manchester United' && match.teamB == 'Real Madrid'
                      ? 'Mas de 2.5 goles'
                      : match.teamA == 'Milan' && match.teamB == 'Liverpool'
                          ? 'Ambos marcan 1ra mitad'
                          : 'Disparo a puerta De Jong + 1.5', // Cambiar el texto según sea necesario
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
              ],
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
    'Cuota ${match.teamA == 'Manchester United' && match.teamB == 'Real Madrid' ? '1.45' : '1.33'}', // Modificar el texto según sea necesario
    style: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    ),
  ),
),

        ],
      ),
    ),
  );
}).toList(),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  width: 150.0,
                  height: 70.0,
                  child: buildForecastButton(context, 'VIP', 'VIP'),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  width: 150.0,
                  height: 70.0,
                  child: buildForecastButton(context, 'Premium', 'Membership'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class FreeForecastScreen extends StatelessWidget {
  const FreeForecastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pronósticos Gratuitos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ForecastItem(
                    title: 'Manchester United vs Real Madrid',
                    description: 'Más de 2.5 goles',
                    imagePath: 'assets/partidou.png',
                  ),
                  // Eliminado el pronóstico "Milan vs Liverpool"
                  ForecastItem(
                    title: 'Barcelona vs Bayern Munich',
                    description: 'Bayern Munchen X2',
                    imagePath: 'assets/partido3.jpg',
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

class VipForecastScreen extends StatelessWidget {
  const VipForecastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pronósticos VIP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ForecastItem(
                    title: 'Pronóstico VIP 1',
                    description: 'Descripción del pronóstico VIP 1',
                    imagePath: 'assets/pronosticovip1.jpg',
                  ),
                  ForecastItem(
                    title: 'Pronóstico VIP 2',
                    description: 'Descripción del pronóstico VIP 2',
                    imagePath: 'assets/pronosticovip2.jpg',
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

class ForecastItem extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const ForecastItem({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 150.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16.0,
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

  const MatchDetailsScreen({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del Partido',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${match.teamA} vs ${match.teamB}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Fecha del Partido: ${match.date.toLocal()}',
              style: TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Descripción del partido:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              match.details.text,
              style: TextStyle(
                fontSize: 16.0,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

class VipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Área VIP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido al Área VIP',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Aquí encontrarás pronósticos exclusivos para nuestros miembros VIP.',
              style: TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

class MembershipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Premium',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo5.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hazte Miembro VIP',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Obtén acceso exclusivo a pronósticos VIP y disfruta de beneficios adicionales al convertirte en miembro VIP.',
              style: TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 5, 4, 77),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _launchURL('https://example.com/membership'); // Reemplaza con tu enlace de membresía
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text(
                'Hazte Miembro',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}
