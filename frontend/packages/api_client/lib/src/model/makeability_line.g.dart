// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'makeability_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MakeabilityLine extends MakeabilityLine {
  @override
  final Requirement requirement;
  @override
  final MatchQuality matchQuality;
  @override
  final SatisfiedBy? satisfiedBy;

  factory _$MakeabilityLine([void Function(MakeabilityLineBuilder)? updates]) =>
      (MakeabilityLineBuilder()..update(updates))._build();

  _$MakeabilityLine._(
      {required this.requirement, required this.matchQuality, this.satisfiedBy})
      : super._();
  @override
  MakeabilityLine rebuild(void Function(MakeabilityLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MakeabilityLineBuilder toBuilder() => MakeabilityLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MakeabilityLine &&
        requirement == other.requirement &&
        matchQuality == other.matchQuality &&
        satisfiedBy == other.satisfiedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requirement.hashCode);
    _$hash = $jc(_$hash, matchQuality.hashCode);
    _$hash = $jc(_$hash, satisfiedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MakeabilityLine')
          ..add('requirement', requirement)
          ..add('matchQuality', matchQuality)
          ..add('satisfiedBy', satisfiedBy))
        .toString();
  }
}

class MakeabilityLineBuilder
    implements Builder<MakeabilityLine, MakeabilityLineBuilder> {
  _$MakeabilityLine? _$v;

  RequirementBuilder? _requirement;
  RequirementBuilder get requirement =>
      _$this._requirement ??= RequirementBuilder();
  set requirement(RequirementBuilder? requirement) =>
      _$this._requirement = requirement;

  MatchQuality? _matchQuality;
  MatchQuality? get matchQuality => _$this._matchQuality;
  set matchQuality(MatchQuality? matchQuality) =>
      _$this._matchQuality = matchQuality;

  SatisfiedByBuilder? _satisfiedBy;
  SatisfiedByBuilder get satisfiedBy =>
      _$this._satisfiedBy ??= SatisfiedByBuilder();
  set satisfiedBy(SatisfiedByBuilder? satisfiedBy) =>
      _$this._satisfiedBy = satisfiedBy;

  MakeabilityLineBuilder() {
    MakeabilityLine._defaults(this);
  }

  MakeabilityLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requirement = $v.requirement.toBuilder();
      _matchQuality = $v.matchQuality;
      _satisfiedBy = $v.satisfiedBy?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MakeabilityLine other) {
    _$v = other as _$MakeabilityLine;
  }

  @override
  void update(void Function(MakeabilityLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MakeabilityLine build() => _build();

  _$MakeabilityLine _build() {
    _$MakeabilityLine _$result;
    try {
      _$result = _$v ??
          _$MakeabilityLine._(
            requirement: requirement.build(),
            matchQuality: BuiltValueNullFieldError.checkNotNull(
                matchQuality, r'MakeabilityLine', 'matchQuality'),
            satisfiedBy: _satisfiedBy?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requirement';
        requirement.build();

        _$failedField = 'satisfiedBy';
        _satisfiedBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MakeabilityLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
