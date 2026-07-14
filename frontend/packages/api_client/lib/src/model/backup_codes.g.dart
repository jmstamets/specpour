// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_codes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackupCodes extends BackupCodes {
  @override
  final BuiltList<String> backupCodes;

  factory _$BackupCodes([void Function(BackupCodesBuilder)? updates]) =>
      (BackupCodesBuilder()..update(updates))._build();

  _$BackupCodes._({required this.backupCodes}) : super._();
  @override
  BackupCodes rebuild(void Function(BackupCodesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackupCodesBuilder toBuilder() => BackupCodesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackupCodes && backupCodes == other.backupCodes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, backupCodes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackupCodes')
          ..add('backupCodes', backupCodes))
        .toString();
  }
}

class BackupCodesBuilder implements Builder<BackupCodes, BackupCodesBuilder> {
  _$BackupCodes? _$v;

  ListBuilder<String>? _backupCodes;
  ListBuilder<String> get backupCodes =>
      _$this._backupCodes ??= ListBuilder<String>();
  set backupCodes(ListBuilder<String>? backupCodes) =>
      _$this._backupCodes = backupCodes;

  BackupCodesBuilder() {
    BackupCodes._defaults(this);
  }

  BackupCodesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _backupCodes = $v.backupCodes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackupCodes other) {
    _$v = other as _$BackupCodes;
  }

  @override
  void update(void Function(BackupCodesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackupCodes build() => _build();

  _$BackupCodes _build() {
    _$BackupCodes _$result;
    try {
      _$result = _$v ??
          _$BackupCodes._(
            backupCodes: backupCodes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'backupCodes';
        backupCodes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BackupCodes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
