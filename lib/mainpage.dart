import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'font_style.dart';
import 'page/page_1.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = new GlobalKey<FormState>();

  final myNodePassword = new TextEditingController();
  final myNodeUsername = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _username = '';
  String _password = '';

  void _showPopupEmply() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(fontSize: 24.0,fontFamily: FontStyles().fontFamily),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  /*  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    
                  ), */
                  Icon(Icons.clear, size: 100, color: Colors.red),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontStyles().fontFamily),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _nextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageWelcome()),
    );
  }

  void _loginPerson() {
    if (_username == 'admin' && _password == '12345') {
      _nextPage(context);
    } else {
      _showPopupEmply();
    }
  }

//********** Start *** บันทึก Value ************/
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginPerson();
    }
  }
//********** End *** บันทึก Value ************/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_login.jpeg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'BOOK',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontFamily: FontStyles().fontFamily,
                        ),
                      ),
                      Icon(
                        Icons.hourglass_empty,
                        size: 80,
                        color: Colors.blue,
                      ),
                      Text(
                        'Life Style',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue,
                          fontFamily: FontStyles().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.4),
                                  icon: Icon(Icons.person, size: 30),
                                  hintText: 'USERNAME',
                                  hintStyle: TextStyle(
                                      fontFamily: FontStyles().fontFamily),
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                                controller: myNodeUsername,
                                keyboardType: TextInputType.text,
                                onSaved: (String val) => _username = val,
                                validator: (val) =>
                                    val.isEmpty ? 'Input Username' : null,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.4),
                                  icon: Icon(Icons.vpn_key, size: 30),
                                  hintText: 'PASSWORD',
                                  hintStyle: TextStyle(
                                      fontFamily: FontStyles().fontFamily),
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                ),
                                controller: myNodePassword,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                onSaved: (val) => _password = val,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _submit();
                                      myNodePassword.clear();
                                    },
                                    child: Row(children: <Widget>[
                                      Text(
                                        'LOG IN',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily:
                                                FontStyles().fontFamily),
                                      )
                                    ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
