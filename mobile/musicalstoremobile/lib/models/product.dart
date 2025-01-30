class Product {
  final int? productId;
  final String title;
  final String artist;
  final String genre;
  final int releaseYear;
  final double price;
  final int stockQuantity;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Product({
    this.productId,
    required this.title,
    required this.artist,
    required this.genre,
    required this.releaseYear,
    required this.price,
    required this.stockQuantity,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      title: json['title'],
      artist: json['artist'],
      genre: json['genre'],
      releaseYear: json['releaseYear'],
      price: json['price'].toDouble(),
      stockQuantity: json['stockQuantity'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'artist': artist,
      'genre': genre,
      'releaseYear': releaseYear,
      'price': price,
      'stockQuantity': stockQuantity,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 