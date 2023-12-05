import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagDetailPageWidget extends StatefulWidget {
  const TagDetailPageWidget({super.key});

  @override
  State<TagDetailPageWidget> createState() => _TagDetailPageWidgetState();
}

class _TagDetailPageWidgetState extends State<TagDetailPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          child: Column(
            children: [
              // 날짜 컨테이너
              Container(
                padding: EdgeInsets.only(top: 10,left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  'date',
                  style: TextStyle(fontSize: 16,color: Colors.grey),
                ),
              ),
              // 사진 컨테이너
              Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width-50,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                          'image'
                      ),
                    ),
                  ),
                ),
              ),
              // 본문 컨테이너
              Container(
                padding: const EdgeInsets.only(left: 50,right: 50,top: 10),
                width: MediaQuery.of(context).size.width-50,
                child: Text(
                    '본문 텍스트'
                ),
              ),
              // 태그 컨테이너
              Container(
                padding: EdgeInsets.only(left: 50,right: 50,top: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('123'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('456'),
                    ),
                  ],
                ),
              ),
              // 마음, 댁슬, 리컨텐츠 컨테이너
              Container(
                margin: EdgeInsets.only(left: 30,right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.heart),
                        SizedBox(width: 10,),
                        Icon(Icons.message)
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.repeat)
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
