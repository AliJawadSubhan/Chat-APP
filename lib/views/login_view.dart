import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -MediaQuery.of(context).size.height * 0.15,
              right: -MediaQuery.of(context).size.width * 0.4,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80.0),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: const TextStyle(color: Colors.purple),
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.purple),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.purple),
                      prefixIcon: Icon(Icons.lock, color: Colors.purple),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        // Perform login
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('don\'t have an account?'),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.purple),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
