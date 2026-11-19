import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String tag; // 'Home', 'Work', 'Other'
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.tag,
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state - $pincode';

  @override
  List<Object?> get props => [
        id,
        tag,
        recipientName,
        phone,
        street,
        city,
        state,
        pincode,
        isDefault,
      ];
}
