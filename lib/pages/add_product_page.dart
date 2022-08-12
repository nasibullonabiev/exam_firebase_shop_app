import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_shop_app/models/post_model.dart';
import 'dart:io';

import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/rtdb_service.dart';
import '../services/store_service.dart';
import '../services/util_service.dart';

enum DetailState {
  create,
  update,
}
class AddProductPage extends StatefulWidget {

  static const String id = 'add_product_page';
  final DetailState state;
  final Post? post;

  const AddProductPage({Key? key,this.state = DetailState.create,this.post}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDateController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  bool isFavorite = false;
  bool isLoading = false;
  Post? updatePost;

  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    _detectState();
  }
  void _detectState(){
    if(widget.state == DetailState.update && widget.post != null){
      updatePost = widget.post;
      productNameController.text = updatePost!.name;
      productCategoryController.text = updatePost!.category;
      productDateController.text = updatePost!.date;
      productDescriptionController.text = updatePost!.description;
      isFavorite = updatePost!.isFavorite!;
      setState(() {
      });
    }

  }

  void _getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {
      if (mounted) Utils.fireSnackBar("Please select image for post", context);
    }
  }

  void _addPost()async{
    String productName = productNameController.text.trim();
    String productPrice = productPriceController.text.trim();
    String productCategory = productCategoryController.text.trim();
    String productDescription = productDescriptionController.text.trim();
    String productDate = productDateController.text.trim();
    String? imageUrl;

    if (productName.isEmpty ||
        productDate.isEmpty ||
        productDescription.isEmpty ||
        productPrice.isEmpty ||
        productCategory.isEmpty
    ) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});
    String? userId = await DBService.loadUserId();

    if (userId == null) {
      if (mounted) {
        Navigator.pop(context);
        AuthService.signOutUser(context);
      }
      return;
    }

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }
    Post post = Post(
      userId: userId,
      name: productName,
      image: imageUrl,
      postKey: '',
      price: productPrice,
      date: productDate,
      category: productCategory,
      description: productDescription
    );

    await RTDBService.storePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }


  void _updatePost()async{
    String productName = productNameController.text.trim();
    String productPrice = productPriceController.text.trim();
    String productCategory = productCategoryController.text.trim();
    String productDescription = productDescriptionController.text.trim();
    String productDate = productDateController.text.trim();
    String? imageUrl;
    if (productName.isEmpty ||
        productDate.isEmpty ||
        productDescription.isEmpty ||
        productPrice.isEmpty ||
        productCategory.isEmpty
    ) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }

    Post post = Post(
        userId: updatePost!.userId,
        name: productName,
        image: imageUrl ?? updatePost!.image,
        postKey: updatePost!.postKey,
        price: productPrice,
        date: productDate,
        category: productCategory,
        description: productDescription
    );

    await RTDBService.updatePost(post).then((value) {
      Navigator.of(context).pop();
    });
    isLoading = false;
    setState(() {});
  }

  void _selectDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2122),
    ).then((date) {
      if (date != null) {
        productDateController.text = date.toString();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade800,
        title: widget.state == DetailState.update
            ? const Text("Update Post")
            : const Text("Add your product here!"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // #image
                  GestureDetector(
                    onTap: _getImage,
                    child: SizedBox(
                      height: 125,
                      width: 125,
                      child: (updatePost != null &&
                          updatePost!.image != null &&
                          file == null)
                          ? Image.network(updatePost!.image!)
                          : (file == null
                          ?  Icon(Icons.add_circle_outlined,size: 100,color: Colors.teal.shade800,)
                          : Image.file(file!)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #productCategory
                  TextField(
                    controller: productCategoryController,
                    decoration: const InputDecoration(
                      hintText: "Product Category",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #productName
                  TextField(
                    controller: productNameController,
                    decoration: const InputDecoration(
                      hintText: "Product Name",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #productPrice
                  TextField(
                    controller: productPriceController,
                    decoration: const InputDecoration(
                      hintText: "Product price",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #productDescription
                  TextField(
                    controller: productDescriptionController,
                    decoration: const InputDecoration(
                      hintText: "Product description",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #productDescription
                  TextField(
                    controller: productDateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      hintText: "Date",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #add_update
                  ElevatedButton(
                    onPressed: () {
                      if (widget.state == DetailState.update) {
                        _updatePost();
                      } else {
                        _addPost();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade800,
                      shape: StadiumBorder(),
                        minimumSize: const Size(double.infinity, 50)),
                    child: Text(
                      widget.state == DetailState.update ? "Update" : "Add",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
