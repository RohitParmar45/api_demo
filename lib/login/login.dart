import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginPage extends StatelessWidget {
  TextEditingController email = TextEditingController(),
      password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Email',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    login(email.text.toString(), password.text.toString(),
                        context);
                    print("object");
                  },
                  child: const Text('Submit'))
            ],
          ),
        ),
      )),
    );
  }

  void login(String em, String pass, BuildContext context) async {
    try {
      Response response = await post(
          Uri.parse("https://reqres.in/api/register"),
          body: {'email': em, 'password': pass});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var message = "id : ${data["id"]} token : ${data["token"]}";
        showSnackBar(message, context);
      } else {
        showSnackBar("something went wrong ", context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3), // Adjust the duration as needed
        action: SnackBarAction(
          label: 'Click to Cancel',
          onPressed: () {
            // Perform an action when the Snackbar action is pressed
            print('Snackbar action pressed!');
          },
        ),
      ),
    );
  }
}
