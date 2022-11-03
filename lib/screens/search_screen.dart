import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: "Search for a user",
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username', isGreaterThanOrEqualTo: _searchController.text.toString()).get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index){
              return ListTile(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid']))),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl']),
                ),
                title: Text((snapshot.data! as dynamic).docs[index]['username']),
              );
            }
          );
        },
      ) : FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.custom(
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [
                const QuiltedGridTile(2, 2),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => GridTile(
                child: Image.network((snapshot.data! as dynamic).docs[index]['postUrl'],fit: BoxFit.cover,),
              ),childCount: (snapshot.data! as dynamic).docs.length,
            ),
          );
        }
      ),
    );
  }
}
