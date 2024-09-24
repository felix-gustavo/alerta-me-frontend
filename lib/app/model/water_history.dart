import 'dart:convert';

import '../shared/extensions/datetime_extension.dart';
import '../shared/extensions/string_extension.dart';

class WaterHistory {
  final String id;
  final int? amount;
  final int suggestedAmount;
  final DateTime datetime;

  WaterHistory({
    required this.id,
    required this.amount,
    required this.suggestedAmount,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'suggested_amount': suggestedAmount,
      'datetime': datetime.toUtcDateTime,
    };
  }

  factory WaterHistory.fromMap(Map<String, dynamic> map) {
    return WaterHistory(
      id: map['id'] as String,
      amount: map['amount'],
      suggestedAmount: map['suggested_amount'] as int,
      datetime: (map['datetime'] as String).stringUTCtoDateTime,
    );
  }

  String toJson() => json.encode(toMap());

  factory WaterHistory.fromJson(String source) =>
      WaterHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WaterHistory(id: $id, amount: $amount, suggestedAmount: $suggestedAmount, datetime: $datetime)';
  }
}
