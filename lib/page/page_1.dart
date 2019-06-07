import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zanapp/model/searchPrivot.dart';
import 'package:zanapp/setTime.dart';
import 'dart:collection';

import '../font_style.dart';
import '../mainpage.dart';
import 'page_detail.dart';

class PageWelcome extends StatefulWidget {
  PageWelcome() : super();
  @override
  _PageWelcomeState createState() => _PageWelcomeState();
}

class _PageWelcomeState extends State<PageWelcome> {
  final formKey = new GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FixedExtentScrollController fixedExtentScrollController =
      new FixedExtentScrollController();

  TextEditingController taskTitleInputController;
  TextEditingController taskDescripInputController;

  String _topic;
  String _detail;

  @override
  void initState() {
    // TODO: implement initState
    taskTitleInputController = new TextEditingController();
    taskDescripInputController = new TextEditingController();
    super.initState();
  }

  /// สำหรับ ใช้ Search Firestore
  var queryResearchSet = [];
  var tempSearchStore = [];

  insertSearch(val) {
    if (val.lenght == 0) {
      setState(() {
        queryResearchSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue = val.substring(0, 1).toUpperCase() + val.substring(1);

    if (queryResearchSet.length == 0 && val.length == 1) {
      SearchService().searchByName(val).then((QuerySnapshot docs) {
        for (int i; i < docs.documents.length; i++) {
          queryResearchSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResearchSet.forEach((element) {
        if (element['topic'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }
  // *****************//

  void _addData() {
    if (taskDescripInputController.text.isNotEmpty &&
        taskTitleInputController.text.isNotEmpty) {
      Firestore.instance
          .collection('text_note')
          .add({
            'topic': _topic,
            'detail': _detail,
            'time': setTime().datetime,
          })
          .then((result) => {
                taskDescripInputController.clear(),
                taskTitleInputController.clear()
              })
          .catchError((err) => print(err));
    }
    ;
    Navigator.pop(context);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _addData();
    }
  }

  deleteData(docId) {
    Firestore.instance
        .collection('text_note')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
    taskDescripInputController.clear();
    taskTitleInputController.clear();
  }

  _showDialog_LOGOUT() async {
    await showDialog<String>(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(16.0),
          content: Container(
            height: 132,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.report_problem,
                      size: 60,
                      color: Color.fromRGBO(255, 215, 0, 1),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      'Logout !',
                      style: TextStyle(
                          fontSize: 30, fontFamily: FontStyles().fontFamily),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 120,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        color: Color.fromRGBO(205, 92, 92, 1),
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontStyles().fontFamily)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    SizedBox(
                      width: 120,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        color: Color(0xFF33b17c),
                        child: Text('Okay',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontStyles().fontFamily)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _showDialog_DEL(String topic, String docId) async {
    await showDialog<String>(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(16.0),
          content: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.delete_outline,
                      size: 80,
                      color: Color.fromRGBO(205, 92, 92, 1),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$topic',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontFamily: FontStyles().fontFamily),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text(
                          'Delete !!!',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: FontStyles().fontFamily),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 120,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        color: Color.fromRGBO(205, 92, 92, 1),
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontStyles().fontFamily)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    SizedBox(
                      width: 120,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        color: Color(0xFF33b17c),
                        child: Text('Okay',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: FontStyles().fontFamily)),
                        onPressed: () {
                          deleteData(docId);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _showDialog_ADD() async {
    await showDialog<String>(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          //contentPadding: EdgeInsets.all(16.0),
          content: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue,
                    ),
                    Text(
                      '  Create a new Note',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: FontStyles().fontFamily),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white.withOpacity(0.4),
                                  icon: Icon(Icons.format_color_text, size: 20),
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  labelText: 'Topic Note',
                                  labelStyle: TextStyle(
                                      fontFamily: FontStyles().fontFamily)),
                              validator: (val) =>
                                  val.isEmpty ? 'Input Topic' : null,
                              onSaved: (val) {
                                _topic = val;
                              },
                              controller: taskTitleInputController,
                              keyboardType: TextInputType.text,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white.withOpacity(0.4),
                                  icon: Icon(Icons.text_fields, size: 20),
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  labelText: 'Detail',
                                  labelStyle: TextStyle(
                                      fontFamily: FontStyles().fontFamily)),
                              onSaved: (val) {
                                _detail = val;
                              },
                              validator: (val) =>
                                  val.isEmpty ? 'Input Price' : null,
                              controller: taskDescripInputController,
                              maxLines: 3,
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    color: Color.fromRGBO(205, 92, 92, 1),
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily:
                                                FontStyles().fontFamily)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    color: Color(0xFF33b17c),
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FontStyles().fontFamily),
                                    ),
                                    onPressed: () {
                                      _submit();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          /* actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                _submit();
              },
            )
          ], */
        ));
  }

  //*********start****Reading From Store **********/
  String _searchText;
  Widget readingFormStore() {
    return StreamBuilder(
        stream: Firestore.instance.collection('text_note').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'กำลังโหลด . . .',
              style:
                  TextStyle(fontFamily: FontStyles().fontFamily, fontSize: 18),
            );
          } else {
            int num = snapshot.data.documents.length;
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.height / 2.3,
                height: MediaQuery.of(context).size.height / 1.35,
                child: ListView.builder(
                  itemCount: num,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 100,
                      child: Card(
                        child: InkWell(
                          onLongPress: () {
                            String topic =
                                snapshot.data.documents[index]['topic'];
                            _showDialog_DEL(topic,
                                snapshot.data.documents[index].documentID);
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Page_Detail(index)),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    ' ' +
                                        snapshot.data.documents[index]['topic'],
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.blue,
                                        fontFamily: FontStyles().fontFamily),
                                  ),
                                  Padding(padding: EdgeInsets.all(2)),
                                  Container(
                                    width: MediaQuery.of(context).size.height /
                                        2.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          ' ' +
                                              snapshot.data.documents[index]
                                                  ['detail'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily:
                                                  FontStyles().fontFamily),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(7)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );

            /*
                  int num = snapshot.data.documents.length;
                  return ListView.builder(
                    itemCount: num,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: new Card(
                          elevation: 5.0,
                          child: new Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                                snapshot.data.documents[0]['brandname']),
                          ),
                        ),
                      );
                    },
                  );
                  */

          }
        });
  }

//****end*********Reading From Store ********/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Container(
            child: Column(children: <Widget>[
          Container(
            height: 180.0,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg_banner.jpeg'),
                          fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 30.0,
                        ),
                      ]),
                  //   color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  child: Center(
                    child: Text(
                      "Note :: life style",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontFamily: FontStyles().fontFamily,
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(2, 2),
                                color: Colors.white),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  top: 20.0,
                  left: 0.0,
                  right: 350.0,
                  child: IconButton(
                    tooltip: 'log out',
                    color: Colors.blue,
                    onPressed: () {
                      _showDialog_LOGOUT();
                    },
                    icon: Icon(Icons.lock, size: 22),
                  ),
                ),
                Positioned(
                  top: 115.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          //  border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
                          color: Colors.white.withOpacity(0.90)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(9),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (val) {
                                insertSearch(val);
                                _searchText = val;
                              },
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      fontFamily: FontStyles().fontFamily)),
                            ),
                          ),
                          IconButton(
                            tooltip: 'search document',
                            icon: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              print("your menu action here");
                            },
                          ),
                          IconButton(
                            tooltip: 'add document',
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              print("your menu action here");
                              _showDialog_ADD();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
              child: Column(
            children: <Widget>[
              readingFormStore(),
            ],
          )),
        ])));
  }
}
