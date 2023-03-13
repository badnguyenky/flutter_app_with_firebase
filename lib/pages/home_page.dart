import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phonenumController = new TextEditingController();
  TextEditingController startController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  String role = 'user';
  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            role == 'user' ? Text("ALL RECORDS") : Text('ALL RECORDS (ADMIN)'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Fluttertoast.showToast(msg: "LOGGED OUT");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (context) => Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "NAME...",
                            ),
                          ),
                          TextFormField(
                            controller: phonenumController,
                            decoration: InputDecoration(
                              hintText: "PHONE NUMBER...",
                            ),
                          ),
                          TextFormField(
                            controller: startController,
                            decoration: InputDecoration(
                              hintText: "START...",
                            ),
                          ),
                          TextFormField(
                            controller: destinationController,
                            decoration: InputDecoration(
                              hintText: "DESTINATION...",
                            ),
                          ),
                          TextFormField(
                            controller: priceController,
                            decoration: InputDecoration(
                              hintText: "PRICE...",
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "Name is empty");
                                  return;
                                } else if (phonenumController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Phone number is empty");
                                  return;
                                } else if (startController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Start place is empty");
                                  return;
                                } else if (destinationController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Destination is empty");
                                  return;
                                } else if (priceController.text.isEmpty) {
                                  Fluttertoast.showToast(msg: "Price is empty");
                                  return;
                                } else {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  await FirebaseFirestore.instance
                                      .collection("records")
                                      .add({
                                    'uid': user?.uid,
                                    'name': nameController.text,
                                    'phonenum': phonenumController.text,
                                    'start': startController.text,
                                    'destination': destinationController.text,
                                    'price': int.parse(priceController.text),
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "Add record success",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Text('ADD'))
                        ],
                      ),
                    ),
                  ));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: role == 'user'
                    ? FirebaseFirestore.instance
                        .collection("records")
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("records")
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) => ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: Text(snapshot.data!.docs[index]['start'] +
                                ' - ' +
                                snapshot.data!.docs[index]['destination']),
                            title: Text(
                              snapshot.data!.docs[index]['name'],
                            ),
                            subtitle: Text(snapshot
                                .data!.docs[index]['phonenum']
                                .toString()),
                            trailing: Text(
                                snapshot.data!.docs[index]['price'].toString() +
                                    ' VND'),
                          ));
                },
              ),
            ],
          )),
    );
  }
}
