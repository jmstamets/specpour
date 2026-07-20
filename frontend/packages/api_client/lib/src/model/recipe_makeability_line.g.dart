// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_makeability_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeMakeabilityLine extends RecipeMakeabilityLine {
  @override
  final String requirementIngredientId;
  @override
  final String? requirementIngredientName;
  @override
  final MatchQuality matchQuality;
  @override
  final String? satisfiedByIngredientId;
  @override
  final String? satisfiedByIngredientName;

  factory _$RecipeMakeabilityLine(
          [void Function(RecipeMakeabilityLineBuilder)? updates]) =>
      (RecipeMakeabilityLineBuilder()..update(updates))._build();

  _$RecipeMakeabilityLine._(
      {required this.requirementIngredientId,
      this.requirementIngredientName,
      required this.matchQuality,
      this.satisfiedByIngredientId,
      this.satisfiedByIngredientName})
      : super._();
  @override
  RecipeMakeabilityLine rebuild(
          void Function(RecipeMakeabilityLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeMakeabilityLineBuilder toBuilder() =>
      RecipeMakeabilityLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeMakeabilityLine &&
        requirementIngredientId == other.requirementIngredientId &&
        requirementIngredientName == other.requirementIngredientName &&
        matchQuality == other.matchQuality &&
        satisfiedByIngredientId == other.satisfiedByIngredientId &&
        satisfiedByIngredientName == other.satisfiedByIngredientName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requirementIngredientId.hashCode);
    _$hash = $jc(_$hash, requirementIngredientName.hashCode);
    _$hash = $jc(_$hash, matchQuality.hashCode);
    _$hash = $jc(_$hash, satisfiedByIngredientId.hashCode);
    _$hash = $jc(_$hash, satisfiedByIngredientName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeMakeabilityLine')
          ..add('requirementIngredientId', requirementIngredientId)
          ..add('requirementIngredientName', requirementIngredientName)
          ..add('matchQuality', matchQuality)
          ..add('satisfiedByIngredientId', satisfiedByIngredientId)
          ..add('satisfiedByIngredientName', satisfiedByIngredientName))
        .toString();
  }
}

class RecipeMakeabilityLineBuilder
    implements Builder<RecipeMakeabilityLine, RecipeMakeabilityLineBuilder> {
  _$RecipeMakeabilityLine? _$v;

  String? _requirementIngredientId;
  String? get requirementIngredientId => _$this._requirementIngredientId;
  set requirementIngredientId(String? requirementIngredientId) =>
      _$this._requirementIngredientId = requirementIngredientId;

  String? _requirementIngredientName;
  String? get requirementIngredientName => _$this._requirementIngredientName;
  set requirementIngredientName(String? requirementIngredientName) =>
      _$this._requirementIngredientName = requirementIngredientName;

  MatchQuality? _matchQuality;
  MatchQuality? get matchQuality => _$this._matchQuality;
  set matchQuality(MatchQuality? matchQuality) =>
      _$this._matchQuality = matchQuality;

  String? _satisfiedByIngredientId;
  String? get satisfiedByIngredientId => _$this._satisfiedByIngredientId;
  set satisfiedByIngredientId(String? satisfiedByIngredientId) =>
      _$this._satisfiedByIngredientId = satisfiedByIngredientId;

  String? _satisfiedByIngredientName;
  String? get satisfiedByIngredientName => _$this._satisfiedByIngredientName;
  set satisfiedByIngredientName(String? satisfiedByIngredientName) =>
      _$this._satisfiedByIngredientName = satisfiedByIngredientName;

  RecipeMakeabilityLineBuilder() {
    RecipeMakeabilityLine._defaults(this);
  }

  RecipeMakeabilityLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requirementIngredientId = $v.requirementIngredientId;
      _requirementIngredientName = $v.requirementIngredientName;
      _matchQuality = $v.matchQuality;
      _satisfiedByIngredientId = $v.satisfiedByIngredientId;
      _satisfiedByIngredientName = $v.satisfiedByIngredientName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeMakeabilityLine other) {
    _$v = other as _$RecipeMakeabilityLine;
  }

  @override
  void update(void Function(RecipeMakeabilityLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeMakeabilityLine build() => _build();

  _$RecipeMakeabilityLine _build() {
    final _$result = _$v ??
        _$RecipeMakeabilityLine._(
          requirementIngredientId: BuiltValueNullFieldError.checkNotNull(
              requirementIngredientId,
              r'RecipeMakeabilityLine',
              'requirementIngredientId'),
          requirementIngredientName: requirementIngredientName,
          matchQuality: BuiltValueNullFieldError.checkNotNull(
              matchQuality, r'RecipeMakeabilityLine', 'matchQuality'),
          satisfiedByIngredientId: satisfiedByIngredientId,
          satisfiedByIngredientName: satisfiedByIngredientName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
