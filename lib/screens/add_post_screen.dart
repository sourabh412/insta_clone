import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/models/user.dart' as model;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _loading = false;

  void selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text("Create a Post"),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Take a photo"),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Choose from gallery"),
            onPressed: () async {
              Navigator.pop(context);
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Cancel"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  void postImage(String uid, String username, String profImage,) async {
    setState(() {
      _loading = true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(_descriptionController.text.toString(), _file!, uid, username, profImage);
      setState(() {
        _loading = false;
      });
      if(res == "success"){
        showSnackBar("Posted!", context);
      } else{
        showSnackBar(res, context);
      }
      setState(() {
        _file = null;
      });
    } catch(e) {
      setState(() {
        _loading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    model.User user = Provider.of<UserProvider>(context).getUser;

    return (_file==null) ? Center(
      child: IconButton(
        icon: Icon(Icons.upload),
        onPressed: () => selectImage(context),
      ),
    ) : Scaffold(
      appBar: AppBar(
        title: const Text("Post to"),
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            _file = null;
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              postImage(user.uid,user.username,user.photoUrl);
              setState(() {
                _descriptionController.text = "";
              });
            },
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ),
        ],
      ),
      body: Column(
        children: [
          _loading ?
          const LinearProgressIndicator() :
          const Padding(padding: EdgeInsets.only(top: 0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
