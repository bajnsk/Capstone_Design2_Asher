import 'package:flutter/material.dart';

class appbar extends StatefulWidget {
  const appbar({super.key});

  @override
  State<appbar> createState() => _appbarState();
}

class _appbarState extends State<appbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Asher',),
          centerTitle: true,

          actions: <Widget>[
            SizedBox(width: 20,),
            Padding(
              padding:EdgeInsets.only(right: 40),
              child: IconButton(
                onPressed: (){
                  // 버튼을 눌렀을 때 수행할 동작 추가할것
                },
                icon: Icon(Icons.notifications,color: Colors.black,size: 30,),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: (){
                  // 버튼을 눌렀을 때 수행할 동작 추가할것
                },
                icon: Icon(Icons.mail,color: Colors.black,size: 30,),
              ),
            ),
          ],
        )
    );
  }
}