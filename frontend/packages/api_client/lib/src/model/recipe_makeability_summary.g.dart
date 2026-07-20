// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_makeability_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeMakeabilitySummary extends RecipeMakeabilitySummary {
  @override
  final bool isNearMiss;
  @override
  final MatchQuality? matchQuality;
  @override
  final BuiltList<RecipeMakeabilityLine> lines;

  factory _$RecipeMakeabilitySummary(
          [void Function(RecipeMakeabilitySummaryBuilder)? updates]) =>
      (RecipeMakeabilitySummaryBuilder()..update(updates))._build();

  _$RecipeMakeabilitySummary._(
      {required this.isNearMiss, this.matchQuality, required this.lines})
      : super._();
  @override
  RecipeMakeabilitySummary rebuild(
          void Function(RecipeMakeabilitySummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeMakeabilitySummaryBuilder toBuilder() =>
      RecipeMakeabilitySummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeMakeabilitySummary &&
        isNearMiss == other.isNearMiss &&
        matchQuality == other.matchQuality &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isNearMiss.hashCode);
    _$hash = $jc(_$hash, matchQuality.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeMakeabilitySummary')
          ..add('isNearMiss', isNearMiss)
          ..add('matchQuality', matchQuality)
          ..add('lines', lines))
        .toString();
  }
}

class RecipeMakeabilitySummaryBuilder
    implements
        Builder<RecipeMakeabilitySummary, RecipeMakeabilitySummaryBuilder> {
  _$RecipeMakeabilitySummary? _$v;

  bool? _isNearMiss;
  bool? get isNearMiss => _$this._isNearMiss;
  set isNearMiss(bool? isNearMiss) => _$this._isNearMiss = isNearMiss;

  MatchQuality? _matchQuality;
  MatchQuality? get matchQuality => _$this._matchQuality;
  set matchQuality(MatchQuality? matchQuality) =>
      _$this._matchQuality = matchQuality;

  ListBuilder<RecipeMakeabilityLine>? _lines;
  ListBuilder<RecipeMakeabilityLine> get lines =>
      _$this._lines ??= ListBuilder<RecipeMakeabilityLine>();
  set lines(ListBuilder<RecipeMakeabilityLine>? lines) => _$this._lines = lines;

  RecipeMakeabilitySummaryBuilder() {
    RecipeMakeabilitySummary._defaults(this);
  }

  RecipeMakeabilitySummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isNearMiss = $v.isNearMiss;
      _matchQuality = $v.matchQuality;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeMakeabilitySummary other) {
    _$v = other as _$RecipeMakeabilitySummary;
  }

  @override
  void update(void Function(RecipeMakeabilitySummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeMakeabilitySummary build() => _build();

  _$RecipeMakeabilitySummary _build() {
    _$RecipeMakeabilitySummary _$result;
    try {
      _$result = _$v ??
          _$RecipeMakeabilitySummary._(
            isNearMiss: BuiltValueNullFieldError.checkNotNull(
                isNearMiss, r'RecipeMakeabilitySummary', 'isNearMiss'),
            matchQuality: matchQuality,
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecipeMakeabilitySummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
