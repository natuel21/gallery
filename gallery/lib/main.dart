import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<XFile>? _imageFileList;

  final ImagePicker _picker = ImagePicker();

  void _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFileList = selectedImages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery App"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _pickImages,
          ),
        ],
      ),
      body: _imageFileList != null && _imageFileList!.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageFileList!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageViewScreen(
                          imageFile: _imageFileList![index],
                        ),
                      ),
                    );
                  },
                  child: Image.file(
                    File(_imageFileList![index].path),
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
          : Center(
              child: Text('No images selected.'),
            ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final XFile imageFile;

  ImageViewScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: FileImage(File(imageFile.path)),
      ),
    );
  }
}
