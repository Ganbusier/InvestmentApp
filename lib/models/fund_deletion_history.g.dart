// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_deletion_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FundDeletionHistoryAdapter extends TypeAdapter<FundDeletionHistory> {
  @override
  final int typeId = 5;

  @override
  FundDeletionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FundDeletionHistory(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      deletedFunds: (fields[2] as List).cast<DeletedFundSnapshot>(),
      order: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FundDeletionHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.deletedFunds)
      ..writeByte(3)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FundDeletionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeletedFundSnapshotAdapter extends TypeAdapter<DeletedFundSnapshot> {
  @override
  final int typeId = 6;

  @override
  DeletedFundSnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeletedFundSnapshot(
      fundId: fields[0] as String,
      name: fields[1] as String,
      code: fields[2] as String,
      category: fields[3] as PortfolioCategory,
      amount: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DeletedFundSnapshot obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fundId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeletedFundSnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
