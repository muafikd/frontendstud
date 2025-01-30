class OrderItem {
  final String title;
  final String artist;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.title,
    required this.artist,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      title: json['title'],
      artist: json['artist'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
    );
  }
}