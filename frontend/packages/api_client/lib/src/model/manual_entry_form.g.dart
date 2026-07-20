// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_entry_form.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ManualEntryForm extends ManualEntryForm {
  @override
  final String? prefilledIngredientId;
  @override
  final String? prefilledIngredientName;

  factory _$ManualEntryForm([void Function(ManualEntryFormBuilder)? updates]) =>
      (ManualEntryFormBuilder()..update(updates))._build();

  _$ManualEntryForm._(
      {this.prefilledIngredientId, this.prefilledIngredientName})
      : super._();
  @override
  ManualEntryForm rebuild(void Function(ManualEntryFormBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManualEntryFormBuilder toBuilder() => ManualEntryFormBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManualEntryForm &&
        prefilledIngredientId == other.prefilledIngredientId &&
        prefilledIngredientName == other.prefilledIngredientName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, prefilledIngredientId.hashCode);
    _$hash = $jc(_$hash, prefilledIngredientName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ManualEntryForm')
          ..add('prefilledIngredientId', prefilledIngredientId)
          ..add('prefilledIngredientName', prefilledIngredientName))
        .toString();
  }
}

class ManualEntryFormBuilder
    implements Builder<ManualEntryForm, ManualEntryFormBuilder> {
  _$ManualEntryForm? _$v;

  String? _prefilledIngredientId;
  String? get prefilledIngredientId => _$this._prefilledIngredientId;
  set prefilledIngredientId(String? prefilledIngredientId) =>
      _$this._prefilledIngredientId = prefilledIngredientId;

  String? _prefilledIngredientName;
  String? get prefilledIngredientName => _$this._prefilledIngredientName;
  set prefilledIngredientName(String? prefilledIngredientName) =>
      _$this._prefilledIngredientName = prefilledIngredientName;

  ManualEntryFormBuilder() {
    ManualEntryForm._defaults(this);
  }

  ManualEntryFormBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _prefilledIngredientId = $v.prefilledIngredientId;
      _prefilledIngredientName = $v.prefilledIngredientName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManualEntryForm other) {
    _$v = other as _$ManualEntryForm;
  }

  @override
  void update(void Function(ManualEntryFormBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManualEntryForm build() => _build();

  _$ManualEntryForm _build() {
    final _$result = _$v ??
        _$ManualEntryForm._(
          prefilledIngredientId: prefilledIngredientId,
          prefilledIngredientName: prefilledIngredientName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
