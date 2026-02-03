// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rebalance_snapshot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RebalanceSnapshotAdapter extends TypeAdapter<RebalanceSnapshot> {
  @override
  final int typeId = 3;

  @override
  RebalanceSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RebalanceSnapshot(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      funds: (fields[2] as List).cast<FundSnapshot>(),
      totalAmount: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RebalanceSnapshot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.funds)
      ..writeByte(3)
      ..write(obj.totalAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RebalanceSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FundSnapshotAdapter extends TypeAdapter<FundSnapshot> {
  @override
  final int typeId = 4;

  @override
  FundSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FundSnapshot(
      fundId: fields[0] as String,
      name: fields[1] as String,
      code: fields[4] as String,
      category: fields[2] as PortfolioCategory,
      amount: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FundSnapshot obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fundId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
