import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {

  File? _image;  ///jo gallery sy hum image pick karty han wo aik file hoti ha
  final picker=ImagePicker();


  Future getGalleryImage()async
  {
    final pickedFile=await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedFile==null)
      {
        debugPrint('image not picked');
      }
      else
      {
        _image=File(pickedFile.path);///agar uppar picker ky sath await na pagay gy tu .path show na ho ga.
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await  SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title:const Text("Image",style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),

        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
                InkWell(
                onTap: (){
                  getGalleryImage();
                },
                child:Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child:_image!=null?Image.file(_image!.absolute): const Icon(Icons.image),
                ),
              ),

              ElevatedButton(
                  onPressed: (){
                  },
                  child:const Text("Upload"))
            ],
          ),
        ),

      ),
    );
  }
}
