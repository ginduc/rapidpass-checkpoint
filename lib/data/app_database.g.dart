// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class QrDataEntry extends DataClass implements Insertable<QrDataEntry> {
  final int id;
  final int controlCode;
  final int validFrom;
  final int validUntil;
  final bool idOrPlate;
  final String company;
  final String homeAddress;
  QrDataEntry(
      {@required this.id,
      @required this.controlCode,
      @required this.validFrom,
      @required this.validUntil,
      @required this.idOrPlate,
      @required this.company,
      @required this.homeAddress});
  factory QrDataEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final stringType = db.typeSystem.forDartType<String>();
    return QrDataEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      controlCode: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}control_code']),
      validFrom:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}valid_from']),
      validUntil: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}valid_until']),
      idOrPlate: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}id_or_plate']),
      company:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}company']),
      homeAddress: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}home_address']),
    );
  }
  factory QrDataEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return QrDataEntry(
      id: serializer.fromJson<int>(json['id']),
      controlCode: serializer.fromJson<int>(json['controlCode']),
      validFrom: serializer.fromJson<int>(json['validFrom']),
      validUntil: serializer.fromJson<int>(json['validUntil']),
      idOrPlate: serializer.fromJson<bool>(json['idOrPlate']),
      company: serializer.fromJson<String>(json['company']),
      homeAddress: serializer.fromJson<String>(json['homeAddress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'controlCode': serializer.toJson<int>(controlCode),
      'validFrom': serializer.toJson<int>(validFrom),
      'validUntil': serializer.toJson<int>(validUntil),
      'idOrPlate': serializer.toJson<bool>(idOrPlate),
      'company': serializer.toJson<String>(company),
      'homeAddress': serializer.toJson<String>(homeAddress),
    };
  }

  @override
  QrDataCompanion createCompanion(bool nullToAbsent) {
    return QrDataCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      controlCode: controlCode == null && nullToAbsent
          ? const Value.absent()
          : Value(controlCode),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      idOrPlate: idOrPlate == null && nullToAbsent
          ? const Value.absent()
          : Value(idOrPlate),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      homeAddress: homeAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(homeAddress),
    );
  }

  QrDataEntry copyWith(
          {int id,
          int controlCode,
          int validFrom,
          int validUntil,
          bool idOrPlate,
          String company,
          String homeAddress}) =>
      QrDataEntry(
        id: id ?? this.id,
        controlCode: controlCode ?? this.controlCode,
        validFrom: validFrom ?? this.validFrom,
        validUntil: validUntil ?? this.validUntil,
        idOrPlate: idOrPlate ?? this.idOrPlate,
        company: company ?? this.company,
        homeAddress: homeAddress ?? this.homeAddress,
      );
  @override
  String toString() {
    return (StringBuffer('QrDataEntry(')
          ..write('id: $id, ')
          ..write('controlCode: $controlCode, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('idOrPlate: $idOrPlate, ')
          ..write('company: $company, ')
          ..write('homeAddress: $homeAddress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          controlCode.hashCode,
          $mrjc(
              validFrom.hashCode,
              $mrjc(
                  validUntil.hashCode,
                  $mrjc(idOrPlate.hashCode,
                      $mrjc(company.hashCode, homeAddress.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is QrDataEntry &&
          other.id == this.id &&
          other.controlCode == this.controlCode &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.idOrPlate == this.idOrPlate &&
          other.company == this.company &&
          other.homeAddress == this.homeAddress);
}

class QrDataCompanion extends UpdateCompanion<QrDataEntry> {
  final Value<int> id;
  final Value<int> controlCode;
  final Value<int> validFrom;
  final Value<int> validUntil;
  final Value<bool> idOrPlate;
  final Value<String> company;
  final Value<String> homeAddress;
  const QrDataCompanion({
    this.id = const Value.absent(),
    this.controlCode = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.idOrPlate = const Value.absent(),
    this.company = const Value.absent(),
    this.homeAddress = const Value.absent(),
  });
  QrDataCompanion.insert({
    this.id = const Value.absent(),
    @required int controlCode,
    @required int validFrom,
    @required int validUntil,
    @required bool idOrPlate,
    @required String company,
    @required String homeAddress,
  })  : controlCode = Value(controlCode),
        validFrom = Value(validFrom),
        validUntil = Value(validUntil),
        idOrPlate = Value(idOrPlate),
        company = Value(company),
        homeAddress = Value(homeAddress);
  QrDataCompanion copyWith(
      {Value<int> id,
      Value<int> controlCode,
      Value<int> validFrom,
      Value<int> validUntil,
      Value<bool> idOrPlate,
      Value<String> company,
      Value<String> homeAddress}) {
    return QrDataCompanion(
      id: id ?? this.id,
      controlCode: controlCode ?? this.controlCode,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      idOrPlate: idOrPlate ?? this.idOrPlate,
      company: company ?? this.company,
      homeAddress: homeAddress ?? this.homeAddress,
    );
  }
}

class $QrDataTable extends QrData with TableInfo<$QrDataTable, QrDataEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $QrDataTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _controlCodeMeta =
      const VerificationMeta('controlCode');
  GeneratedIntColumn _controlCode;
  @override
  GeneratedIntColumn get controlCode =>
      _controlCode ??= _constructControlCode();
  GeneratedIntColumn _constructControlCode() {
    return GeneratedIntColumn(
      'control_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _validFromMeta = const VerificationMeta('validFrom');
  GeneratedIntColumn _validFrom;
  @override
  GeneratedIntColumn get validFrom => _validFrom ??= _constructValidFrom();
  GeneratedIntColumn _constructValidFrom() {
    return GeneratedIntColumn(
      'valid_from',
      $tableName,
      false,
    );
  }

  final VerificationMeta _validUntilMeta = const VerificationMeta('validUntil');
  GeneratedIntColumn _validUntil;
  @override
  GeneratedIntColumn get validUntil => _validUntil ??= _constructValidUntil();
  GeneratedIntColumn _constructValidUntil() {
    return GeneratedIntColumn(
      'valid_until',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idOrPlateMeta = const VerificationMeta('idOrPlate');
  GeneratedBoolColumn _idOrPlate;
  @override
  GeneratedBoolColumn get idOrPlate => _idOrPlate ??= _constructIdOrPlate();
  GeneratedBoolColumn _constructIdOrPlate() {
    return GeneratedBoolColumn(
      'id_or_plate',
      $tableName,
      false,
    );
  }

  final VerificationMeta _companyMeta = const VerificationMeta('company');
  GeneratedTextColumn _company;
  @override
  GeneratedTextColumn get company => _company ??= _constructCompany();
  GeneratedTextColumn _constructCompany() {
    return GeneratedTextColumn(
      'company',
      $tableName,
      false,
    );
  }

  final VerificationMeta _homeAddressMeta =
      const VerificationMeta('homeAddress');
  GeneratedTextColumn _homeAddress;
  @override
  GeneratedTextColumn get homeAddress =>
      _homeAddress ??= _constructHomeAddress();
  GeneratedTextColumn _constructHomeAddress() {
    return GeneratedTextColumn(
      'home_address',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, controlCode, validFrom, validUntil, idOrPlate, company, homeAddress];
  @override
  $QrDataTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'qr_data';
  @override
  final String actualTableName = 'qr_data';
  @override
  VerificationContext validateIntegrity(QrDataCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.controlCode.present) {
      context.handle(_controlCodeMeta,
          controlCode.isAcceptableValue(d.controlCode.value, _controlCodeMeta));
    } else if (isInserting) {
      context.missing(_controlCodeMeta);
    }
    if (d.validFrom.present) {
      context.handle(_validFromMeta,
          validFrom.isAcceptableValue(d.validFrom.value, _validFromMeta));
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (d.validUntil.present) {
      context.handle(_validUntilMeta,
          validUntil.isAcceptableValue(d.validUntil.value, _validUntilMeta));
    } else if (isInserting) {
      context.missing(_validUntilMeta);
    }
    if (d.idOrPlate.present) {
      context.handle(_idOrPlateMeta,
          idOrPlate.isAcceptableValue(d.idOrPlate.value, _idOrPlateMeta));
    } else if (isInserting) {
      context.missing(_idOrPlateMeta);
    }
    if (d.company.present) {
      context.handle(_companyMeta,
          company.isAcceptableValue(d.company.value, _companyMeta));
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (d.homeAddress.present) {
      context.handle(_homeAddressMeta,
          homeAddress.isAcceptableValue(d.homeAddress.value, _homeAddressMeta));
    } else if (isInserting) {
      context.missing(_homeAddressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QrDataEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return QrDataEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(QrDataCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.controlCode.present) {
      map['control_code'] = Variable<int, IntType>(d.controlCode.value);
    }
    if (d.validFrom.present) {
      map['valid_from'] = Variable<int, IntType>(d.validFrom.value);
    }
    if (d.validUntil.present) {
      map['valid_until'] = Variable<int, IntType>(d.validUntil.value);
    }
    if (d.idOrPlate.present) {
      map['id_or_plate'] = Variable<bool, BoolType>(d.idOrPlate.value);
    }
    if (d.company.present) {
      map['company'] = Variable<String, StringType>(d.company.value);
    }
    if (d.homeAddress.present) {
      map['home_address'] = Variable<String, StringType>(d.homeAddress.value);
    }
    return map;
  }

  @override
  $QrDataTable createAlias(String alias) {
    return $QrDataTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $QrDataTable _qrData;
  $QrDataTable get qrData => _qrData ??= $QrDataTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [qrData];
}
