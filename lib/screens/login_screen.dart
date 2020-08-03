

import 'package:flutter/material.dart';
import 'package:mpgscout/utilities/constants.dart';
import 'package:mpgscout/utilities/globals.dart' as globals;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'Accueil/accueil.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final formKey = GlobalKey<FormState>();
  String _email, _password;
  var _controllerPassword = TextEditingController();

   _makeSignInRequest(String email, String password) async {
     print('signinrequest');
    String url = 'https://api.monpetitgazon.com/user/signIn';
    Map<String, dynamic> payload = {
      'email': email,
      'password': password
    };

     Map<String, String> headers = {"Content-type": "application/json"};
     String json = jsonEncode(payload);
     Response response = await post(url, headers: headers, body: json);
    print(response.body);
    return jsonDecode(response.body);
  }

  _getUser(String token) async {
    String url = 'https://api.monpetitgazon.com/user';
    Map<String, String> headers = {
      "Connection": "keep-alive",
      "fromhost": "mpg",
      "Origin": "https://mpg.football",
      "session-id": "9e4875b1-9bc2-47b4-ac93-3f1996a9c6da",
      'Authorization': token,
      "Content-type": "application/json",
    };
    Response response = await get(url, headers: headers);
    return jsonDecode(response.body);
  }

  Widget _buildEmailTF(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top:14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Entre ton Email MPG',
              hintStyle: kHintTextStyle,
            ),
            validator: (input) => !input.contains('@') ? 'Not a valid Email' : null,
            onSaved: (input) => _email = input,
          ),
        ),
    ],
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: (){
          _submit(context);
          },
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
      if (formKey.currentState.validate()){
        formKey.currentState.save();
        print('submit');


          // On sauvegarde l'email et le mot de passe
          globals.email = _email;
          globals.password = _password;

          var returnSignIn = await _makeSignInRequest(_email, _password);

          print('heys');
          print(returnSignIn.keys);
        if (returnSignIn.containsKey('token')) {
          var returnGetUser = await _getUser(returnSignIn['token']);

          // On récupère le nom de l'utilisateur
          globals.user = returnGetUser["firstname"];
          globals.userId = returnGetUser["id"];
          globals.dataframe = '';
          print("letsgo");
          Navigator.push(context, new MaterialPageRoute(
              builder: (context) => Accueil()
          ));
        }else{
          _controllerPassword.clear();
          Fluttertoast.showToast(
              msg: "Mauvais e-mail ou mot de passe",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
          );
        }


        String test = 'UJ4J3FGM7Q';
      }
  }

  Widget _buildPasswordTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _controllerPassword,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top:14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Entre ton mot de passe MPG',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (input) => _password = input,
          ),
        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(children: <Widget>[

        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:[
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7,0.9],
            ),
          ),
        ),
        Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: 40.0,
            vertical: 120.0,
            ),
            child: Form(
                key: formKey,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'MPG Scout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildEmailTF(),
                  SizedBox(height: 30),
                  _buildPasswordTF(),
                  _buildLoginBtn(context),
              ],
            )
          ),
        ),
        ),
      ],
      ),
    );
  }
}

