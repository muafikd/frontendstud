class CartItem {
  final int cartItemId;
  final String productName;
  final int quantity;
  final double productPrice;
  final double totalPrice;

  CartItem({
    required this.cartItemId,
    required this.productName,
    required this.quantity,
    required this.productPrice,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] ?? 0,
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
} 