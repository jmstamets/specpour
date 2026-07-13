// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concept_variant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConceptVariant extends ConceptVariant {
  @override
  final String recipeId;
  @override
  final String recipeName;
  @override
  final String differentiatorText;

  factory _$ConceptVariant([void Function(ConceptVariantBuilder)? updates]) =>
      (ConceptVariantBuilder()..update(updates))._build();

  _$ConceptVariant._(
      {required this.recipeId,
      required this.recipeName,
      required this.differentiatorText})
      : super._();
  @override
  ConceptVariant rebuild(void Function(ConceptVariantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConceptVariantBuilder toBuilder() => ConceptVariantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConceptVariant &&
        recipeId == other.recipeId &&
        recipeName == other.recipeName &&
        differentiatorText == other.differentiatorText;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recipeId.hashCode);
    _$hash = $jc(_$hash, recipeName.hashCode);
    _$hash = $jc(_$hash, differentiatorText.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConceptVariant')
          ..add('recipeId', recipeId)
          ..add('recipeName', recipeName)
          ..add('differentiatorText', differentiatorText))
        .toString();
  }
}

class ConceptVariantBuilder
    implements Builder<ConceptVariant, ConceptVariantBuilder> {
  _$ConceptVariant? _$v;

  String? _recipeId;
  String? get recipeId => _$this._recipeId;
  set recipeId(String? recipeId) => _$this._recipeId = recipeId;

  String? _recipeName;
  String? get recipeName => _$this._recipeName;
  set recipeName(String? recipeName) => _$this._recipeName = recipeName;

  String? _differentiatorText;
  String? get differentiatorText => _$this._differentiatorText;
  set differentiatorText(String? differentiatorText) =>
      _$this._differentiatorText = differentiatorText;

  ConceptVariantBuilder() {
    ConceptVariant._defaults(this);
  }

  ConceptVariantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recipeId = $v.recipeId;
      _recipeName = $v.recipeName;
      _differentiatorText = $v.differentiatorText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConceptVariant other) {
    _$v = other as _$ConceptVariant;
  }

  @override
  void update(void Function(ConceptVariantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConceptVariant build() => _build();

  _$ConceptVariant _build() {
    final _$result = _$v ??
        _$ConceptVariant._(
          recipeId: BuiltValueNullFieldError.checkNotNull(
              recipeId, r'ConceptVariant', 'recipeId'),
          recipeName: BuiltValueNullFieldError.checkNotNull(
              recipeName, r'ConceptVariant', 'recipeName'),
          differentiatorText: BuiltValueNullFieldError.checkNotNull(
              differentiatorText, r'ConceptVariant', 'differentiatorText'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
