// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'makeable_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MakeableResponse extends MakeableResponse {
  @override
  final BuiltList<MakeableRecipe> makeable;
  @override
  final BuiltList<NearMissRecipe> nearMiss;

  factory _$MakeableResponse(
          [void Function(MakeableResponseBuilder)? updates]) =>
      (MakeableResponseBuilder()..update(updates))._build();

  _$MakeableResponse._({required this.makeable, required this.nearMiss})
      : super._();
  @override
  MakeableResponse rebuild(void Function(MakeableResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MakeableResponseBuilder toBuilder() =>
      MakeableResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MakeableResponse &&
        makeable == other.makeable &&
        nearMiss == other.nearMiss;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, makeable.hashCode);
    _$hash = $jc(_$hash, nearMiss.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MakeableResponse')
          ..add('makeable', makeable)
          ..add('nearMiss', nearMiss))
        .toString();
  }
}

class MakeableResponseBuilder
    implements Builder<MakeableResponse, MakeableResponseBuilder> {
  _$MakeableResponse? _$v;

  ListBuilder<MakeableRecipe>? _makeable;
  ListBuilder<MakeableRecipe> get makeable =>
      _$this._makeable ??= ListBuilder<MakeableRecipe>();
  set makeable(ListBuilder<MakeableRecipe>? makeable) =>
      _$this._makeable = makeable;

  ListBuilder<NearMissRecipe>? _nearMiss;
  ListBuilder<NearMissRecipe> get nearMiss =>
      _$this._nearMiss ??= ListBuilder<NearMissRecipe>();
  set nearMiss(ListBuilder<NearMissRecipe>? nearMiss) =>
      _$this._nearMiss = nearMiss;

  MakeableResponseBuilder() {
    MakeableResponse._defaults(this);
  }

  MakeableResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _makeable = $v.makeable.toBuilder();
      _nearMiss = $v.nearMiss.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MakeableResponse other) {
    _$v = other as _$MakeableResponse;
  }

  @override
  void update(void Function(MakeableResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MakeableResponse build() => _build();

  _$MakeableResponse _build() {
    _$MakeableResponse _$result;
    try {
      _$result = _$v ??
          _$MakeableResponse._(
            makeable: makeable.build(),
            nearMiss: nearMiss.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'makeable';
        makeable.build();
        _$failedField = 'nearMiss';
        nearMiss.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MakeableResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
