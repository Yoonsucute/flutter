import 'package:flutter/material.dart';

class Login extends StatelessWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Email"
            )
          ),
          SizedBox(height: 20,),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
            )
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){},
            child: Text("Login"),
          )
        ]
      )
      )
    );
  }
}