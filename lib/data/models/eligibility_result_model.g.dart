// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EligibilityResultModelAdapter
    extends TypeAdapter<EligibilityResultModel> {
  @override
  final int typeId = 2;

  @override
  EligibilityResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EligibilityResultModel(
      examId: fields[0] as String,
      isEligible: fields[1] as bool,
      missingCriteria: (fields[2] as List).cast<String>(),
      matchPercent: fields[3] as int,
      checkedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EligibilityResultModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.examId)
      ..writeByte(1)
      ..write(obj.isEligible)
      ..writeByte(2)
      ..write(obj.missingCriteria)
      ..writeByte(3)
      ..write(obj.matchPercent)
      ..writeByte(4)
      ..write(obj.checkedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EligibilityResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
