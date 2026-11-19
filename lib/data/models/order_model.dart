import 'package:equatable/equatable.dart';
import 'cart_item_model.dart';
import 'address_model.dart';

enum OrderStatus { placed, confirmed, shipped, delivered, cancelled }

class OrderModel extends Equatable {
  final String id;
  final List<CartItemModel> items;
  final DateTime orderDate;
  final OrderStatus status;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final String paymentMethod;
  final AddressModel deliveryAddress;

  const OrderModel({
    required this.id,
    required this.items,
    required this.orderDate,
    required this.status,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        orderDate,
        status,
        subTotal,
        discount,
        totalAmount,
        paymentMethod,
        deliveryAddress,
      ];
}
