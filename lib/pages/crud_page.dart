import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  var firestoreDB = FirebaseFirestore.instance.collection("CRUD").snapshots();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController schoolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 600,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Card(
                color: Colors.greenAccent,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  child: ShowData(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  DisplayAlertDialog();
                },
                child: Card(
                    color: Colors.blueAccent,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("Fill Your Data"))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ShowData() {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("CRUD").snapshots(),
        builder: (context, snapshot) => snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) => CardPage(snapshot.data, index),
        )
            : Center(child: CircularProgressIndicator()),
      ),

      // child: StreamBuilder(
      //   stream: firestoreDB,
      //   builder: (context, snapshot){
      //     if(!snapshot.hasData){
      //         return CircularProgressIndicator();
      //     }else if(snapshot.hasData){
      //       return ListView.builder(
      //         itemCount: snapshot.data.docs.length,
      //         itemBuilder: (context, index){
      //           return CardPage(snapshot.data,index);
      //         },
      //       );
      //     }
      //   },
      // ),

      // child: StreamBuilder(
      //   stream: firestoreDB,
      //   builder: (context, snapshot) =>
      //   snapshot.hasData
      //       ? ListView.builder(
      //     itemCount: snapshot.data.docs.length,
      //     itemBuilder: (context, index) => CardPage(snapshot.data, index),
      //   )
      //       : Center(child: CircularProgressIndicator()),
      // ),
    );
  }


  void DisplayAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fill all the fields"),
        content: Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {},
                  controller: nameController,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Name",
                    prefixIcon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  onTap: () {},
                  controller: ageController,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Age",
                    prefixIcon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  onTap: () {},
                  controller: schoolController,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter School",
                    prefixIcon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Select"),
                onPressed: () {
                  DataStoreInFireStore();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  void DataStoreInFireStore() {
    if (nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        schoolController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("CRUD").add({
        "Name": nameController.text,
        "Age": ageController.text,
        "School": schoolController.text
      }).then((value) {
        nameController.clear();
        ageController.clear();
        schoolController.clear();
        Navigator.pop(context);
      });
    }
  }

  Widget CardPage(QuerySnapshot snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 5),
      child: SizedBox(
        height: 75,
        child: GestureDetector(
          onLongPress: (){
            Delete(snapshot,index);
          },
          onTap: (){
            UpdateDataAlertDialog(snapshot,index);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text(snapshot.docs[index]["Name"]))),
                  Expanded(
                    child: Center(child: Text(snapshot.docs[index]["Age"])),
                  ),
                  Expanded(child: Center(child: Text(snapshot.docs[index]["School"])))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Delete(QuerySnapshot snapshot, int index) {
    var docId = snapshot.docs[index].id;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Do you want to delete this Data?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Yes"),
                onPressed: (){
                  FirebaseFirestore.instance
                      .collection("CRUD")
                      .doc(docId)
                      .delete().then((value) => Navigator.pop(context));
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void UpdateDataAlertDialog(QuerySnapshot snapshot, int index) {

    TextEditingController upNameController = TextEditingController(text: snapshot.docs[index]["Name"]);
    TextEditingController upAgeController = TextEditingController(text: snapshot.docs[index]["Age"]);
    TextEditingController upSchoolController = TextEditingController(text: snapshot.docs[index]["School"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Data"),
        content: Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {},
                  controller: upNameController,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Name",
                    prefixIcon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  onTap: () {},
                  controller: upAgeController,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter Age",
                    prefixIcon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  onTap: () {},
                  controller: upSchoolController,
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Enter School",
                    prefixIcon: Icon(FontAwesomeIcons.pencilAlt),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Update"),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("CRUD")
                      .doc(snapshot.docs[index].id)
                      .update({
                    "Name" : upNameController.text,
                    "Age" : upAgeController.text,
                    "School" : upSchoolController.text,
                  }).then((value) => Navigator.pop(context));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
