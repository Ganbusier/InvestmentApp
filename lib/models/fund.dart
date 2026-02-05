import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'fund.g.dart';

@HiveType(typeId: 0)
enum PortfolioCategory {
  @HiveField(0)
  stock,
  @HiveField(1)
  bond,
  @HiveField(2)
  cash,
  @HiveField(3)
  gold,
}

extension PortfolioCategoryExtension on PortfolioCategory {
  String get displayName {
    switch (this) {
      case PortfolioCategory.stock:
        return '股票';
      case PortfolioCategory.bond:
        return '债券';
      case PortfolioCategory.cash:
        return '现金';
      case PortfolioCategory.gold:
        return '黄金';
    }
  }

  double get targetPercentage {
    return 0.25;
  }
}

@HiveType(typeId: 1)
class Fund {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final PortfolioCategory category;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;

  Fund({
    String? id,
    required this.name,
    required this.code,
    required this.amount,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Fund copyWith({
    String? name,
    String? code,
    double? amount,
    PortfolioCategory? category,
  }) {
    return Fund(
      id: id,
      name: name ?? this.name,
      code: code ?? this.code,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fund &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          code == other.code &&
          amount == other.amount &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      amount.hashCode ^
      category.hashCode;
}
