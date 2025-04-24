import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  void decrement(){
    setState(() {
      count--;  
    });
    print('Pessoa saiu, quantidade atual: $count');
  }

  void increment(){
    setState(() {
      count++;  
    });    
    print('Pessoa entrou, quantidade atual: $count');
  }

  bool get isEmpty => count == 0;
  bool get isFull => count >= 20;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/sorvete.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(85.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                isFull ? "Lotado": "Pode entrar!",
                style: const TextStyle(
                  fontSize: 30, 
                  color: Colors.pink,
                  fontWeight: FontWeight.w700,
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: isFull ? Colors.red : Color.fromARGB(255, 255, 255, 255),
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ]
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: isEmpty? null : decrement,
                    style: TextButton.styleFrom(
                      backgroundColor: isEmpty ? Colors.white.withOpacity(0.3) : Colors.white,
                      fixedSize: const Size(100,100),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)
                      ),
                    ),
                    child: const Text("Sair", style: TextStyle(color: Colors.black, fontSize: 16),),
                    ),
                  const SizedBox(width: 32),
                  TextButton(
                    onPressed: isFull ? null : increment,
                    style: TextButton.styleFrom(
                      backgroundColor: isFull ? Colors.white.withOpacity(0.3) : Colors.white,
                      fixedSize: const Size(100,100),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)
                      ),
                    ),
                    child: const Text("Entrar", style: TextStyle(color: Colors.black, fontSize: 16),),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
