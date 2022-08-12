class Post{
  late String postKey;
  late String userId;
  late String name;
  late String category;
  bool? isFavorite;
  late String date;
  late String price;
  late String description;
  String? image;

  Post({
    required this.postKey,
    required this.userId,
    required this.name,
    required this.category,
     this.isFavorite,
    required this.date,
    required this.price,
    required this.description,
    this.image
});

  Post.fromJson(Map<String,dynamic> json){
    userId = json['userId'];
    postKey = json['postKey'];
    name = json['name'];
    category = json['category'];
    isFavorite = json['isFavorite'];
    date = json['date'];
    price = json['price'];
    description = json['description'];
    image = json['image'];
  }


  Map<String,dynamic> toJson() => {
     'userId' : userId,
      'postKey' : postKey,
    'name' : name,
    "category" : category,
    'isFavorite' : isFavorite,
    'date' : date,
    "price" : price,
    "description" : description,
    'image' : image
  };

}