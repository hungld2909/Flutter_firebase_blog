
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/photoUpload.dart';
import 'authentication.dart';
import 'posts.dart';
import 'package:firebase_database/firebase_database.dart';
class HomePage extends StatefulWidget {
   
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
// https://www.youtube.com/watch?v=ZiagJJTqnZQ&list=PLxefhmF0pcPlw2kf-3PAPruUjqDYEEsRb&index=11
  const HomePage({this.auth, this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Posts> postList = [];
  @override
  void initState() {
    super.initState();
  DatabaseReference postsRef =  FirebaseDatabase.instance.reference().child("Posts");
  postsRef.once().then((DataSnapshot snap){
    var KEYS = snap.value.keys;
    var DATA = snap.value;
    postList.clear();
    for(var individualKey in KEYS){
      Posts posts = Posts(
        DATA[individualKey]['image'],
        DATA[individualKey]['description'],
        DATA[individualKey]['date'],
        DATA[individualKey]['time'],

      );
        postList.add(posts);
    }
    setState(() {
      print('Length: $postList.legth');
    });
  });
  }

  void _logoutUser()async{
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: postList.length == 0 ? Text("No Blog Post available") : ListView.builder(
          itemCount: postList.length,
          itemBuilder: (_,index){
            return PostsUI(postList[index].image,postList[index].description,postList[index].date,postList[index].time,);
          }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: EdgeInsets.only(left: 70,right: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.local_car_wash),
                iconSize: 40,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return UploadPhotoPage();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget PostsUI(String image,String description,String date,String time){
  return Card(
    elevation: 10.0,
    margin: EdgeInsets.all(15.0),
    child: Container(
      padding: EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                  Text(date, 
          style: Theme.of(context).textTheme.subtitle,
          textAlign: TextAlign.center,
          ),
            Text(time, 
          style: Theme.of(context).textTheme.subtitle,
          textAlign: TextAlign.center,
          ),
     
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Image.network(image,fit: BoxFit.cover,),
          SizedBox(
            height: 10,
          ),
           Text(description, 
          style: Theme.of(context).textTheme.subhead,
          textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
}

