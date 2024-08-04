import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class SearchResultImage extends StatelessWidget {
  final XFile? firstImageFile;
  final XFile? secondImageFile;

  const SearchResultImage({Key? key, this.firstImageFile, this.secondImageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (firstImageFile != null)
              Image.file(File(firstImageFile!.path)),
            if (secondImageFile != null)
              Image.file(File(secondImageFile!.path)),
          ],
        ),
      ),
    );
  }
}

