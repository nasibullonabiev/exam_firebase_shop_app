import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_app/models/post_model.dart';
import 'package:my_shop_app/pages/add_product_page.dart';
import 'dart:io';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/remote_service.dart';
import '../services/rtdb_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const String id  ='home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];
  List vegetables = [];
  List drink = [];
  List sweets = [];
  List milk = [];

  @override
  void initState() {
    super.initState();
    _getAllPost();
  }

  void _getAllPost() async {
     await RemoteService.initConfig();
    isLoading = true;
    setState(() {});

    String userId = await DBService.loadUserId() ?? "null";
    items = await RTDBService.loadPosts(userId);

    isLoading = false;
    setState(() {});
  }

  void _logout() {
    AuthService.signOutUser(context);
  }

  void _openAddPage() {

    ///  for check crashlytics
    // FirebaseCrashlytics.instance.crash();
    // throw Exception("Flutter B17 Erroor case");
    Navigator.pushNamed(context, AddProductPage.id);
  }

  void _deleteDialog(String postKey) async {
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Do you want to delete this post?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () => _deletePost(postKey),
                child: const Text("Confirm"),
              ),
              CupertinoDialogAction(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Do you want to delete this post?"),
            actions: [
              TextButton(
                onPressed: () => _deletePost(postKey),
                child: const Text("Confirm"),
              ),
              TextButton(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        }
      },
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _deletePost(String postKey) async {
    Navigator.pop(context);
    isLoading = true;
    setState(() {});

    await RTDBService.deletePost(postKey);
    _getAllPost();
  }

  void _editPost(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddProductPage(
            state: DetailState.update,
            post: post,
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  RemoteService.availableBackgroundColors[RemoteService.background_color],
        title: const Text('My Shop App Exam',style: TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
      actions:  [
       Padding(
         padding: EdgeInsets.only(right: 10),
         child: GestureDetector(
           onTap: _openAddPage,
             child: RemoteService.isSpecialDay ? const Icon(Icons.functions) : const Icon(Icons.ac_unit_outlined),))
      ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.teal.shade800,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Drawer Header'),
            ),

            const SizedBox(height: 600,),

            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green
                  ),
                  onPressed: _logout, child: const Text("Log Out")),
            )

          ],
        ),
      ),
      body: Column(
        children: [
          const Text("Drinks",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
          Expanded(
            child: GridView.builder(
              itemCount: items.length,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 7,crossAxisSpacing: 7),
                itemBuilder: (context,index){
                 return _itemOfList(items[index]);
                }
            ),
          ),
          
          const Text("Vegetables",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context,index){
                  return _itemOfList(items[index]);


                }),
          ),




        ],
      ),


    );
  }
  Widget _itemOfList(Post post){
    return GestureDetector(
      onLongPress: () => _deleteDialog(post.postKey),
      onDoubleTap: () => _editPost(post),
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => DetailPage(post: post)));
      },
      child: Container(
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Card(
              color: Colors.teal.shade800,
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                    width: 207,
                    child: Hero(
                        tag: post.image != null ? Image.network(post.image!,height: 30,width: 30,fit: BoxFit.fill,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 200,fit: BoxFit.cover),
                        child : post.image != null ? Image.network(post.image!,height: 30,width: 30,fit: BoxFit.cover,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 200,fit: BoxFit.cover)),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.zero,
                        // padding: const EdgeInsets.only(left:20),
                        child: Text( "${post.name}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),),
                      ),
                    ],
                  ),

                  const Text("Starts from:",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w800,color: Colors.white),),
                  Text("\$ ${post.price}",style: const TextStyle(fontWeight: FontWeight.w800,fontStyle: FontStyle.italic,color: Colors.white),),

                  const Divider(),

                ],
              ),
            ),
          )
      ),
    );
  }
}
