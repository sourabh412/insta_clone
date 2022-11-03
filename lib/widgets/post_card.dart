import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:insta_clone/screens/comments_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widgets/line_animation.dart';
import 'package:intl/intl.dart';
import 'package:insta_clone/models/user.dart' as model;
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context) => Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          "Delete",
                        ].map((e) => InkWell(
                          onTap: () async {
                            String postId = widget.snap['postId'];
                            FirestoreMethods().deletePost(widget.snap['postId']);
                            Navigator.pop(context);
                            StorageMethods().deleteImage(postId);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                            child: Text(e),
                          ),
                        )).toList(),
                      ),
                    ));
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: double.infinity,
                  child: Image.network(widget.snap['postUrl'],
                  fit: BoxFit.cover,),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: (){
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite, color: Colors.white, size: 120,),
                  ),
                ),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid) ?
                    const Icon(Icons.favorite, color: Colors.red,) :
                    const Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsScreen(snap: widget.snap,)));
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.send),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                )
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.snap['likes'].length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "  ${widget.snap['description']}",
                        ),
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Text(
                      "View all comments",
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                        color: secondaryColor
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
