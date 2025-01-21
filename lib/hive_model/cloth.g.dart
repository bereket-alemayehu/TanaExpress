// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'cloth.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class ClothAdapter extends TypeAdapter<Cloth> {
//   @override
//   final int typeId = 0;

//   @override
//   Cloth read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Cloth(
//       name: fields[0] as String,
//       color: fields[1] as String,
//       price: fields[2] as int,
//       size: fields[3] as double,
//       type: fields[4] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Cloth obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.name)
//       ..writeByte(1)
//       ..write(obj.color)
//       ..writeByte(2)
//       ..write(obj.price)
//       ..writeByte(3)
//       ..write(obj.size)
//       ..writeByte(4)
//       ..write(obj.type);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ClothAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
