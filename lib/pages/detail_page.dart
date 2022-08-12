import 'package:flutter/material.dart';
import 'package:my_shop_app/models/post_model.dart';
import 'package:my_shop_app/views/heart_animation.dart';

class DetailPage extends StatelessWidget {
  Post post;
  static const String id = 'detail_page';

   DetailPage({Key? key,required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 25,)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration:   BoxDecoration(
          color: Colors.teal.shade800
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              child: Hero(
                tag: post.image != null ? Image.network(post.image!,height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,),
                child: post.image != null ? Image.network(post.image!,height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,),
              ),
            ),

            const SizedBox(height: 30,),

            ListTile(
              title: Text("${post.category}: ${post.name}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),),
              subtitle: Row(
                children: [
                  const Text("Starts from:",style: TextStyle(color: Colors.white,fontSize: 20),),
                  const SizedBox(width: 5,),
                  Text("\$${post.price}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)
                ],
              ),
              trailing: const Heart(),
            ),
            Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                    post.description,
                    style: const TextStyle(
                        color: Colors.white,
                        height: 1.4
                    )
                )
            ),


          ],
        ),
      ),

    );
  }
}
