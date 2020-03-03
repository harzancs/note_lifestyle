import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../font_style.dart';
import '../mainpage.dart';
import '../setTime.dart';
import 'page_1.dart';

class Page_Detail extends StatefulWidget {
  final int numberIndex;
  Page_Detail(this.numberIndex, {Key key}) : super(key: key);

  @override
  _Page_DetailState createState() => _Page_DetailState();
}

class _Page_DetailState extends State<Page_Detail> {
  final formKey = new GlobalKey<FormState>();

  String _text_detail;
  String _text_topic;

  String doc_ID;

  String _topicEdited = '';
  String _detailEdited = '';

  TextEditingController taskTitleInputController;
  TextEditingController taskDescripInputController;

  @override
  void initState() {
    // TODO: implement initState
    taskTitleInputController = new TextEditingController();
    taskDescripInputController = new TextEditingController();
    super.initState();
  }

  //* Update ---Start---

  _showDialog_UPDATE(
      String doc_ID, String _text_detail_01, String _text_topic_01) async {
    taskTitleInputController.text = _text_topic_01;
    taskDescripInputController.text = _text_detail_01;
    await showDialog<String>(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          //contentPadding: EdgeInsets.all(16.0),
          content: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.short_text,
                      color: Colors.blue,
                      size: 35,
                    ),
                    Text(
                      '  Edit a Note',
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
                                _topicEdited = val;
                              },
                              controller: taskTitleInputController,
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
                                _detailEdited = val;
                              },
                              validator: (val) =>
                                  val.isEmpty ? 'Input Price' : null,
                              controller: taskDescripInputController,
                              maxLines: 4,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
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
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    color: Color(0xFF33b17c),
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FontStyles().fontFamily),
                                    ),
                                    onPressed: () {
                                      _submit(doc_ID);
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
        ));
  }

  void _submit(String doc_ID) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _editData(doc_ID);
    }
  }

  void _editData(String doc_ID) {
    if (taskDescripInputController.text.isNotEmpty &&
        taskTitleInputController.text.isNotEmpty) {
      Firestore.instance
          .collection('text_note')
          .document(doc_ID)
          .updateData({
            'topic': _topicEdited,
            'detail': _detailEdited,
            'time': setTime().datetime,
          })
          .then((result) => {
                taskDescripInputController.clear(),
                taskTitleInputController.clear()
              })
          .catchError((err) => print(err));
    }

    Navigator.pop(context);
  }

  //*   Update ---End----

  // Detail Data */
  Widget readDataFormStore() {
    return StreamBuilder(
      stream: Firestore.instance.collection('text_note').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'กำลังโหลด . . . ',
            style: TextStyle(fontFamily: FontStyles().fontFamily, fontSize: 18),
          );
        } else {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.height / 2.3,
              height: MediaQuery.of(context).size.height / 1.35,
              child: ListView.builder(
                itemCount: 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            snapshot.data.documents[widget.numberIndex]
                                ['detail'],
                            style:
                                TextStyle(fontFamily: FontStyles().fontFamily),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  /* **End******Detail Data */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 180,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/bg_detail.jpeg'),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 30.0,
                              ),
                            ]),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Center(
                            child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('text_note')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('กำลังโหลด . . .',
                                  style: TextStyle(
                                      fontFamily: FontStyles().fontFamily,
                                      fontSize: 18));
                            } else {
                              // เก็บข้อมูลสำหรับส่งต่อ

                              doc_ID = snapshot.data
                                  .documents[widget.numberIndex].documentID;
                              _text_topic = snapshot
                                  .data.documents[widget.numberIndex]['topic'];
                              _text_detail = snapshot
                                  .data.documents[widget.numberIndex]['detail'];

                              //
                              return Container(
                                child: Center(
                                    child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                    ),
                                    Text(
                                      _text_topic,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24.0,
                                          fontFamily: FontStyles().fontFamily,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2, 3),
                                              color: Colors.white,
                                              blurRadius: 4.0,
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                    ),
                                    Text(
                                      snapshot.data
                                              .documents[widget.numberIndex]
                                          ['time'],
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontFamily: FontStyles().fontFamily,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(2, 3),
                                              color: Colors.white,
                                              blurRadius: 1.0,
                                            ),
                                          ]),
                                    ),
                                  ],
                                )),
                              );
                            }
                          },
                        )),
                      ),
                      Positioned(
                        top: 30.0,
                        left: 0.0,
                        right: 350.0,
                        child: FlatButton(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageWelcome()),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 105.0,
                        left: 320.0,
                        right: 0.0,
                        child: IconButton(
                          tooltip: 'edit',
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 26,
                          ),
                          onPressed: () {
                            _showDialog_UPDATE(
                                doc_ID, _text_detail, _text_topic);
                            print("your menu action here");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: <Widget>[
                      readDataFormStore(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
