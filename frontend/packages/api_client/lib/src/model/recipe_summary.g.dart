// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeSummary extends RecipeSummary {
  @override
  final String id;
  @override
  final String primaryName;
  @override
  final String? familyKey;

  factory _$RecipeSummary([void Function(RecipeSummaryBuilder)? updates]) =>
      (RecipeSummaryBuilder()..update(updates))._build();

  _$RecipeSummary._(
      {required this.id, required this.primaryName, this.familyKey})
      : super._();
  @override
  RecipeSummary rebuild(void Function(RecipeSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeSummaryBuilder toBuilder() => RecipeSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeSummary &&
        id == other.id &&
        primaryName == other.primaryName &&
        familyKey == other.familyKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, primaryName.hashCode);
    _$hash = $jc(_$hash, familyKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeSummary')
          ..add('id', id)
          ..add('primaryName', primaryName)
          ..add('familyKey', familyKey))
        .toString();
  }
}

class RecipeSummaryBuilder
    implements Builder<RecipeSummary, RecipeSummaryBuilder> {
  _$RecipeSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _primaryName;
  String? get primaryName => _$this._primaryName;
  set primaryName(String? primaryName) => _$this._primaryName = primaryName;

  String? _familyKey;
  String? get familyKey => _$this._familyKey;
  set familyKey(String? familyKey) => _$this._familyKey = familyKey;

  RecipeSummaryBuilder() {
    RecipeSummary._defaults(this);
  }

  RecipeSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _primaryName = $v.primaryName;
      _familyKey = $v.familyKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeSummary other) {
    _$v = other as _$RecipeSummary;
  }

  @override
  void update(void Function(RecipeSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeSummary build() => _build();

  _$RecipeSummary _build() {
    final _$result = _$v ??
        _$RecipeSummary._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RecipeSummary', 'id'),
          primaryName: BuiltValueNullFieldError.checkNotNull(
              primaryName, r'RecipeSummary', 'primaryName'),
          familyKey: familyKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
