import '../../domain/entities/call_entity.dart';

class CallModel extends CallEntity {
  const CallModel({
    required super.id,
    required super.name,
    required super.phone,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
