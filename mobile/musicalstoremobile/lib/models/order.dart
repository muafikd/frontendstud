class Order {
  final int orderId;
  final String orderStatus;
  final double totalPrice;
  final DateTime placedAt;

  Order({
    required this.orderId,
    required this.orderStatus,
    required this.totalPrice,
    required this.placedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        orderId: json['orderId'] as int,
        orderStatus: json['orderStatus'] as String,
        totalPrice: (json['totalPrice'] as num).toDouble(),
        placedAt: DateTime.parse(json['placedAt'] as String),
      );
    } catch (e) {
      print('Error parsing JSON: $json');
      print('Error details: $e');
      rethrow;
    }
  }
}

class OrderDetails {
  final String orderId;
  final String orderStatus;
  final double totalPrice;
  final DateTime placedAt;
  final List<OrderItem> items;

  OrderDetails({
    required this.orderId,
    required this.orderStatus,
    required this.totalPrice,
    required this.placedAt,
    required this.items,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      orderId: json['orderId'].toString(),
      orderStatus: json['orderStatus'],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      placedAt: DateTime.parse(json['placedAt']),
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'],
      quantity: json['quantity'],
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}