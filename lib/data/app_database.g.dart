// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ValidPass extends DataClass implements Insertable<ValidPass> {
  final int id;
  final int passType;
  final String apor;
  final int controlCode;
  final int issuedOn;
  final int validFrom;
  final int validUntil;
  final String idType;
  final String idOrPlate;
  final String company;
  final String homeAddress;
  ValidPass(
      {@required this.id,
      @required this.passType,
      @required this.apor,
      @required this.controlCode,
      @required this.issuedOn,
      @required this.validFrom,
      @required this.validUntil,
      @required this.idType,
      @required this.idOrPlate,
      this.company,
      this.homeAddress});
  factory ValidPass.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return ValidPass(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      passType:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}pass_type']),
      apor: stringType.mapFromDatabaseResponse(data['${effectivePrefix}apor']),
      controlCode: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}control_code']),
      issuedOn:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}issued_on']),
      validFrom:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}valid_from']),
      validUntil: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}valid_until']),
      idType:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}id_type']),
      idOrPlate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}id_or_plate']),
      company:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}company']),
      homeAddress: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}home_address']),
    );
  }
  factory ValidPass.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ValidPass(
      id: serializer.fromJson<int>(json['id']),
      passType: serializer.fromJson<int>(json['passType']),
      apor: serializer.fromJson<String>(json['apor']),
      controlCode: serializer.fromJson<int>(json['controlCode']),
      issuedOn: serializer.fromJson<int>(json['issuedOn']),
      validFrom: serializer.fromJson<int>(json['validFrom']),
      validUntil: serializer.fromJson<int>(json['validUntil']),
      idType: serializer.fromJson<String>(json['idType']),
      idOrPlate: serializer.fromJson<String>(json['idOrPlate']),
      company: serializer.fromJson<String>(json['company']),
      homeAddress: serializer.fromJson<String>(json['homeAddress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'passType': serializer.toJson<int>(passType),
      'apor': serializer.toJson<String>(apor),
      'controlCode': serializer.toJson<int>(controlCode),
      'issuedOn': serializer.toJson<int>(issuedOn),
      'validFrom': serializer.toJson<int>(validFrom),
      'validUntil': serializer.toJson<int>(validUntil),
      'idType': serializer.toJson<String>(idType),
      'idOrPlate': serializer.toJson<String>(idOrPlate),
      'company': serializer.toJson<String>(company),
      'homeAddress': serializer.toJson<String>(homeAddress),
    };
  }

  @override
  ValidPassesCompanion createCompanion(bool nullToAbsent) {
    return ValidPassesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      passType: passType == null && nullToAbsent
          ? const Value.absent()
          : Value(passType),
      apor: apor == null && nullToAbsent ? const Value.absent() : Value(apor),
      controlCode: controlCode == null && nullToAbsent
          ? const Value.absent()
          : Value(controlCode),
      issuedOn: issuedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(issuedOn),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      idType:
          idType == null && nullToAbsent ? const Value.absent() : Value(idType),
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

  ValidPass copyWith(
          {int id,
          int passType,
          String apor,
          int controlCode,
          int issuedOn,
          int validFrom,
          int validUntil,
          String idType,
          String idOrPlate,
          String company,
          String homeAddress}) =>
      ValidPass(
        id: id ?? this.id,
        passType: passType ?? this.passType,
        apor: apor ?? this.apor,
        controlCode: controlCode ?? this.controlCode,
        issuedOn: issuedOn ?? this.issuedOn,
        validFrom: validFrom ?? this.validFrom,
        validUntil: validUntil ?? this.validUntil,
        idType: idType ?? this.idType,
        idOrPlate: idOrPlate ?? this.idOrPlate,
        company: company ?? this.company,
        homeAddress: homeAddress ?? this.homeAddress,
      );
  @override
  String toString() {
    return (StringBuffer('ValidPass(')
          ..write('id: $id, ')
          ..write('passType: $passType, ')
          ..write('apor: $apor, ')
          ..write('controlCode: $controlCode, ')
          ..write('issuedOn: $issuedOn, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('idType: $idType, ')
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
          passType.hashCode,
          $mrjc(
              apor.hashCode,
              $mrjc(
                  controlCode.hashCode,
                  $mrjc(
                      issuedOn.hashCode,
                      $mrjc(
                          validFrom.hashCode,
                          $mrjc(
                              validUntil.hashCode,
                              $mrjc(
                                  idType.hashCode,
                                  $mrjc(
                                      idOrPlate.hashCode,
                                      $mrjc(company.hashCode,
                                          homeAddress.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ValidPass &&
          other.id == this.id &&
          other.passType == this.passType &&
          other.apor == this.apor &&
          other.controlCode == this.controlCode &&
          other.issuedOn == this.issuedOn &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.idType == this.idType &&
          other.idOrPlate == this.idOrPlate &&
          other.company == this.company &&
          other.homeAddress == this.homeAddress);
}

class ValidPassesCompanion extends UpdateCompanion<ValidPass> {
  final Value<int> id;
  final Value<int> passType;
  final Value<String> apor;
  final Value<int> controlCode;
  final Value<int> issuedOn;
  final Value<int> validFrom;
  final Value<int> validUntil;
  final Value<String> idType;
  final Value<String> idOrPlate;
  final Value<String> company;
  final Value<String> homeAddress;
  const ValidPassesCompanion({
    this.id = const Value.absent(),
    this.passType = const Value.absent(),
    this.apor = const Value.absent(),
    this.controlCode = const Value.absent(),
    this.issuedOn = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.idType = const Value.absent(),
    this.idOrPlate = const Value.absent(),
    this.company = const Value.absent(),
    this.homeAddress = const Value.absent(),
  });
  ValidPassesCompanion.insert({
    this.id = const Value.absent(),
    @required int passType,
    @required String apor,
    @required int controlCode,
    @required int issuedOn,
    @required int validFrom,
    @required int validUntil,
    @required String idType,
    @required String idOrPlate,
    this.company = const Value.absent(),
    this.homeAddress = const Value.absent(),
  })  : passType = Value(passType),
        apor = Value(apor),
        controlCode = Value(controlCode),
        issuedOn = Value(issuedOn),
        validFrom = Value(validFrom),
        validUntil = Value(validUntil),
        idType = Value(idType),
        idOrPlate = Value(idOrPlate);
  ValidPassesCompanion copyWith(
      {Value<int> id,
      Value<int> passType,
      Value<String> apor,
      Value<int> controlCode,
      Value<int> issuedOn,
      Value<int> validFrom,
      Value<int> validUntil,
      Value<String> idType,
      Value<String> idOrPlate,
      Value<String> company,
      Value<String> homeAddress}) {
    return ValidPassesCompanion(
      id: id ?? this.id,
      passType: passType ?? this.passType,
      apor: apor ?? this.apor,
      controlCode: controlCode ?? this.controlCode,
      issuedOn: issuedOn ?? this.issuedOn,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      idType: idType ?? this.idType,
      idOrPlate: idOrPlate ?? this.idOrPlate,
      company: company ?? this.company,
      homeAddress: homeAddress ?? this.homeAddress,
    );
  }
}

class $ValidPassesTable extends ValidPasses
    with TableInfo<$ValidPassesTable, ValidPass> {
  final GeneratedDatabase _db;
  final String _alias;
  $ValidPassesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _passTypeMeta = const VerificationMeta('passType');
  GeneratedIntColumn _passType;
  @override
  GeneratedIntColumn get passType => _passType ??= _constructPassType();
  GeneratedIntColumn _constructPassType() {
    return GeneratedIntColumn(
      'pass_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _aporMeta = const VerificationMeta('apor');
  GeneratedTextColumn _apor;
  @override
  GeneratedTextColumn get apor => _apor ??= _constructApor();
  GeneratedTextColumn _constructApor() {
    return GeneratedTextColumn(
      'apor',
      $tableName,
      false,
    );
  }

  final VerificationMeta _controlCodeMeta =
      const VerificationMeta('controlCode');
  GeneratedIntColumn _controlCode;
  @override
  GeneratedIntColumn get controlCode =>
      _controlCode ??= _constructControlCode();
  GeneratedIntColumn _constructControlCode() {
    return GeneratedIntColumn('control_code', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _issuedOnMeta = const VerificationMeta('issuedOn');
  GeneratedIntColumn _issuedOn;
  @override
  GeneratedIntColumn get issuedOn => _issuedOn ??= _constructIssuedOn();
  GeneratedIntColumn _constructIssuedOn() {
    return GeneratedIntColumn(
      'issued_on',
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

  final VerificationMeta _idTypeMeta = const VerificationMeta('idType');
  GeneratedTextColumn _idType;
  @override
  GeneratedTextColumn get idType => _idType ??= _constructIdType();
  GeneratedTextColumn _constructIdType() {
    return GeneratedTextColumn(
      'id_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idOrPlateMeta = const VerificationMeta('idOrPlate');
  GeneratedTextColumn _idOrPlate;
  @override
  GeneratedTextColumn get idOrPlate => _idOrPlate ??= _constructIdOrPlate();
  GeneratedTextColumn _constructIdOrPlate() {
    return GeneratedTextColumn(
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
      true,
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
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        passType,
        apor,
        controlCode,
        issuedOn,
        validFrom,
        validUntil,
        idType,
        idOrPlate,
        company,
        homeAddress
      ];
  @override
  $ValidPassesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'valid_passes';
  @override
  final String actualTableName = 'valid_passes';
  @override
  VerificationContext validateIntegrity(ValidPassesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.passType.present) {
      context.handle(_passTypeMeta,
          passType.isAcceptableValue(d.passType.value, _passTypeMeta));
    } else if (isInserting) {
      context.missing(_passTypeMeta);
    }
    if (d.apor.present) {
      context.handle(
          _aporMeta, apor.isAcceptableValue(d.apor.value, _aporMeta));
    } else if (isInserting) {
      context.missing(_aporMeta);
    }
    if (d.controlCode.present) {
      context.handle(_controlCodeMeta,
          controlCode.isAcceptableValue(d.controlCode.value, _controlCodeMeta));
    } else if (isInserting) {
      context.missing(_controlCodeMeta);
    }
    if (d.issuedOn.present) {
      context.handle(_issuedOnMeta,
          issuedOn.isAcceptableValue(d.issuedOn.value, _issuedOnMeta));
    } else if (isInserting) {
      context.missing(_issuedOnMeta);
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
    if (d.idType.present) {
      context.handle(
          _idTypeMeta, idType.isAcceptableValue(d.idType.value, _idTypeMeta));
    } else if (isInserting) {
      context.missing(_idTypeMeta);
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
    }
    if (d.homeAddress.present) {
      context.handle(_homeAddressMeta,
          homeAddress.isAcceptableValue(d.homeAddress.value, _homeAddressMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ValidPass map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ValidPass.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ValidPassesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.passType.present) {
      map['pass_type'] = Variable<int, IntType>(d.passType.value);
    }
    if (d.apor.present) {
      map['apor'] = Variable<String, StringType>(d.apor.value);
    }
    if (d.controlCode.present) {
      map['control_code'] = Variable<int, IntType>(d.controlCode.value);
    }
    if (d.issuedOn.present) {
      map['issued_on'] = Variable<int, IntType>(d.issuedOn.value);
    }
    if (d.validFrom.present) {
      map['valid_from'] = Variable<int, IntType>(d.validFrom.value);
    }
    if (d.validUntil.present) {
      map['valid_until'] = Variable<int, IntType>(d.validUntil.value);
    }
    if (d.idType.present) {
      map['id_type'] = Variable<String, StringType>(d.idType.value);
    }
    if (d.idOrPlate.present) {
      map['id_or_plate'] = Variable<String, StringType>(d.idOrPlate.value);
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
  $ValidPassesTable createAlias(String alias) {
    return $ValidPassesTable(_db, alias);
  }
}

class InvalidPass extends DataClass implements Insertable<InvalidPass> {
  final int id;
  final int controlCode;
  final String status;
  InvalidPass(
      {@required this.id, @required this.controlCode, @required this.status});
  factory InvalidPass.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return InvalidPass(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      controlCode: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}control_code']),
      status:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  factory InvalidPass.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return InvalidPass(
      id: serializer.fromJson<int>(json['id']),
      controlCode: serializer.fromJson<int>(json['controlCode']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'controlCode': serializer.toJson<int>(controlCode),
      'status': serializer.toJson<String>(status),
    };
  }

  @override
  InvalidPassesCompanion createCompanion(bool nullToAbsent) {
    return InvalidPassesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      controlCode: controlCode == null && nullToAbsent
          ? const Value.absent()
          : Value(controlCode),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  InvalidPass copyWith({int id, int controlCode, String status}) => InvalidPass(
        id: id ?? this.id,
        controlCode: controlCode ?? this.controlCode,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('InvalidPass(')
          ..write('id: $id, ')
          ..write('controlCode: $controlCode, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(controlCode.hashCode, status.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is InvalidPass &&
          other.id == this.id &&
          other.controlCode == this.controlCode &&
          other.status == this.status);
}

class InvalidPassesCompanion extends UpdateCompanion<InvalidPass> {
  final Value<int> id;
  final Value<int> controlCode;
  final Value<String> status;
  const InvalidPassesCompanion({
    this.id = const Value.absent(),
    this.controlCode = const Value.absent(),
    this.status = const Value.absent(),
  });
  InvalidPassesCompanion.insert({
    this.id = const Value.absent(),
    @required int controlCode,
    @required String status,
  })  : controlCode = Value(controlCode),
        status = Value(status);
  InvalidPassesCompanion copyWith(
      {Value<int> id, Value<int> controlCode, Value<String> status}) {
    return InvalidPassesCompanion(
      id: id ?? this.id,
      controlCode: controlCode ?? this.controlCode,
      status: status ?? this.status,
    );
  }
}

class $InvalidPassesTable extends InvalidPasses
    with TableInfo<$InvalidPassesTable, InvalidPass> {
  final GeneratedDatabase _db;
  final String _alias;
  $InvalidPassesTable(this._db, [this._alias]);
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

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedTextColumn _status;
  @override
  GeneratedTextColumn get status => _status ??= _constructStatus();
  GeneratedTextColumn _constructStatus() {
    return GeneratedTextColumn(
      'status',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, controlCode, status];
  @override
  $InvalidPassesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'invalid_passes';
  @override
  final String actualTableName = 'invalid_passes';
  @override
  VerificationContext validateIntegrity(InvalidPassesCompanion d,
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
    if (d.status.present) {
      context.handle(
          _statusMeta, status.isAcceptableValue(d.status.value, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvalidPass map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return InvalidPass.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(InvalidPassesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.controlCode.present) {
      map['control_code'] = Variable<int, IntType>(d.controlCode.value);
    }
    if (d.status.present) {
      map['status'] = Variable<String, StringType>(d.status.value);
    }
    return map;
  }

  @override
  $InvalidPassesTable createAlias(String alias) {
    return $InvalidPassesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ValidPassesTable _validPasses;
  $ValidPassesTable get validPasses => _validPasses ??= $ValidPassesTable(this);
  $InvalidPassesTable _invalidPasses;
  $InvalidPassesTable get invalidPasses =>
      _invalidPasses ??= $InvalidPassesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [validPasses, invalidPasses];
}
