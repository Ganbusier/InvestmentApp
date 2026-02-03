// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FundAdapter extends TypeAdapter<Fund> {
  @override
  final int typeId = 1;

  @override
  Fund read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fund(
      id: fields[0] as String?,
      name: fields[1] as String,
      code: fields[2] as String,
      amount: fields[3] as double,
      category: fields[4] as PortfolioCategory,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Fund obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PortfolioCategoryAdapter extends TypeAdapter<PortfolioCategory> {
  @override
  final int typeId = 0;

  @override
  PortfolioCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PortfolioCategory.stock;
      case 1:
        return PortfolioCategory.bond;
      case 2:
        return PortfolioCategory.cash;
      case 3:
        return PortfolioCategory.gold;
      default:
        return PortfolioCategory.stock;
    }
  }

  @override
  void write(BinaryWriter writer, PortfolioCategory obj) {
    switch (obj) {
      case PortfolioCategory.stock:
        writer.writeByte(0);
        break;
      case PortfolioCategory.bond:
        writer.writeByte(1);
        break;
      case PortfolioCategory.cash:
        writer.writeByte(2);
        break;
      case PortfolioCategory.gold:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PortfolioCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
