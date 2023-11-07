import 'package:capstone/login_page/providers/feed/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class FeedUplaodScreen extends StatefulWidget {
  const FeedUplaodScreen({super.key});

  @override
  State<FeedUplaodScreen> createState() => _FeedUplaodScreenState();
}

class _FeedUplaodScreenState extends State<FeedUplaodScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _files = [];

  Future<List<String>> selectImages() async {
    List<XFile> images = await ImagePicker().pickMultiImage(
      maxHeight: 1024,
      maxWidth: 1024,
    );
    return images.map((e) => e.path).toList();
  }

  List<Widget> selectedImageList() {
    return _files.map((data){
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            ClipRRect(
              child: Image.file(
                File(data),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.4,
                width: 200,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _files.remove(data);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: 30,
                  width: 30,
                  child: Icon(
                    color: Colors.black.withOpacity(0.6),
                    size: 30,
                    Icons.highlight_remove_outlined,
                  ),
                ),
              ),
            ),
          ]
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.read<FeedProvider>().uploadFeed(
                  files: files,
                  desc: _textEditingController.text,
                  uid: uid,
              )
            },
            child: Text('Feed'),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final _images = await selectImages();
                      setState(() {
                        _files.addAll(_images);
                      });
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      child: const Icon(Icons.upload),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  ...selectedImageList(),
                ],
              ),
            ),
            if (_files.isNotEmpty)
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: '내용을 입력하세요...',
                border: InputBorder.none,
              ),
              maxLines: 5,
            )
          ]
        ),
      ),
    );
  }
}
