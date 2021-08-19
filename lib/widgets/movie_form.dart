import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MovieForm extends StatefulWidget {
  final String? name;
  final String? director;
  final Uint8List? posterImage;
  final String buttonText;
  final Function onSubmit;

  const MovieForm({
    Key? key,
    this.name,
    this.director,
    this.posterImage,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();

  XFile? _pickedImage;
  TextEditingController _name = TextEditingController();
  TextEditingController _director = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _name = TextEditingController(text: widget.name != null ? widget.name : '');
    _director = TextEditingController(
        text: widget.director != null ? widget.director : '');
    super.initState();
  }

  void onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Uint8List? posterImage = widget.posterImage;
      if (_pickedImage != null) {
        posterImage = await _pickedImage?.readAsBytes();
      }
      widget.onSubmit(context, _name.text, _director.text, posterImage);
    }
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _pickedImage = pickedFile;
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Movie Poster",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(
                  CupertinoIcons.photo_camera_solid,
                  size: 30.0,
                ),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text(
                  "Camera",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              TextButton.icon(
                icon: Icon(CupertinoIcons.photo, size: 30.0),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text(
                  "Gallery",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget posterImage() {
    Widget poster;
    if (_pickedImage == null && widget.posterImage == null) {
      poster = Image(image: AssetImage('assets/images/movie.png'));
    } else if (_pickedImage == null) {
      poster = Image.memory(widget.posterImage as Uint8List);
    } else {
      poster = Image(image: FileImage(File(_pickedImage!.path)));
    }

    return Center(
      child: Stack(
        children: [
          Container(
            child: poster,
            width: MediaQuery.of(context).size.width,
            height: 250,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                CupertinoIcons.photo_camera_solid,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget movieNameField() {
    return TextFormField(
      controller: _name,
      decoration: InputDecoration(
        hintText: "Enter Movie Name",
        labelText: "Name",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Movie Name cannot be empty";
        }
        if (value.length > 25) {
          return "Movie Name should be less than 25 characters";
        }
      },
      maxLength: 25,
    );
  }

  Widget directorNameField() {
    return TextFormField(
      controller: _director,
      decoration: InputDecoration(
        hintText: "Enter Director",
        labelText: "Director",
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Director cannot be empty";
        }
        if (value.length > 25) {
          return "Movie Name should be less than 25 characters";
        }
      },
      maxLength: 25,
    );
  }

  Widget submitButton(BuildContext context) {
    return Material(
      color: Colors.deepPurple,
      child: InkWell(
        onTap: () => onSubmit(context),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 150,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                ),
                posterImage(),
                SizedBox(
                  height: 40.0,
                ),
                movieNameField(),
                SizedBox(
                  height: 20.0,
                ),
                directorNameField(),
                SizedBox(
                  height: 40.0,
                ),
                submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
